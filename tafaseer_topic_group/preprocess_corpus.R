#!/usr/bin/env Rscript
# Only runs on R >= 3.3.1
# Requires: install.packages(c('rvest', 'XML', 'magrittr', 'stringr', 'jsonlite', 'yaml', 'httr'))
# Remember: every line of code one liability!

for (lib in c('rvest', 'stringr', 'jsonlite', 'yaml', 'httr')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

source(file.path('lib', 'grepx.R'))

path.raw = file.path('..', 'corpora', 'altafsir_com')
path.extracted = file.path('..', 'corpora', 'altafsir_com_corpus', 'extracted')
path.temp = file.path('/', 'tmp', 'preprocess_corpus_R')

read_files <- function(path.raw, path.extracted, path.temp)
{
  # Go through sura directories, save sura number
  #   Go through aaya directories, save aaya number
  #     Go through madhab directories, save madhab number
  #       Go through tafsir directories, save tafsir number
  for (path in list.dirs(path.raw)) {
    if (grepl('/tafsir_\\d{2}', path)) {
      data = list() # Whither to put our treasure, arrr!
      regx = 'quran_(?<sura>\\d{3})/aaya_(?<aaya>\\d{3})/madhab_(?<madhab>\\d{2})/tafsir_(?<tafsir>\\d{2})' 
      data$location = grepx(regx, path)[[1]] # See lib/grepx.R! # Attn: characters, not integers returned!
      # Go through page files
      for (infile in list.files(path, full.names=TRUE)) {
        raw_html = read_html(infile, encoding='utf8')
        regx = 'page_(?<page>\\d{2})\\.html'
        page = as.numeric(grepx(regx, infile)[[1]]$page)
        # Open first page file
        if (page == 1) {
          message(paste('---\nProcessing', infile))
          # Figure out meta data
          #   Save tafsir name
          #   Save mufassir name
          #   Save mufassir death date
          data$meta = extract_meta(raw_html)
          # Figure out first block of aayaat, ignore it
          #   Download the ayah given by directory numbers via GQ API
          data$aaya = gq_get_aaya(
            path.temp,
            as.numeric(data$location$sura), 
            as.numeric(data$location$aaya)
          )
          # Go through subsequent result blocks
          #   Figure out what each block is
          #     With an appropriate tag, add it to the tafsir text
          data$text = c(extract_text(raw_html))
        } else {
          message(paste('Processing', infile))
          # Keep going through page files, if any
          #   Figure out first block of aayaat, ignore it
          #   Go through subsequent result blocks
          #     Figure out what each block is
          #       With an appropriate tag, add it to the tafsir text
          text = extract_text(raw_html)
          if (length(text) > 0) data$text = c(data$text, text)
        }
      }
      # Join all pages together into one string, preserving the information of where they were separated
      # TODO: Make it so only files get written where there is text present!
      data$text = paste(paste('<section>', data$text, sep='', collapse='</section>'), '</section>', sep='')
      # Save the whole shebang into quran_n/aaya_n/madhab_n/tafsir_n.dat
      path.out = file.path(path.extracted, 
        sprintf('quran_%s',  data$location$sura  ),
        sprintf('aaya_%s',   data$location$aaya  ),
        sprintf('madhab_%s', data$location$madhab))
      dir.create(path.out, showWarnings=FALSE, recursive=TRUE)
      outfile = file.path(path.out, sprintf('tafsir_%s.yaml', data$location$tafsir))
      write(as.yaml(data), outfile)
      message(paste('Wrote', outfile))
    }
  }
}

extract_text <- function(raw_html)
{
  text <- raw_html %>%
    html_nodes('#SearchResults') %>%
    html_text()
}

extract_meta <- function(raw_html)
{
  meta <- raw_html %>%
    html_nodes('.TextArabic > .TextResultArabic:nth-child(1)') %>%
    html_text() %>%
    head(1) # Only selected nth-child(1), so 1 result max.
  if (!is.null(meta)) {
    regx = "\\*\\s*(?<title>.*?) ?\\/ ?(?<author>\\s?.*?)\\s?\\(\\D*(?<year>\\d{3,4}).*\\)"
    meta = grepx(regx, meta)
    if (length(meta) > 0) return(meta[[1]]) # Only return something if we were able to find something.
  }
}

gq_get_aaya <- function(path.temp, sura, aaya)
{
  path.cache = file.path(path.temp, 'aayat')
  dir.create(path.cache, showWarnings=FALSE, recursive=TRUE)
  file = file.path(path.cache, sprintf('%s,%s', sura, aaya))
  if (file.exists(file)) {
    return(paste(scan(file, what='character', quiet=TRUE), collapse=' '))
  } else {
    url = sprintf('http://api.globalquran.com/ayah/%s:%s/quran-simple', sura, aaya)
    json = fromJSON(url)
    verse = json$quran$`quran-simple`$`1`$verse
    if (!is.null(verse)) {
      write(verse, file)
      return(verse)
    }
  }
}

read_files(path.raw, path.extracted, path.temp)

#!/usr/bin/env Rscript
# Only runs on R >= 3.3.1
# Requires: install.packages(c('rvest', 'XML', 'magrittr', 'stringr', 'jsonlite', 'yaml', 'httr', 'optparse', 'stringi'))
# Remember: every line of code one liability!

for (lib in c('rvest', 'stringr', 'jsonlite', 'yaml', 'httr', 'optparse', 'stringi')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

# Home-made libraries for the win!
source(file.path('lib', 'grepx.R'))

path.raw = file.path('..', 'corpora', 'altafsir_com')
path.extracted = file.path('..', 'corpora', 'altafsir_com_corpus', 'extracted')
path.temp = file.path('tmp') # Right here, why not...

read_files <- function(path.raw, path.extracted, path.temp, force=FALSE)
{
  t0 = proc.time()
  # Go through sura directories, save sura number
  #   Go through aaya directories, save aaya number
  #     Go through madhab directories, save madhab number
  #       Go through tafsir directories, save tafsir number
  for (path in list.dirs(path.raw)) {
    if (grepl('/tafsir_\\d{2}', path)) {
      data = list() # Whither to put our treasure, arrr!
      regx = 'quran_(?<sura>\\d{3})/aaya_(?<aaya>\\d{3})/madhab_(?<madhab>\\d{2})/tafsir_(?<tafsir>\\d{2})' 
      data$position = grepx(regx, path)[[1]] # See lib/grepx.R! # Attn: characters, not integers returned!
      display_status_message(t0, data$position)
      # Go through page files
      path.out = file.path(path.extracted, 
        sprintf('quran_%s',  data$position$sura  ),
        sprintf('aaya_%s',   data$position$aaya  ),
        sprintf('madhab_%s', data$position$madhab))
      outfile = file.path(path.out, sprintf('tafsir_%s.yml', data$position$tafsir))
      if (file.exists(outfile) && !force) {
        message('(Skipping...)')
        next
      } else {
        for (infile in list.files(path, full.names=TRUE)) {
          raw_html = read_html(infile, encoding='utf8')
          regx = 'page_(?<page>\\d{2})\\.html'
          page = as.numeric(grepx(regx, infile)[[1]]$page)
          message(paste('Processing', infile))
          # Open first page file
          if (page == 1) {
            # Figure out meta data
            #   Save tafsir name
            #   Save mufassir name
            #   Save mufassir death date
            data$meta = extract_meta(raw_html)
            # Figure out first block of aayaat, ignore it
            #   Download the ayah given by directory numbers via GQ API
            data$aaya = gq_get_aaya(
              path.temp,
              as.numeric(data$position$sura), 
              as.numeric(data$position$aaya)
            )
            # Go through subsequent result blocks
            #   Figure out what each block is
            #     With an appropriate tag, add it to the tafsir text
            data$text = c(extract_text(raw_html))
          } else {
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
        if (stri_length(data$text) == 0) next # But where the tafaseer text is empty, skip ahead
        data$text = paste(paste('<section>', data$text, sep='', collapse='</section>'), '</section>', sep='')
        # Save the whole shebang into quran_n/aaya_n/madhab_n/tafsir_n.yml
        message(paste('Writing', outfile))
        dir.create(path.out, showWarnings=FALSE, recursive=TRUE)
        write(as.yaml(data), outfile)
      }
    }
  }
}

display_status_message <- function(t0, position) {
  delim = rep('–', 115)
  message(
    c("\033[2J","\033[0;0H"), 
    delim, '\n Working…\n', 
    delim,
    sprintf('\nSura:\t%s | ',  position$sura),
    sprintf('Ayah:\t%s | ',    position$aaya),
    sprintf('Madhab:\t%s | ', position$madhab),
    sprintf('Tafsir:\t%s | ',  position$tafsir),
    sprintf('Time elapsed:\t%.0f min\n', (proc.time() - t0)[3] / 60),
    delim
  ) 
}

extract_text <- function(raw_html)
{
  text <- raw_html %>%
    html_nodes('#SearchResults') %>%
    xml_contents()
  trimws(gsub('[\r\n]', '', toString(text)))
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
  path.cache = file.path(path.temp, 'aayaat')
  dir.create(path.cache, showWarnings=FALSE, recursive=TRUE)
  file = file.path(path.cache, sprintf('%s,%s', sura, aaya))
  if (file.exists(file)) {
    return(paste(scan(file, what='character', quiet=TRUE), collapse=' ')) # No simple file.open or so in R?
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

option_list = list(
  make_option(
    c('-f', '--force'),
    action='store_true', default=FALSE,
    help='Overwrite already existing files [default %default]'
  )
); o = parse_args(OptionParser(option_list=option_list))

read_files(path.raw, path.extracted, path.temp, o$force)

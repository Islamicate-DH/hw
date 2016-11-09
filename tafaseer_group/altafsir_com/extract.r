#!/usr/bin/env Rscript
# Only runs on R >= 3.3.1
# Requires: install.packages(c('rvest', 'XML', 'magrittr', 'stringr', 'jsonlite', 'yaml', 'httr', 'optparse', 'stringi'))
# Remember: every line of code one liability!

for (lib in c('rvest', 'stringr', 'jsonlite', 'yaml', 'httr', 'optparse', 'stringi')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

# Home-made libraries for the win!
source(file.path('lib', 'grepx.r'))

paths = list()
paths$downloaded <- file.path('..', '..', 'corpora', 'altafsir_com', 'downloaded')
paths$extracted  <- file.path('..', '..', 'corpora', 'altafsir_com', 'extracted')
paths$quran      <- file.path('..', '..', 'corpora', 'the_quran_by_aaya')

read_dirs <- function(paths, force=FALSE)
{
  t0 = proc.time()
  # Go through sura directories, save sura number
  for (p1 in Sys.glob(file.path(paths$downloaded, 'quran_???'))) {
    # Go through aaya directories, save aaya number
    for (p2 in Sys.glob(file.path(p1, 'aaya_???'))) {
      # Go through madhab directories, save madhab number
      for (p3 in Sys.glob(file.path(p2, 'madhab_??'))) {
        # Go through tafsir directories, save tafsir number
        for (path in Sys.glob(file.path(p3, 'tafsir_??'))) {
          message(path)
          paths$infile <- path
          data = list() # Whither to put our treasure, arrr!
          regx = 'quran_(?<sura>\\d{3})/aaya_(?<aaya>\\d{3})/madhab_(?<madhab>\\d{2})/tafsir_(?<tafsir>\\d{2})' 
          data$position = grepx(regx, path)[[1]] # See lib/grepx.R! # Attn: characters, not integers returned!
          display_status_message(t0, data$position)
          # Go through page files
          paths$outpath = file.path(paths$extracted, 
            sprintf('quran_%s',  data$position$sura  ),
            sprintf('aaya_%s',   data$position$aaya  ),
            sprintf('madhab_%s', data$position$madhab))
          paths$outfile <- file.path(paths$outpath, sprintf('tafsir_%s.yml', data$position$tafsir))
          if (file.exists(paths$outfile) && !force) {
            message(paste(paths$outfile, 'exists, skipping infile dir...'))
          } else {
            read_files(paths, data)
          }
        } # path
      } # p3
    } # p2
  } # p1
}

read_files <- function(paths, data)
{
  for (infile in list.files(paths$infile, full.names=TRUE)) {
    message(paste('Processing', infile))
    raw_html = read_html(infile, encoding='utf8')
    regx = 'page_(?<page>\\d{2})\\.html'
    page = as.numeric(grepx(regx, infile)[[1]]$page)
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
        paths$quran,
        as.numeric(data$position$sura), 
        as.numeric(data$position$aaya)
      )
      # Go through subsequent result blocks
      #   Figure out what each block is
      #     With an appropriate tag, add it to the tafsir text
      data$text = c(extract_text(raw_html))
    } else {
      message('\t(subsequent page)')
      # Keep going through page files, if any
      #   Figure out first block of aayaat, ignore it
      #   Go through subsequent result blocks
      #     Figure out what each block is
      #       With an appropriate tag, add it to the tafsir text
      text = extract_text(raw_html)
      if (length(text) > 0) data$text = c(data$text, text)
    }
  }
  write_file(paths, data) # If there was no tafsir text, that field will be missing,
                          # indicating that that particular aaya was of no concern
                          # to the mufassir.
}

write_file <- function(paths, data)
{
  # Join all pages together into one string, preserving the information of where they were separated
  data$text = paste(paste('<section>', data$text, sep='', collapse='</section>'), '</section>', sep='')
  # Save the whole shebang into quran_n/aaya_n/madhab_n/tafsir_n.yml
  message(paste('Writing', paths$outfile))
  dir.create(paths$outpath, showWarnings=FALSE, recursive=TRUE)
  write(as.yaml(data), paths$outfile)
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

gq_get_aaya <- function(path, sura, aaya)
{
  file = file.path(path, sprintf('%s,%s', sura, aaya))
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

read_dirs(paths, o$force)

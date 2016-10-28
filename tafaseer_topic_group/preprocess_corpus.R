#!/usr/bin/env Rscript
# Only runs on R >= 3.3.1
# Requires: install.packages(c('rvest', 'XML', 'magrittr', 'stringr'))
# Remember: every line of code one liability!

for (lib in c('rvest', 'stringr')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

path.raw = file.path('..', 'corpora', 'altafsir_com')
path.extracted = file.path('..', 'corpora', 'altafsir_com_corpus', 'extracted')

read_files <- function(path.raw, path.extracted)
{
  files = list.files(path.raw, pattern='page*',
                     recursive=TRUE, full.names=TRUE)
  
  # Go through sura directories, save sura number
  #   Go through aaya directories, save aaya number
  #     Go through madhab directories, save madhab number
  #       Go through tafsir directories, save tafsir number
  #       |
  # Go through page files
  #   |
  #   Open first page file
  #     Figure out meta data
  #       Save tafsir name
  #       Save mufassir name
  #       Save mufassir death date
  #     Figure out first block of aayaat, ignore it
  #       Download the ayah given by directory numbers via GQ API
  #     Go through subsequent result blocks
  #       Figure out what each block is
  #         With an appropriate tag, add it to the tafsir text
  #   Keep going through page files, if any
  #     Figure out first block of aayaat, ignore it
  #     Go through subsequent result blocks
  #       Figure out what each block is
  #         With an appropriate tag, add it to the tafsir text
  #         |
  #   Save the whole shebang into quran_n/aaya_n/madhab_n/tafsir_n.txt
}

extract_meta <- function(raw_html)
{
  meta <- raw_html %>%
    html_nodes('#DispFrame .TextResultArabic') %>%
    html_text() %>%
    head(1) # Meaning "nth-child(1)" - not sure if that'd work...
  regex = "\\*\\s*(?<title>.*?) ?\\/ ?(?<author>\\s?.*?)\\s?\\(\\D*(?<year>\\d{3,4}).*\\)"
  meta = unlist(regmatches(meta, regexec(regex, meta, perl=TRUE)))
  message('\tTitle: ', meta[2])
  message('\tAuthor: ', meta[3])
  message('\tYear: ', meta[4])
  return(meta[2:4])
}

read_files(path.raw, path.extracted)

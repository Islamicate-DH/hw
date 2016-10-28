#!/usr/bin/env Rscript
# Only runs on R >= 3.3.1
# Requires: install.packages(c('rvest', 'XML', 'magrittr', 'stringr'))
# Remember: every line of code one liability!

for (lib in c('rvest', 'stringr')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

path.raw = file.path('..', '..', 'corpora', 'altafsir_com', 'raw')
path.extracted = file.path('..', '..', 'corpora', 'altafsir_com', 'extracted')

read_files <- function(path.raw, path.extracted)
{
  files = list.files(path.raw, pattern='page*', 
                     recursive=TRUE, full.names=TRUE)
  sapply(files, function(file) {
    html = read_html(file)
    message(file)
    text.meta = extract_meta(html) # Returns vector: 1=title,2=author,3=year
    text.reference_ayah = extract_ayah(html) # Returns blank text string
    text.tafsir_page = extract_tafsir(html) # Returns HTML string
    # TODO: Implement me!
  })
}

# Notes for scraping altafsir.com
# ===============================
#
# Inside #DispFrame, the following is true:
#
# * first table doesn't interest us
#
# * first .TextResultArabic is tafsir name and author
#
# * #AyahText contains ayah which the tafsir talks about
#
# * from the first to the last occurance of all .TextResultArabic
#   contained within <div align='right' dir='rtl'>, that's
#   the actual tafsir text!
#
# * second table (inside of which is the only <center>!), that's
#   the list of page numbers

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

extract_ayah <- function(raw_html)
{
  ayah <- raw_html %>%
    html_nodes('#AyahText .TextAyah') %>%
    html_text()
  message('\tAyah: ', paste(strtrim(ayah, 35), '…'))
  return(trimws(ayah))
}

extract_tafsir <- function(raw_html)
{
  tafsir <- raw_html %>%
    html_nodes('#SearchResults font font') %>%
    html_text()
  tafsir = paste(tafsir, collapse=' ')
  message('\tTafsir: ', paste(strtrim(tafsir, 35), 
          '… (~', str_count(tafsir, '\\S+'), 'words total)'))
  return(trimws(tafsir))
}
           
#message('\tComplete. Around ', str_count(text.tafsir, '\\S+'), ' words pasted.')
#save_to_disk(c(madrasa, tafsir, sura, ayah), text.meta, text.ayah, text.tafsir)      
          
#save_to_disk <- function(pos, data)
#{
#  path = file.path('corpus', 'altafsir.com', 'raw',
#         sprintf('quran_%s,%s-school_%s-tafsir_%s',
#         pos[1], pos[2], pos[3], pos[4])) # Logical order!
#  file = file.path(path, sprintf('page_%s.html', pos[5]))
#  dir.create(path, showWarnings = FALSE, recursive = TRUE)
#  write(data, file)
#  message('\tSaved page to ', file)
#  # Position marker so we can pick up where we left off
#  file = file.path('corpus', 'altafsir.com', 'raw', 'scraper_pos.dat')
#  pos  = sprintf('%s,%s,%s,%s', pos[3], pos[4], pos[1], pos[2]) # Website's order!
#  write(pos, file)
#}

#save_to_disk <- function(pos, meta, ayah, tafsir)
#{
#  # Ayah text first
#  path = file.path('corpus', 'altafsir.com', 'ayaat')
#  file = file.path(path, sprintf('%s:%s.txt', pos[3], pos[4]))
#  dir.create(path, showWarnings = FALSE, recursive = TRUE)
#  write(ayah, file)
#  message('\tSaved ayah to ', file)
#  # Now the tafsir text
#  path = file.path('corpus', 'altafsir.com', 'tafaseer')
#  file = file.path(path, sprintf('%s:%s - %s (%s).txt', pos[3], pos[4], pos[2], pos[3]))
#  dir.create(path, showWarnings = FALSE, recursive = TRUE)
#  write(tafsir, file)
#  message('\tSaved tafsir to ', file)
#  # Position marker so we can pick up where we left off
#  file = file.path('corpus', 'altafsir.com', 'scraper_pos.dat')
#  pos  = sprintf('%s,%s,%s,%s', pos[1], pos[2], pos[3], pos[4])
#  write(pos, file)
#}

read_files(path.raw, path.extracted)

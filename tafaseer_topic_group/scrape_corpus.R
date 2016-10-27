#!/usr/bin/env Rscript
# Requires: urltools, rvest, XML, magrittr, stringr

for (lib in c('urltools', 'rvest', 'stringr')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

default_url = 'http://www.altafsir.com/Tafasir.asp?tMadhNo=0&tTafsirNo=0&tSoraNo=1&tAyahNo=1&tDisplay=yes&LanguageID=1'
parameters  = param_get(default_url, c('tMadhNo', 'tTafsirNo', 'tSoraNo', 'tAyahNo'))

number_of_madaris = 10
number_of_suwwar  = 114

# Thank you Christoph!
number_of_tafaseer_per_madrasa = c(8, 20, 10, 2, 7, 7, 4, 3, 5, 2) 
number_of_ayaat_per_sura       = c(7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99, 128, 111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34, 30, 73, 54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29, 18, 45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12, 12, 30, 52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25, 22, 17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11, 11, 8, 3, 9, 5, 4, 7, 3, 6, 3, 5, 4, 5, 6)

download_all_tafaseer <- function(url)
{
  # The mother of all nested loops. Makes Ross' and Robert's hearts cringe,
  # but works.  It would be more R-ish to use expand.grid on the `parameters'
  # data grid, unfortunately urltools does not seem to provide the necessary 
  # functions to do so.
  # Major thanks to Franziska for all the sweets that made this possible!
  for (madrasa in 1:number_of_madaris) {
    for (tafsir in 1:number_of_tafaseer_per_madrasa[madrasa]) {
      for (sura in 1:number_of_suwwar) {
        for (ayah in 1:number_of_ayaat_per_sura[sura]) {
          url = param_set(url, 'tMadhNo',   madrasa)
          url = param_set(url, 'tSoraNo',   sura)
          url = param_set(url, 'tTafsirNo', tafsir)
          url = param_set(url, 'tAyahNo',   ayah)
          delim = rep('–', 115)
          message(
            c("\033[2J","\033[0;0H"), delim, '\n Working…\n', delim,
            sprintf('\n Madrasa:\t%s/%s | ', madrasa, number_of_madaris),
            sprintf('Tafsir:\t%s/%s | ', tafsir, number_of_tafaseer_per_madrasa[madrasa]),
            sprintf('Sura:\t%s/%s | ', sura, number_of_suwwar),
            sprintf('Ayah:\t%s/%s\n', ayah, number_of_ayaat_per_sura[sura]),
            delim, '\n', url)
          # Page 1
          raw_html = read_html(url)
          n = extract_number_of_pages(raw_html)
          text.meta = extract_meta(raw_html) # Returns vector: 1=title,2=author,3=year
          text.ayah   = extract_ayah(raw_html)
          text.tafsir = extract_tafsir(raw_html)
          # Pages 2-n
          if (n > 2) {
            for (page in 2:n) {
              url = param_set(url, 'Page', page)
              message('\t(Page ', page, ')')
              raw_html = read_html(url)
              text.tafsir = paste(text.tafsir, '\\n\\n', extract_tafsir(raw_html))
            }
          }
          message('\tComplete. Around ', str_count(text.tafsir, '\\S+'), ' words pasted.')
          save_to_disk(c(madrasa, tafsir, sura, ayah), text.meta, text.ayah, text.tafsir)
          url = param_set(url, 'Page', 1) # Reset page number!
        }
      } 
    } 
  }
}

save_to_disk <- function(location, meta, ayah, tafsir)
{
  # Ayah text first
  path = file.path('corpus', 'altafsir.com', 'ayaat')
  file = file.path(path, sprintf('%s:%s.txt', location[3], location[4]))
  dir.create(path, showWarnings = FALSE, recursive = TRUE)
  write(ayah, file)
  message('\tSaved ayah to ', file)
  # Now the tafseer text
  path = file.path('corpus', 'altafsir.com', 'tafaseer')
  file = file.path(path, sprintf('%s:%s - %s (%s).txt', location[3], location[4], meta[2], meta[3]))
  dir.create(path, showWarnings = FALSE, recursive = TRUE)
  write(tafsir, file)
  message('\tSaved tafsir to ', file)
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

extract_number_of_pages <- function(raw_html)
{
  n <- raw_html %>%
    html_nodes('#DispFrame center u') %>%
    html_text() %>%
    as.numeric()
  # This is tricky in R: a NULL or NA value could result!
  if (length(n) < 1) {
    n = 0
  } else {
    n = n[length(n)]
  }
  message('\tNumber of pages: ', n)
  return(n)
}

extract_meta <- function(raw_html)
{
  meta <- raw_html %>%
    html_nodes('#DispFrame .TextResultArabic') %>%
    html_text()
  meta = meta[1] # nth-child(1) ... not sure if that'd work...
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
  message('\tAyah: ', ayah)
  return(ayah)
}

extract_tafsir <- function(raw_html)
{
  # TODO: Test whether the below selector truly works. I have doubts.
  tafsir <- raw_html %>%
    html_nodes('#SearchResults font font') %>%
    html_text()
  tafsir = paste(tafsir, collapse=' ')
  message('\tTafsir: ', paste(strtrim(tafsir, 35), 
          '… (~', str_count(tafsir, '\\S+'), 'words total)'))
  return(tafsir)
}

# Let's rock'n'roll!
download_all_tafaseer(default_url)

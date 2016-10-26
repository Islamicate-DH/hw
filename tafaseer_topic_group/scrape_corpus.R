#!/usr/bin/env Rscript

library(urltools)
library(rvest)

default_url = 'http://www.altafsir.com/Tafasir.asp?tMadhNo=0&tTafsirNo=0&tSoraNo=1&tAyahNo=1&tDisplay=yes&LanguageID=1'
parameters  = param_get(default_url, c('tMadhNo', 'tTafsirNo', 'tSoraNo', 'tAyahNo'))

number_of_madaris = 10
number_of_suwwar  = 114

# Thank you Christoph!
number_of_tafaseer_per_madrasa = c(8, 20, 10, 2, 7, 7, 4, 3, 5, 2) 
number_of_ayaat_per_sura       = c(7, 286, 200, 176, 120, 165, 206, 755, 129, 109, 123, 111, 43, 52, 99, 128, 111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34, 30, 73, 54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29, 18, 45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12, 12, 30, 52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25, 22, 17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11, 11, 8, 3, 9, 5, 4, 7, 3, 6, 3, 5, 4, 5, 6)

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
          message(c('Downloading ', url))
          # Page 1
          raw_html = read_html(url)
          n = extract_number_of_pages(raw_html)
          text.author = extract_author(raw_html)
          text.ayah   = extract_ayah(raw_html)
          message(c("Author: ", text.author)) # Just for debugging
          message(c("Ayah: ", text.ayah))     # Just for debugging
          text.tafseer = extract_tafseer(raw_html)
          # Pages 2-n
          for (page in 2:n) {
            url = param_set(url, 'Page', page)
            raw_html = read_html(url)
            text.tafseer = paste(text.tafseer, '\\n', extract_tafseer(raw_html))
          }
          message(c("Tafseer: ", text.tafseer)) # Just for debugging
          # TODO: save text to files in a sensible manner
        }
      } 
    } 
  }
}

extract_number_of_pages <- function(raw_html)
{
  # TODO: implement me! (see notes below...)
  message("Extracting number of pages")
  return(2)
}

extract_author <- function(raw_html)
{
  # TODO: implement me!
  return("Albert Einstein")
}

extract_ayah <- function(raw_html)
{
  # TODO: implement me!
  return("بسم لله الرحمن الرحيم")
}

extract_tafseer <- function(raw_html)
{
  message("Extracting text snippets")
  # TODO: implement me!
  #
  # inside DispFrame id, the following is true:
  # * first table doesn't interest us
  # * first TextResultArabic class is tafseer name and author
  # * AyahText id contains ayah which the tafseer talks about
  # * from the first to the 3rd-to-last occurance of TextResultArabic
  #   (all contained within <div align='right' dir='rtl'>!!), that's
  #   the actual tafseer text!
  # * second table (inside only <center>!) is list of page numbers
  return("Lorem ipsum dolor sit amet consectetur.")
}

download_all_tafaseer(default_url)

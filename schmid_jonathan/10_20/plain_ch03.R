#!/usr/bin/env Rscript

build_corpus <- function(url)
{
  text <- scan(url, what='character', sep='\n')
  head(text, n=10)
  return(text)
}

sorted_freqs <- function(text)
{
  start <- which(text == 'CHAPTER 1. Loomings.')
  end   <- which(text == 'orphan.')
  text  <- text[start:end]
  text  <- paste(text, collapse=' ')
  text  <- tolower(text)
  words <- strsplit(text, '\\W')
  words <- unlist(words)
  freqs <- table(words)
  freqs <- sort(freqs, decreasing=TRUE)
  
  return(freqs)
}

url = 'http://www.gutenberg.org/files/2701/2701-0.txt'
build_corpus

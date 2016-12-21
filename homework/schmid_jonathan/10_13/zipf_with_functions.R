#!/usr/bin/env Rscript
# Requires:
# install.packages(c('tm', 'gplot2', 'SnowballC'))

library(tm)
library(ggplot2)

build_single_text_corpus <- function(url)
{
  corpus <- Corpus(URISource(url))
  corpus[[1]]$content <- corpus[[1]]$content[16:1066]

  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, stemDocument)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, PlainTextDocument)
  
  return(corpus)
}

create_word_frequency_table <- function(dtm)
{
  wf <- sort(colSums(as.matrix(dtm)))
  wf <- data.frame(word=names(wf), frequency=wf)
  
  return(wf)
}

create_word_frequency_plot <- function(wf)
{
  p <- ggplot(subset(wf, frequency>50), aes(reorder(word, -frequency), frequency))
  p <- p + geom_bar(stat='identity')                           + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1))   +
    labs(title = paste('Word Frequencies for The Art of War')) +
    xlab('word')
  ggsave('zipf_with_functions.pdf', width=30, height=20, units='cm', device=cairo_pdf)
}

corpus = build_single_text_corpus('http://classics.mit.edu/Tzu/artwar.1b.txt')
dtm <- removeSparseTerms(DocumentTermMatrix(corpus), 0.1)
## tdm <- TermDocumentMatrix(corpus)
wf_table <- create_word_frequency_table(dtm)
create_word_frequency_plot(wf_table)

#!/usr/bin/env Rscript

# Requires install.packages('tm')!
library(tm) # Another R strangeness… require() does exist but doesn't bail upon failure. This does.
            # Also note the lack of quotes around the library name – so there /are/ symbols in R!
library(ggplot2) # Pretty pictures
library(Cairo)   # Pretty pictures with Unicode text in them (problematic in Windows anyways…)

source('cleanup.R')

# Package documentation at:
# ftp://cran.r-project.org/pub/R/web/packages/tm/vignettes/tm.pdf

text.tm <- VCorpus(VectorSource(text.single_cleaned_string.v))
# text.tm <- tm_map(text.tm, PlainTextDocument) # Not sure if this is needed…
text.tm.dt_matrix <- DocumentTermMatrix(text.tm)
# text.tm.td_matrix <- TermDocumentMatrix(text.tm)
# sort() is sort of useless as ggplot() sorts the x-axis!
text.tm.frequency <- sort(colSums(as.matrix(text.tm.dt_matrix)))

# Apparently there's a million ways…
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# text.tm.order <- order(text.tm.frequency)
# ten_most_frequent <- text.tm.frequency[tail(text.tm.order, n=10L)]
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# words_by_frequency <- sort(colSums(as.matrix(text.tm.dt_matrix)), decreasing=TRUE)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# at_least_two_occurances <- findFreqTerms(text.tm.dt_matrix, lowfreq=2)

# What's going on in there?
# ("The function data.frame() creates data frames, tightly 
#   coupled collections of variables which share many of the 
#   properties of matrices and of lists, used as the fundamental 
#   data structure by most of R's modeling software.")
wf <- data.frame(word = names(text.tm.frequency), frequency = text.tm.frequency)

pp <- ggplot(subset(wf, frequency > 2), aes(reorder(word, -frequency), frequency))
pp <- pp + geom_bar(stat = 'identity')                              + 
           theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
           labs(title = paste('Word Frequencies for', file))        +
           xlab('word')

# pp # When in interactive mode…
# When running through shellggsave('~/Desktop/Text Analysis/Homework/jonathan|rapha/jockers/ch02/frequency.pdf', width=30, height=20, units='cm', device=cairo_pdf)
ggsave('~/Desktop/Text Analysis/Homework/jonathan|rapha/jockers/ch02/frequency.pdf', 
       width=30, height=20, units='cm', device=cairo_pdf) # Roughly A4 sized
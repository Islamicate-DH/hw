#!/usr/bin/env Rscript

# TODO: Think about first implementing https://cran.r-project.org/web/packages/ldatuning/vignettes/topics.html
params = list(
  burnin  = 4000,
  iter    = 2000,
  thin    =  500,
  seed    = list(2003, 5, 63, 100001, 765),
  nstart  =    5,
  best    = TRUE,
  k       =   18, # Number of works
  # k     =    2, # For testing purposes only
  verbose = 2000  # Show progress every x iterations
)

build_dtm <- function(file)
{
  message('Reading in files...')
  file = lapply(file, readLines)
  message('Building corpus...')
  corpus = Corpus(VectorSource(file))
  message('Building DT matrix...')
  DocumentTermMatrix(corpus)
}

crunch_lda <- function(dtm, params)
{
  message('Crunching LDA function...')
  LDA(
    dtm,
    params$k,
    # Who is he and why do we like him?
    # Answer Leeroy Jethro is of course our hero. In this case,
    # because he allows running some LDA steps on multiple processors
    # and also because he has lower memory requirements than previous
    # methods. MEMORY USAGE STILL RISES WITH CORPUS SIZE, THOUGH!!!
    # (Cf. https://cran.r-project.org/web/packages/topicmodels/vignettes/topicmodels.pdf)
    method='Gibbs', 
    control=params
  )
}

write_topics <- function(src, lda, k)
{
  message('Building topics from LDA results...')
  topics = as.matrix(topics(lda))
  write.csv(
    topics, 
    file=sprintf('data_IO/%s_LDAGibbs-%i-Docs2Topics.csv',src,k)
  )
}

write_topTerms <- function(src, lda, n, k)
{
  message(sprintf('Calculating top %i topics from LDA results...',k))
  terms = as.matrix(terms(lda, n))
  write.csv(
    terms,
    file=sprintf('data_IO/%s_LDAGibbs-%i-Topics2Terms.csv',src,k)
  )
}

write_probabilities <- function(src, lda, k)
{
  message('Calculating topic probabilities from LDA results...')
  probabs = as.data.frame(lda@gamma)
  write.csv(
    probabs,
    file=sprintf('data_IO/%s_LDAGibbs-%i-TopicProbabilities.csv',src,k)
  )
}

write_relativeImportances <- function(src, dtm, probabs, k)
{
  message('Finding relative importances between topics 1/2, 2/3...')
  one2two = lapply(1:nrow(dtm), function(x) {
    sort(probabs[x,])[k-0] / sort(probabs[x,])[k-1]
  })
  two2three = lapply(1:nrow(dtm), function(x) {
    sort(probabs[x,])[k-1] / sort(probabs[x,])[k-2]
  })
  write.csv(
    one2two,
    file=sprintf('data_IO/%s_LDAGibbs-%i-TopicOneImportance2Two.csv',src,k)
  )
  write.csv(
    two2three,
    file=sprintf('data_IO/%s_LDAGibbs-%i-TopicTwoImportance2Three.csv',src,k)
  )  
}

run_tm <- function(file)
{ 
  t0 = proc.time()
  message(sprintf('Execution for %s starts at %.3fms', file, t0[1]))
  dtm = build_dtm(file)
  lda_results = crunch_lda(dtm, params)
  # What's with all the parentheses, R?!
  basename = strsplit(basename(file), '\\.')[[1]][1]
  write_topics(basename, lda_results, params$k)
  write_topTerms(basename, lda_results, 6, params$k)
  probabs = write_probabilities(basename, lda_results, params$k)
  write_relativeImportances(basename, dtm, probabs, params$k)
  message(
    sprintf('Success after %.2f mins',
    (proc.time() - t0)[3] / 60)
  )
}

for (lib in c('tm', 'topicmodels')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  message('Usage: ./topicmodel.R [list of files to process]')
} else {
  lapply(args, run_tm)
}

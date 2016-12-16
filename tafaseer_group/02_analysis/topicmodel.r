#!/usr/bin/env Rscript

# R packages
for (lib in c('tm', 'topicmodels', 'lda', 'LDAvis', 'mgcv')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

# Home-made library functions
source(file.path('..', 'lib', 'clean_arabic_string.r'))

save_as_rds <- function(savedir, datafiles)
{
  path = sprintf("%s/data.rds", savedir)
  if (file.exists(path)) {
		message('loading data from rds...')
    load(path) # this (re)creates the data object
  } else {
    message('saving data as rds...')
    txt <- lapply(datafiles, readLines)
    names = gsub(savedir, '', datafiles)
    data = setNames(txt, names)
    data = sapply(data, function(x) paste(x, collapse = ' '))
    save(data, file=path, compress='xz')
  }
  return(data)
}

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

fit_model <- function(savedir, data, stopwords)
{
  path = sprintf("%s/fit.rds", savedir)
  if (file.exists(path)) {
    message('loading fit from rds...')
    fit <- readRDS(path)
  } else {
    # should already be done, so not doing it again (compute-intensive)
    # tafaseer = clean_arabic_string(tafaseer)
    message('tokenizing...')
      doc.list = strsplit(data, '[[:space:]]+')
      message('computing table of terms...')
      term.table = table(unlist(doc.list))
      term.table = sort(term.table, decreasing=TRUE)
    message('removing superfluous terms...')
      del = names(term.table) %in% stopwords | term.table < 5
      term.table = term.table[!del]
      vocab = names(term.table)
    message('converting to lda input format...')
      get.terms = function(x) {
        index = match(x, vocab)
        index = index[!is.na(index)]
        rbind(as.integer(index - 1), as.integer(rep(1, length(index))))}
      documents = lapply(doc.list, get.terms)
    message('some statistics related to the data set:')
		num_tokens = sapply(documents, function(x) sum(x[2, ]))
		term_freqs = as.integer(term.table)
		message(sprintf('no. of docs: %i\nno. of terms: %i\nno. of tokens: %s\ntotal no. of tokens: %i\ntop 10 term frequencies: %s',
			length(documents),
      length(vocab),
      paste(num_tokens, collapse=', '),
      sum(num_tokens),
      paste(term_freqs[(1:10)], collapse=', ')))
    message('fitting the model (go grab a nap)...')
      # TODO: Think about first implementing
      # https://cran.r-project.org/web/packages/ldatuning/vignettes/topics.html
      # TODO: find out where they take the seed value(s) from??
      # set.seed(list(2003, 5, 63, 100001, 765))
      set.seed(357)
      alpha = 0.02
      eta   = 0.02
      fit <- lda.collapsed.gibbs.sampler(
        documents      = documents,
        vocab          = vocab,
        K              = 20,
        num.iterations = 5000,
        initial        = NULL,
        burnin         = 0,
        # TODO: look into what these would really change...
        # K              = 120,
        # num.iterations = 2000,
        # TODO: find out how to specify these with sampler()
        # burnin         = 4000,
        # thin=500,
        # nstart=5,
        # verbose=2000, # milliseconds
        # best = TRUE,
        alpha = alpha,
        eta = eta,
        compute.log.likelihood=TRUE)
      # needed for building the json later on
      fit$num_tokens = num_tokens
      fit$term_freqs = term_freqs
      fit$alpha = alpha
      fit$eta = eta
      fit$vocab_list = vocab
    saveRDS(fit, path)
  }
  return(fit)
}

build_v11n <- function(savedir, fit)
{
  message('building json...')
	json = createJSON(
		phi            = t(apply(t(fit$topics) + fit$eta, 2, function(x) x/sum(x))),
    theta          = t(apply(fit$document_sums + fit$alpha, 2, function(x) x/sum(x))),
    doc.length     = fit$num_tokens,
    vocab          = fit$vocab_list,
    term.frequency = fit$term_freqs)
  message('writing visualization data...')
	serVis(json, out.dir=sprintf('%s/html', savedir), open.browser=FALSE)
}

run_tm <- function(savedir, stopwordfile, datafiles)
{
  t0 = proc.time()
  message('execution starts at 0.00 mins')

  # basically going by http://cpsievert.github.io/ldavis/reviews/reviews.html
  data = save_as_rds(savedir, datafiles)
  stopwords <- read.csv(file=stopwordfile, head=FALSE)
  fit = fit_model(savedir, data, stopwords)
  build_v11n(savedir, fit)

  message(sprintf('success after %.2f mins', (proc.time() - t0)[3] / 60))
}

# Read command-line arguments
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  message('Usage: ./topicmodel.R <save data dir> <stopword file> <list of text files>')
} else {
  run_tm(args[1], args[2], args[-c(1, 2)])
}

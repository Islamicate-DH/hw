#!/usr/bin/env Rscript

# R packages
for (lib in c('tm', 'topicmodels', 'lda', 'LDAvis')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

# Home-made library functions
source(file.path('..', 'lib', 'clean_arabic_string.r'))

# TODO: Think about first implementing
# https://cran.r-project.org/web/packages/ldatuning/vignettes/topics.html
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
    file=sprintf('data/%s_LDAGibbs-%i-Docs2Topics.csv',src,k)
  )
}

write_topTerms <- function(src, lda, n, k)
{
  message(sprintf('Calculating top %i topics from LDA results...',k))
  terms = as.matrix(terms(lda, n))
  write.csv(
    terms,
    file=sprintf('data/%s_LDAGibbs-%i-Topics2Terms.csv',src,k)
  )
}

write_probabilities <- function(src, lda, k)
{
  message('Calculating topic probabilities from LDA results...')
  probabs = as.data.frame(lda@gamma)
  write.csv(
    probabs,
    file=sprintf('data/%s_LDAGibbs-%i-TopicProbabilities.csv',src,k)
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
    file=sprintf('data/%s_LDAGibbs-%i-TopicOneImportance2Two.csv',src,k)
  )
  write.csv(
    two2three,
    file=sprintf('data/%s_LDAGibbs-%i-TopicTwoImportance2Three.csv',src,k)
  )
}

# Ran this once, not used anymore now
convert_txt_to_rds <- function(files)
{
  txt <- lapply(files, readLines)
  names <- gsub('../../corpora/altafsir_com/selection', '', files)
  tafaseer = setNames(txt, names)
  tafaseer = sapply(tafaseer, function(x) paste(x, collapse = ' '))
  save(tafaseer, file='../../corpora/altafsir_com/selection/tafaseer.rds', compress='xz')
}

# The old thing, not used anymore now
run_lda <- function(file)
{
  t0 = proc.time()
  message(sprintf('Execution starts at %.3fms', t0[1]))
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

t <- function(t0)
{
  (proc.time() - t0)[3] / 60
}

run_lda_and_ldavis <- function(datafile, stopwordfile)
{
  t0 = proc.time()
  message(sprintf('execution starts at %.3fms', t0[1]))
  load(datafile, verbose=TRUE) # this creates the tafaseer object
  message('loading stopwords...')
    stopwords <- read.csv(file=stopwordfile, head=FALSE)
  message(sprintf('%.2f: cleaning the corpus...', t(t0)))
    tafaseer = clean_arabic_string(tafaseer)
  # going by http://cpsievert.github.io/ldavis/reviews/reviews.html from here
  message(sprintf('%.2f: tokenizing...', t(t0)))
    doc.list = strsplit(tafaseer, '[[:space:]]+')
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
  message(sprintf('%.2f: calculating statistics...', t(t0)))
    D = length(documents) # number of documents
    W = length(vocab)     # number of terms in the vocabulary
    doc.length = sapply(documents, function(x) sum(x[2, ])) # number of tokens per document
    N = sum(doc.length)   # total number of tokens in the data
    term.frequency = as.integer(term.table) # frequencies of terms in the corpus
  message(sprintf('D=%s\nW=%s\nN=%s\ndoc.length=%s\nterm.frequency=%s',
    D, W, N,
    doc.length,
    term.frequency))
  message(sprintf('%.2f: fitting the model...', t(t0)))
    K = 20
    G = 5000
    alpha = 0.02
    eta = 0.02
    set.seed(357) # where do they take this from??
    fit <- lda.collapsed.gibbs.sampler(
      documents=documents,
      K=K,
      vocab=vocab,
      num.iterations=G,
      alpha=alpha,
      eta=eta,
      initial=NULL,
      burnin=0,
      compute.log.likelihood=TRUE)
  message(sprintf('%.2f: visualizing...', t(t0)))
    theta = t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
    phi   = t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))
		tafaseer_data = list(
			phi=phi,
      theta=theta,
      doc.length=doc.length,
      vocab=vocab,
      term.frequency=term.frequency)
		json = createJSON(
			phi=tafaseer_data$phi,
      theta=tafaseer_data$theta,
      doc.length=tafaseer_data$doc.length,
      vocab=tafaseer_data$vocab,
      term.frequency=tafaseer_data$term.frequency)
  message(sprintf('%.2f: writing visualization data...', t(t0)))
		serVis(json, out.dir='data_automated/ldavis', open.browser=FALSE)
}

# Read command-line arguments
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  # We just want this now
  run_lda_and_ldavis(
    '../../corpora/altafsir_com/selection/tafaseer.rds', 'data_automated/stopwords.csv')
# The old thing, not used anymore now
# message('Usage: ./topicmodel.R [list of files to process]')
} else {
  lapply(run_lda, args)
}

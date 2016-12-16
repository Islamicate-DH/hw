# Copyright  Matthew Miller and Thomas Koentges
# Adapted by Tobias Wenzel
# In Course: Islamicate World 2.0
# University of Maryland, University Leipzig
#
# File description:
#     This script is used to apply topic modelling to the corpora 
#     downloaded and cleaned in scrapeR and cleanR and save the results
#     in csv format as well as a graphical interpretation by LDAvis.
rm(list=ls())
## libraries needed
libs<-c("tm","XML","RCurl","plyr","curl","lda","LDAvis","compiler")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}

enableJIT(3)  # Enable JIT-compiling
## User settings:
K <- 15
G <- 5000  # num.iterations 
alpha <- 0.02
eta <- 0.02
seed <- 37
terms_shown <- 40


source.folder <- "~/Dropbox/Dokumente/islamicate2.0/reduced/"

corpus.file <- paste(source.folder, "almasralyoum_clean.csv",sep = "")
base_corpus.almarsi <- read.table(
    corpus.file, sep = ",", header = FALSE,
    encoding = "UTF-8", stringsAsFactors = F
  )


base_corpus <- NULL
base_corpus <- rbind(base_corpus, base_corpus.ahram, base_corpus.alwatan
                     ,base_corpus.hespress, base_corpus.thawra ,base_corpus.almari)



research_corpus <- as.character(base_corpus$V2)
output_names <- as.character(base_corpus$V1)  # used to identify articles

# Removing remaining control characters, whitespaces and numbers.  
research_corpus <- gsub("[[:punct:]]", " ", research_corpus)  # replace punctuation with space
research_corpus <- gsub("[[:cntrl:]]", " ", research_corpus)  # replace control characters with space
research_corpus <- gsub("^[[:space:]]+", "", research_corpus) # remove whitespace at beginning of documents
research_corpus <- gsub("[[:space:]]+$", "", research_corpus) # remove whitespace at end of documents
research_corpus <- gsub("[0-9]", "", research_corpus) #remove numbers

# tokenize on space and output as a list:
doc.list <- strsplit(research_corpus, "[[:space:]]+")

# Stemming is left out. See paper.

all_words <- unlist(doc.list)
all_words<-all_words[all_words!=""]
corpus_words <- unique(all_words)
corpus_words <- sort(corpus_words)

# compute the table of terms:
term.table <- table(all_words)
term.table <- sort(term.table, decreasing = TRUE)

# remove terms that are stop words or occur fewer than "occurenses" times:
stop_words<-scan(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/stopwords_ar.txt",what = "", sep="\n",encoding = "UTF-8")
occurences <- 10
del <- names(term.table) %in% stop_words | term.table < occurences 
term.table <- term.table[!del]
vocab <- names(term.table)

# now put the documents into the format required by the lda package:
get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}
documents <- lapply(doc.list, get.terms)
#save(documents, file = "/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/documents.RData")

# Compute some statistics related to the data set:
D <- length(documents)  # number of documents (2,000)
W <- length(vocab)  # number of terms in the vocab (14,568)
doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
N <- sum(doc.length)  # total number of tokens in the data (546,827)
term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus [8939, 5544, 2411, 2410, 2143, ...]

# Fit the model:
set.seed(seed)
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)

# Visualize
theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))


research_corpusAbstracts <- list(phi = phi,
                                 theta = theta,
                                 doc.length = doc.length,
                                 vocab = vocab,
                                 term.frequency = term.frequency)

# create the JSON object to feed the visualization:
json <- createJSON(phi = research_corpusAbstracts$phi, 
                   theta = research_corpusAbstracts$theta, 
                   doc.length = research_corpusAbstracts$doc.length, 
                   vocab = research_corpusAbstracts$vocab, 
                   term.frequency = research_corpusAbstracts$term.frequency,
                   R=terms_shown)

#Visulise and start browser
vis.folder <- paste(source.folder, "visTotal", sep = "")
serVis(json, out.dir = vis.folder, open.browser = FALSE)

## get topic-term distributions and export as csv
phi.t <- t(phi)
phi.t.df <- data.frame(matrix(nrow = length(phi.t[, 1]), ncol = K + 1))
phi.t.df[, 1] <- names(phi.t[, 1])
for (i in 1:K) {
  phi.t.df[, i + 1] <- phi.t[, i]
}
phicolnames <- vector(mode = "character", length = K + 1)
phicolnames[1] <- "term"
for (i in 1:K) {
  phicolnames[i + 1] <- paste(head(phi.t.df[order(phi.t.df[, i + 1], decreasing = TRUE), ], n =
                 7)[, 1], sep = "", collapse = "_")
}
colnames(phi.t.df) <- phicolnames
phi.filename <- paste(source.folder, "visTotal/phi.csv", sep = "")
write.table(
  phi.t.df, file = phi.filename,
  append = FALSE, quote = FALSE,
  sep = ",", eol = "\n", na = "NA",
  dec = ".", row.names = FALSE, col.names = TRUE
)

## get document-topic distributions and export as csv
theta.frame <-
  data.frame(matrix(nrow = length(theta[, 1]), ncol = K + 1))
theta.frame[, 1] <- output_names
for (i in 1:K) {
  theta.frame[, i + 1] <- theta[, i]
}
thetacolnames <- phicolnames
thetacolnames[1] <- "identifier"
colnames(theta.frame) <- thetacolnames

theta.filename <- paste(source.folder, "visTotal/theta.csv", sep = "")
write.table(
  theta.frame, file = theta.filename,
  append = FALSE, quote = FALSE,
  sep = ",", eol = "\n", na = "NA",
  dec = ".", row.names = FALSE,
  col.names = TRUE
)
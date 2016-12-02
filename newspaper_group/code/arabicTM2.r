## setwd, modify according to your needs


rm(list=ls())
## libraries needed

library(tm)
library(XML)
library(RCurl)
library(plyr)
library(lda)
library(LDAvis)
library(compiler)

## optional

# library(RColorBrewer)
# library(devtools) 
# # install_github("ramnathv/rCharts")
# library(rCharts)
# library(d3heatmap)

# if (!require("devtools")) install.packages("devtools")
# devtools::install_github("rstudio/d3heatmap",dependencies=TRUE)

## User settings:
K <- 15
G <- 5000#num.iterations 
alpha <- 0.02
eta <- 0.02
seed <- 37
terms_shown <- 40

 language <- "Arabic" # (Persian, Arabic, Latin)


## read in some stopwords:

stop_words<-scan(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/stopwords_ar.txt",what = "", sep="\n",encoding = "UTF-8")

# Enable JIT-compiling

enableJIT(3)



 base_corpus <- read.table("/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/hespress_c.csv", sep=",", header=FALSE,encoding = "UTF-8",stringsAsFactors = F)

research_corpus <- as.character(base_corpus$V2)
 output_names <- as.character(base_corpus$V1)

 
research_corpus <- gsub("[[:punct:]]", " ", research_corpus)  # replace punctuation with space
research_corpus <- gsub("[[:cntrl:]]", " ", research_corpus)  # replace control characters with space
research_corpus <- gsub("^[[:space:]]+", "", research_corpus) # remove whitespace at beginning of documents
research_corpus <- gsub("[[:space:]]+$", "", research_corpus) # remove whitespace at end of documents
research_corpus <- gsub("[0-9]", "", research_corpus) #remove numbers

#research_corpus<-sapply(research_corpus, gsub, "[[:ascii]]","", perl=T)


# research_corpus<-sapply(research_corpus,gsub,"[[:punct:]]", " ")  # replace punctuation with space
# research_corpus<-sapply(research_corpus,"[[:cntrl:]]", " ", research_corpus)  # replace control characters with space
# research_corpus<-sapply(research_corpus,"^[[:space:]]+", "", research_corpus) # remove whitespace at beginning of documents
# research_corpus<-sapply(research_corpus,"[[:space:]]+$", "", research_corpus) # remove whitespace at end of documents
# research_corpus<-sapply(research_corpus, gsub, "[0-9]"," ")




# tokenize on space and output as a list:
doc.list <- strsplit(research_corpus, "[[:space:]]+")

# produce dictionary for stemming:




all_words <- unlist(doc.list)
#out<-stem(all_words, transliteration = TRUE, returnStemList = TRUE)
#str(out)

all_words<-all_words[all_words!=""]
corpus_words <- unique(all_words)
corpus_words <- sort(corpus_words)


## stemming

## not done here.

# compute the table of terms:
term.table <- table(all_words)
term.table <- sort(term.table, decreasing = TRUE)


# remove terms that are stop words or occur fewer than "occurenses" times:
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

# Compute some statistics related to the data set:
D <- length(documents)  # number of documents (2,000)
W <- length(vocab)  # number of terms in the vocab (14,568)
doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
N <- sum(doc.length)  # total number of tokens in the data (546,827)
term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus [8939, 5544, 2411, 2410, 2143, ...]

# Fit the model:
set.seed(seed)
t1 <- Sys.time()

#str(term.frequency)
#G<-10
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
modelling_time <- t2 - t1

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
serVis(json, out.dir = '/home/tobias/Dropbox/Dokumente/islamicate2.0/vis/hespress', open.browser = FALSE)

## get the tables

#dir.create("thawra")

# names(head(sort(phi.frame[,1], decreasing = TRUE)))

## get topic-term distributions and export as csv
phi.t <- t(phi)
phi.t.df <- data.frame(matrix(nrow=length(phi.t[, 1]), ncol = K+1))
phi.t.df[, 1] <- names(phi.t[,1])
for (i in 1:K){
  phi.t.df[, i+1] <- phi.t[, i]
}
phicolnames <- vector(mode="character", length=K+1)
phicolnames[1] <- "term"
for (i in 1:K){
  phicolnames[i+1] <- paste(head(phi.t.df[order(phi.t.df[,i+1],decreasing=TRUE),], n=7)[,1], sep="", collapse="_")
}
colnames(phi.t.df) <- phicolnames
write.table(phi.t.df, file = '/home/tobias/Dropbox/Dokumente/islamicate2.0/vis/hespress/phi.csv', append = FALSE, quote = FALSE, sep = ",", eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)

## get document-topic distributions and export as csv
theta.frame <- data.frame(matrix(nrow=length(theta[,1]), ncol = K+1))
theta.frame[, 1] <- output_names
for (i in 1:K){
  theta.frame[, i+1] <- theta[, i]
}
thetacolnames <- phicolnames
thetacolnames[1] <- "identifier"
colnames(theta.frame) <- thetacolnames
write.table(theta.frame, file = '/home/tobias/Dropbox/Dokumente/islamicate2.0/vis/hespress/theta.csv', append = FALSE, quote = FALSE, sep = ",", eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)





### Functions:

### building test matrix to compare a sentence with all other sentences in the corpus
# 
# build_test <- function(x){
#   test_cases <- output_names [! output_names %in% x]
#   first_column <- rep(x, length(test_cases))
#   test_matrix <- matrix(nrow=length(test_cases), ncol = 2)
#   test_matrix[,1] <- first_column
#   test_matrix[,2] <- test_cases
#   return(test_matrix)
# }
# 
# passage.topic.value <- function(x) {
#   max_score <- max(theta.frame[which(theta.frame[,1] == x),2:13])
#   topic <- which(theta.frame[which(theta.frame[,1] == x),2:13] == max_score)
#   result <- topic + max_score
#   result <- result[1]
#   return(result)
# }

# just.topic.value <- function(x) {
#   max_score <- max(theta.frame[which(theta.frame[,1] == x),2:13])
#   result <- max_score[1]
#   return(result)
# }
# 
# find_passages <- function(x) {
#   positions <- which(grepl(x,theta.frame[,1], fixed=TRUE) == TRUE)
#   return(theta.frame[,1][positions])
# }

# XMLpassage2 <-function(xdata){
#   result <- xmlParse(xdata)
#   temp.df <- as.data.frame(t(xpathSApply(result, "//*/hdwd", XMLminer)), stringsAsFactors = FALSE)
#   as.vector(temp.df[['text']])}
# 
# parsing <- function(x){
#   word_form <- x
#   URL <- paste(morpheusURL, word_form, "&lang=per&engine=hazm", sep = "")
#   message(round((match(word_form, corpus_words)-1)/length(corpus_words)*100, digits=2), "% processed. Checking ", x," now.")
#   
#   URLcontent <- tryCatch({
#     getURLContent(URL, httpheader = c(Accept="application/xml"))}, 
#     error = function(err)
#     {tryCatch({
#       Sys.sleep(0.1)
#       message("Try once more")
#       getURLContent(URL)},
#       error = function(err)
#       {message("Return original value: ", word_form)
#        return(word_form)
#       })
#     })
#   if (URLcontent == "ServerError") {
#     lemma <- x
#     message(x, " is ", lemma)
#     return(lemma)}
#   else {
#     lemma <- if (is.null(XMLpassage2(URLcontent)) == TRUE) {
#       lemma <- x
#       message(x, " is ", lemma)
#       return(lemma)}
#     else {lemma <- tryCatch({XMLpassage2(URLcontent)},
#                             error = function(err) {
#                               message(x, " not found. Return original value.")
#                               lemma <- "NotFound1"
#                               message(x, " is ", lemma)
#                               return(lemma)})
#           
#           lemma <- gsub("[0-9]", "", lemma)
#           lemma <- tolower(lemma)
#           lemma <- unique(lemma)
#           if (nchar(lemma) == 0) {
#             lemma <- x
#             message(x, " is ", lemma)
#             return(lemma)}
#           else {
#             message(x, " is ", lemma)
#             return(lemma)
#           }
#     }
#   }
# }
# 
# 
# 
# ### more experiments // very experimental and not made for speedy processing
# 
# test_matrix <- matrix(nrow=length(corpus[,1]), ncol = length(corpus[,1]))
# rownames(test_matrix) <- corpus[,1]
# colnames(test_matrix) <- corpus[,1]
# 
# is_similar2 <- function(x,y) {
#   check <- all.equal(theta.frame[which(theta.frame[,1] == x),], theta.frame[which(theta.frame[,1] == y),]) # comparing with all.equal
#   check2 <- all.equal(theta.frame[which(theta.frame[,1] == y),], theta.frame[which(theta.frame[,1] == x),]) # comparing with all.equal
#   if (length(check) == 1) {if (check == TRUE) {
#     result <- 0
#     return(result)
#   }}
#   result1 <- mean(as.numeric(sub(".*?difference: (.*?)", "\\1", check)[3:length(check)]))
#   result2 <- mean(as.numeric(sub(".*?difference: (.*?)", "\\1", check2)[3:length(check2)]))
#   result <- (result1 + result2) / 2
#   return(result)}
# 
# ### topic-corpus visualisation
# 
# passage.topic.value <- function(x) {
#   max_score <- max(theta.frame[which(theta.frame[,1] == x),2:16])
#   topic <- which(theta.frame[which(theta.frame[,1] == x),2:16] == max_score)
#   result <- topic + max_score
#   result <- result[1]
#   return(result)
# }
# 
# just.topic.value <- function(x) {
#   max_score <- max(theta.frame[which(theta.frame[,1] == x),2:16])
#   result <- max_score[1]
#   return(result)
# }
# 
# find_passages <- function(x) {
#   positions <- which(grepl(x,theta.frame[,1], fixed=TRUE) == TRUE)
#   return(theta.frame[,1][positions])
# }
# 
# sanaee <- find_passages("urn:cts:perslit:sanaee")
# anvari <- find_passages("urn:cts:perslit:anvari")
# attar <- find_passages("urn:cts:perslit:attar")
# AllPers <- c(sanaee, anvari, attar)
# 
# colourise2 <- function(x) {
#   if (x > 1 & x < 2) {return("Topic 1")}
#   if (x > 2 & x < 3) {return("Topic 2")}
#   if (x > 3 & x < 4) {return("Topic 3")}
#   if (x > 4 & x < 5) {return("Topic 4")}
#   if (x > 5 & x < 6) {return("Topic 5")}
#   if (x > 6 & x < 7) {return("Topic 6")}
#   if (x > 7 & x < 8) {return("Topic 7")}
#   if (x > 8 & x < 9) {return("Topic 8")}
#   if (x > 9 & x < 10) {return("Topic 9")}
#   if (x > 10 & x < 11) {return("Topic 10")}
#   if (x > 11 & x < 12) {return("Topic 11")}
#   if (x > 12 & x < 13) {return("Topic 12")}
#   if (x > 13 & x < 14) {return("Topic 13")}
#   if (x > 14 & x < 15) {return("Topic 14")}
#   if (x > 15 & x < 16) {return("Topic 15")}
# }
# 
# topics_AllPers.df <- data.frame(matrix(NA, nrow=length(AllPers), ncol=4))
# topics_AllPers.df[,1] <- AllPers
# topics_AllPers.df[,2] <- sapply(AllPers, passage.topic.value)
# topics_AllPers.df[,3] <- sapply(topics_AllPers.df[,2], colourise2)
# topics_AllPers.df[,4] <- sapply(AllPers, just.topic.value)
# colnames(topics_AllPers.df) <- c("Passage", "TopicValue2", "Topic", "TopicValue")
# 
# chart1_1 <- rPlot(
#   x = "Passage",
#   y = "TopicValue",
#   data = topics_AllPers.df,
#   type = "bar",
#   color = "Topic")
# 
# chart_sanaee <- rPlot(TopicValue ~ Passage | Topic,
#                   data = topics_AllPers.df,
#                   color = "Topic",
#                   type = 'bar',
#                   size = list(const = 3),
#                   width = 600,
#                   height = 1800)
# 
# chart_sanaee$save('TopicsAllPers.html', standalone = TRUE)
# 
# topics_AllPers.df.sorted <- topics_AllPers.df[with(topics_AllPers.df, order(-TopicValue2)), ]
# 
# chart_topics_sorted <- rPlot(TopicValue ~ Passage | Topic,
#                       data = topics_AllPers.df.sorted,
#                       color = "Topic",
#                       type = 'bar',
#                       size = list(const = 3),
#                       width = 600,
#                       height = 1800)
# 
# chart_topics_sorted$save('TopicsAllPersSorted.html', standalone = TRUE)
# 

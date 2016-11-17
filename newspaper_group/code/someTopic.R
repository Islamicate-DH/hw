# 
# library(shiny)
#   runApp('/home/tobias/Downloads/ToPan-master/')
#   

library(mallet)
library(wordcloud)
require(RColorBrewer)


corpus<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/Thawra/thawra2012_13_14.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)

corpus$ids <- 1: dim(corpus)[1]


corpus$V4 <- gsub("[[:punct:]]", " ", corpus$V4)  # replace punctuation with space
corpus$V4 <- gsub("[[:cntrl:]]", " ", corpus$V4)  # replace control characters with space
corpus$V4 <- gsub("^[[:space:]]+", "", corpus$V4) # remove whitespace at beginning of documents
corpus$V4 <- gsub("[[:space:]]+$", "", corpus$V4) # remove whitespace at end of documents
corpus$V4 <- gsub("[0-9]", "", corpus$V4) #remove numbers
corpus$V4<- gsub("[:alpha:]","", corpus$V4)


newCorpus<-data.frame(corpus$ids,corpus$V4,stringsAsFactors = F)

colnames(newCorpus)<-c("ids","text")


#as.characters !

mallet.instances <- mallet.import(as.character(newCorpus$ids), 
                                  as.character(newCorpus$text),
                                  "/home/tobias/Downloads/stopwords_ar.txt",
                                  TRUE,
                                  token.regexp="[\\p{L}']+")

topic.model <- MalletLDA(num.topics=18)
topic.model$loadDocuments(mallet.instances)
vocabulary <- topic.model$getVocabulary()

topic.model$setAlphaOptimization(40, 80)
topic.model$train(400)
word.freqs <- mallet.word.freqs(topic.model)
topic.words.m <- mallet.topic.words(topic.model,
                                    smoothed=TRUE,
                                    normalized=TRUE)
colnames(topic.words.m) <- vocabulary

topic.top.words <- mallet.top.words(topic.model,
                                    topic.words.m, 1000)

png("thawra12_13_14.png", width=1280,height=800)
pal2 <- brewer.pal(8,"Dark2")
wordcloud(topic.top.words$words,
          topic.top.words$weights,scale=c(8,.2),
          c(4,.8), rot.per=.15, random.order=F,colors=pal2)
dev.off()

topic.top.words[1]

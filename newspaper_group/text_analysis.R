##sudo apt-get install r-cran-slam
#install.packages('tm')
Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")   
library(tm)
library(ggplot2)   
library(arabicStemR)

library(wordcloud)   
cname<-"/home/tobias/Dokumente/islamicate2.0/hw/corpora/newspaper_archive/Hespress/testing"

##TermDocumentMatrix(my.data[4], control = list(wordLengths = c(3,10))) 

# data <- read.csv("/home/tobias/Dokumente/islamicate2.0/hw/corpora/newspaper_archive/Hespress/testing/hespress2010.csv"
# ,encoding = "UTF-8",sep = ",")
#    

#data.corp <- Corpus(DataframeSource(data.frame(head(data[,4]))))
### ich will eignetlich nur den text untersuchen.
### hier les ich halt alles. punkte, nummers und whitespace werden aber trotzdem 
## entfernt, sodass das keinen unterschied machen sollte


docs <- Corpus(DirSource(cname))   
#docs<-data.corp

funcs <- list(tolower, removePunctuation, removeNumbers, stripWhitespace)
docs <- tm_map(docs, FUN = tm_reduce, tmFuns = funcs)

docs <- tm_map(docs, PlainTextDocument)   

dtm <- DocumentTermMatrix(docs)   

freq <- colSums(as.matrix(dtm))   
ord <- order(freq)   
dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   

#freq[tail(ord)]   ## most frequ words



#wf <- data.frame(word=names(freq), freq=freq)   
# head(wf)
# wf
# p <- ggplot(subset(wf, freq>50), aes(word, freq))    
# p <- p + geom_bar(stat="identity")   
# p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
# p
##tdm <- TermDocumentMatrix(docs)   

set.seed(124)   
# freq<-stem(freq)
# freq<-cleanChars(freq)
wordcloud(names(freq), freq, max.words=100)   

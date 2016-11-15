##sudo apt-get install r-cran-slam
#install.packages('tm')
Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")   
library(tm)
library(ggplot2)   
library(arabicStemR)

library(wordcloud)   
cname<-"/home/tobias/Dokumente/"#islamicate2.0/hw/corpora/newspaper_archive/Hespress/testing"

##TermDocumentMatrix(my.data[4], control = list(wordLengths = c(3,10))) 

data <- read.csv("/home/tobias/Dokumente/2011_01_01-2012_12_11.csv"
,encoding = "UTF-8",sep = ",")
#    

docs <- Corpus(DataframeSource(data.frame(data[,4])))
### ich will eignetlich nur den text untersuchen.
### hier les ich halt alles. punkte, nummers und whitespace werden aber trotzdem 
## entfernt, sodass das keinen unterschied machen sollte


#docs <- Corpus(DirSource(cname))   
#docs<-data.corp

tharwa.urls <- scan("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/thawra_urls_2014.txt", what="", sep="\n")

stop.words<-scan(file="/home/tobias/Downloads/stopwords_ar.txt",what = "", sep="\n",encoding = "UTF-8")
stop.words<-paste(stop.words,collapse = " ")

### first transliterate stop-words and text -> then remove stopwords
# stop.words.transliterated<-stem(stop.words, cleanChars = TRUE, cleanLatinChars = TRUE,
#      transliteration = TRUE, returnStemList = FALSE)
# 
# 
# 
# text.c<-stem(data[,4], cleanChars = TRUE, cleanLatinChars = TRUE,
#              transliteration = TRUE, returnStemList = FALSE)
# ## da sbrings nicht
# removeWords(text.c,stop.words.transliterated)

# stem(head(data[,5]), cleanChars = TRUE, cleanLatinChars = TRUE,
#      transliteration = FALSE, returnStemList = FALSE)




funcs <- list(tolower, removePunctuation, removeNumbers, stripWhitespace,cleanChars,stem)


docs <- tm_map(docs, FUN = tm_reduce, tmFuns = funcs)
docs<- tm_map(docs, stem, cleanChars = TRUE, cleanLatinChars = TRUE,
                         transliteration = TRUE, returnStemList = FALSE)

docs <- tm_map(docs, PlainTextDocument)   

dtm <- DocumentTermMatrix(docs)   

freq <- colSums(as.matrix(dtm))   
ord <- order(freq)   
dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   

freq[tail(ord)]   ## most frequ words



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




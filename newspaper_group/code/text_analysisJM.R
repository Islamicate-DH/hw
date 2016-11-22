##sudo apt-get install r-cran-slam
#install.packages('tm')


### this will aquire a lot of data. you might have to rm some of the big objects on the way
### since the variables are all 'global'
rm(list=ls())
library(tm)
library(ggplot2)   
library(arabicStemR)

library(wordcloud)   

### set the directory with files. you might have several corpuses or one file for each article
#### just skipt this for at this moment.

# cname<-file.path("C:/Users/John/Documents/alwatan")
# ### read the data into the 'Corpus' object
# docs <- Corpus(DirSource(cname)) 

### this step comes later..
# TermDocumentMatrix(data[4], control = list(wordLengths = c(3,10)))
# TermDocumentMatrix(Corpus(DataframeSource(data.frame(data[,4]))))

### an alternative way to load data
## you have to set header=FALSE
filename<-"/home/tobias/Dropbox/Dokumente/islamicate2.0/reducedfiles/alwatan_stem_tr.csv"
base_corpus <- read.table(filename, sep=",", header=FALSE,encoding = "UTF-8",stringsAsFactors = F)

data <- read.csv(filename, encoding = "UTF-8",sep = ",",header = FALSE,stringsAsFactors=F)

### some additional cleaning.

data[,2] <- gsub("[[:punct:]]", " ", data[,2])  # replace punctuation with space
# data[,2] <- gsub("[[:cntrl:]]", " ", data[,2])  # replace control characters with space
# data[,2] <- gsub("^[[:space:]]+", "", data[,2]) # remove whitespace at beginning of documents
# data[,2] <- gsub("[[:space:]]+$", "", data[,2]) # remove whitespace at end of documents
# data[,2] <- gsub("[0-9]", "", data[,2]) #remove numbers
# data[,2]<- gsub("[:alpha:]","", data[,2])

my.input.data<-data.frame(data[,2],stringsAsFactors = F)

stop_words<-scan(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/stopwords_ar_tr.txt",what = "", sep="\n",encoding = "UTF-8")
# stop.words<-scan(file="/home/tobias/Downloads/stopwords_ar.txt",what = "", sep="\n",encoding = "UTF-8")
stop.words<-paste(stop.words,collapse = " ")


docs <- Corpus(DataframeSource(data.frame(as.character(my.input.data))))

docs <- tm_map(docs, removeWords, stop_words)## doesn't seem to work
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, PlainTextDocument)   ###
dtm <- DocumentTermMatrix(docs)
#dtms <- removeSparseTerms(dtm, 0.1)
#inspect(dtms)

# freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)

freq <- colSums(as.matrix(dtm))   
ord <- order(freq)   


freq[tail(ord)]   ## most frequ words


set.seed(124)   
png("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/pics/alwatan_tr.png", width=1280,height=800)
pal2 <- brewer.pal(8,"Dark2")
# wordcloud(names(freq), freq, max.words=100)   

wordcloud(names(freq),  freq,scale=c(8,1),max.words = 100
         ,colors=pal2)
dev.off()



#write.csv(data.frame(names(freq),freq, stringsAsFactors=F),col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/AlWatan/mfw.csv",sep = ",", quote = F,fileEncoding = "UTF-8",append = F)


# ret<-reverse.transliterate(names(freq[1:1000]))
# ret<-sapply(names(freq),reverse.transliterate)
# ret<-tail(ret)

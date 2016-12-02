##sudo apt-get install r-cran-slam
#install.packages('tm')


### this will aquire a lot of data. you might have to rm some of the big objects on the way
### since the variables are all 'global'
rm(list=ls())
library(tm)
library(ggplot2)   
library(arabicStemR)

library(wordcloud)   

#library(bigmemory)
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

as.big.matrix <- function(x) {
  nr <- x$nrow
  nc <- x$ncol
  # nr and nc are integers. 1 is double. Double * integer -> double
  y <- matrix(vector(typeof(x$v), 1 * nr * nc), nr, nc)
  y[cbind(x$i, x$j)] <- x$v
  dimnames(y) <- x$dimnames
  y
}
 
getMfw <- function(data, n){
  
  
  
  data[,2] <- gsub("[[:punct:]]", " ", data[,2])  # replace punctuation with space
  data[,2] <- gsub("[[:cntrl:]]", " ", data[,2])  # replace control characters with space
  data[,2] <- gsub("[0-9]", " ", data[,2]) #remove numbers
  data[,2] <- gsub("^[[:space:]]+", "", data[,2]) # remove whitespace at beginning of documents
  data[,2] <- gsub("[[:space:]]+$", "", data[,2]) # remove whitespace at end of documents

#  data<-data[1:5000,]## more is resulting in memory overflow

  data <- data[!is.null(data[,2]),]

  
  #docs= Corpus(VectorSource(data[,2]))
  docs <- Corpus(DataframeSource(data.frame(data[,2],stringsAsFactors = F)))
  docs <- tm_map(docs, PlainTextDocument)   ###
  dtm <- DocumentTermMatrix(docs,control = list(wordLengths=c(4,20)))


  freq <- colSums(as.matrix(dtm))   
  ord <- order(freq)   
  return(freq[tail(ord,n)])
  }



filename<-"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/ahram.csv"
data <- read.csv(filename, encoding = "UTF-8",sep = ",",header = FALSE,stringsAsFactors=F)#########
# be careful and don't confuse the files...

n<- 100# amount of words you want to have
ahram.freq <- getMfw(data,n)
alwatan.freq <-  getMfw(data,n)
hespress.freq <-  getMfw(data,n)
thawra.freq <-  getMfw(data,n)
almasralyoum.freq <- getMfw(data[,2],n)

#saveRDS(almasralyoum.freq, "/home/tobias/Dropbox/Dokumente/islamicate2.0/almasralyoum.freq.rds")
# I saved the data but maybe you don't have to do that



alwatan.freq <- readRDS("/home/tobias/Dropbox/Dokumente/islamicate2.0/alwatan.freq.rds")
ahram.freq <- readRDS("/home/tobias/Dropbox/Dokumente/islamicate2.0/ahram.freq.rds")
hespress.freq <- readRDS("/home/tobias/Dropbox/Dokumente/islamicate2.0/hespress.freq.rds")
thawra.freq <- readRDS("/home/tobias/Dropbox/Dokumente/islamicate2.0/thawra.freq.rds")
almasralyoum.freq <- readRDS("/home/tobias/Dropbox/Dokumente/islamicate2.0/almasralyoum.freq.rds")


alwatan<- paste(names(alwatan.freq),collapse = " ")
ahram <- paste(names(ahram.freq), collapse = " ")
hespress <- paste(names(hespress.freq), collapse = " ")
thawra <- paste(names(thawra.freq), collapse = " ")
almasralyoum <- paste(names(almasralyoum.freq), collapse = " ")

## each colum: one newspaper.
all<- c(alwatan, ahram, hespress, thawra, almasralyoum)

corpus= Corpus(VectorSource(all))
tdm = TermDocumentMatrix(corpus)
tdm = as.matrix(tdm)
tdm <- tdm[2:dim(tdm)[1],]

colnames(tdm) = c("Alwatan", "Ahram", "Hespress", "Thawra", "Almasralyoum")

## first calc mfw then comparison cloud

# comparison cloud
set.seed(124)   
pal2 <- brewer.pal(8,"Dark2")
png("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/pics/comp.png", width=2560,height=1080)
comparison.cloud(tdm, random.order=FALSE, 
                 scale=c(4,.5),use.r.layout=FALSE,
                 colors = pal2,
                 max.words=10000)
dev.off()

# set.seed(124)   
# pal2 <- brewer.pal(8,"Dark2")
# png("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/pics/comm.png", width=2560,height=1080)
# commonality.cloud(tdm, random.order=FALSE, 
#                  scale=c(4,.5),use.r.layout=FALSE,title.size=3,
#                  colors = pal2,
#                  max.words=1000)
# dev.off()




# set.seed(124)   
# png("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/pics/alwatan_tr.png", width=1280,height=800)
# pal2 <- brewer.pal(8,"Dark2")
# # wordcloud(names(freq), freq, max.words=100)   
# 
# wordcloud(names(freq),  freq,scale=c(8,1),max.words = 100
#          ,colors=pal2)
# dev.off()



#write.csv(data.frame(names(freq),freq, stringsAsFactors=F),col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/AlWatan/mfw.csv",sep = ",", quote = F,fileEncoding = "UTF-8",append = F)


# ret<-reverse.transliterate(names(freq[1:1000]))
# ret<-sapply(names(freq),reverse.transliterate)
# ret<-tail(ret)

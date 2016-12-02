
rm(list=ls())


# might be nec. to change this.

source("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/code/basic_functions.R")

# 
# # ####
 corpus2011<-read.csv(file="/home/tobias/Schreibtisch/Newspaper Corpus/Hespress/hespress2011.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F )
 corpus2010<-read.csv(file="/home/tobias/Schreibtisch/Newspaper Corpus/Hespress/hespress2010.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
 corpus2010<-corpus2010[corpus2010$V4!="",]
 corpus2011<-corpus2011[corpus2011$V4!="",]
#  # 
# # 
  corpus2011<-f.replaceMonthNames(corpus2011,month.col = 2)
  corpus2010<-f.replaceMonthNames(corpus2010,month.col = 2)
# # 
# # 
# # 
# 
  dec<-corpus2010[which(corpus2010$V2==12),]
# 
# 
ids<-1:dim(dec)[1]
 uri<-paste("HP",dec$V1,dec$V2,SPRINTF(dec$V3),"$",ids,sep = "")

 new.corpus<-data.frame(uri,dec$V4 ,stringsAsFactors = F)
 write.table(new.corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/hespress.csv",sep = ",",fileEncoding = "UTF-8",append = F)

 sp<-dim(dec)[1]
for(i in 1:5){
  month<-corpus2011[which(corpus2011$V2==i),]


  ids<-(sp+1):(sp+dim(month)[1])
  sp<-sp+dim(month)[1]

  uri<-paste("HP",month$V1,SPRINTF(as.integer(month$V2)),SPRINTF(month$V3),"$",ids,sep = "")
  new.corpus<-data.frame(uri,month$V4 ,stringsAsFactors = F)
  write.table(new.corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/hespress.csv",sep = ",",fileEncoding = "UTF-8",append = T)
}

  corpus<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/hespress.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)

  
# 
#   corpus$V2 <- gsub("[[:punct:]]", " ", corpus$V2)  # replace punctuation with space
#   corpus$V2 <- gsub("[[:cntrl:]]", " ", corpus$V2)  # replace control characters with space
#   corpus$V2 <- gsub("^[[:space:]]+", "", corpus$V2) # remove whitespace at beginning of documents
#   corpus$V2 <- gsub("[[:space:]]+$", "", corpus$V2) # remove whitespace at end of documents
#   corpus$V2 <- gsub("[0-9]", "", corpus$V2) #remove numbers
# 
#   corpus$V2<-gsub("[[:ascii]]","", perl=T,corpus$V2 )
#   write.table(corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/hespress_c.csv",sep = ",",fileEncoding = "UTF-8",append = F)
#   
#   
  
  
  
  

  corpus2010_11<-read.csv(file="/home/tobias/Schreibtisch/thawra2010_11.csv",encoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F, comment.char = "")

    corpus2010<-  corpus2010_11[which(corpus2010_11$V1==2010),]
   corpus2011<-corpus2010_11[which(corpus2010_11$V1==2011),]
    corpus2010<-corpus2010[corpus2010$V4!="",]
    corpus2011<-corpus2011[corpus2011$V4!="",]

    corpus2011$V4<- sapply(corpus2011$V4, paste, collapse = "", sep = "")
    corpus2010$V4<-  sapply(corpus2010$V4, paste, collapse = "", sep = "")
#
 dec<-corpus2010[which(corpus2010$V2==12),]

#
 ids<-1:dim(dec)[1]
 uri<-paste("TH",dec$V1,SPRINTF(as.integer(dec$V2)),SPRINTF(as.integer(dec$V3)),"$",ids,sep = "")
#
 new.corpus<-data.frame(uri,dec$V4 ,stringsAsFactors = F)
 write.table(new.corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/thawra.csv",sep = ",",fileEncoding = "UTF-8",append = F)


 sp<-dim(dec)[1]
 for(i in 1:4){

  month<-corpus2011[which(corpus2011$V2==i),]

  ids<-(sp+1):(sp+dim(month)[1])
  uri<-paste("TH",month$V1,SPRINTF(as.integer(month$V2)),SPRINTF(as.integer(month$V3)),"$",ids,sep = "")

  newCorpus<-data.frame(uri,month$V4,stringsAsFactors = F)

  write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/thawra.csv",sep = ",",fileEncoding = "UTF-8",append = T)

 }

 
 
 
# # 
  corpus2011<-read.csv(file="/home/tobias/Schreibtisch/Newspaper Corpus/Ahram/2011_01_01-2012_12_11.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
  corpus2010<-read.csv(file="/home/tobias/Schreibtisch/Newspaper Corpus/Ahram/ahram_dec2010.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
#    corpus2010<-corpus2010[corpus2010$V4!="",]
#    corpus2011<-corpus2011[corpus2011$V4!="",]
#  
#  # 
# # 
#    corpus2010<-f.replaceMonthNames(corpus2010,month.col = 2)
#    corpus2011<-f.replaceMonthNames(corpus2011,month.col = 3)
#   
#     ids<-1:dim(corpus2010)[1]
#     uri<-paste("AH",corpus2010$V1,SPRINTF(as.integer(corpus2010$V2)),SPRINTF(corpus2010$V3),"$",ids,sep = "")
#     new.corpus<-data.frame(uri,corpus2010$V4 ,stringsAsFactors = F)
# 
#     write.table(new.corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/ahram.csv",sep = ",",fileEncoding = "UTF-8",append = T)
# 
# 
# 
#     sp<-dim(corpus2010)[1]
#     for(i in 1:5){
# 
#      month<-corpus2011[which(corpus2011$V3==i),]
#      month<-month[month$V5!="",]
#      ids<-(sp+1):(sp+dim(month)[1])
#      uri<-paste("AH",month$V2,SPRINTF(as.integer(month$V3)),SPRINTF(month$V4),"$",ids,sep = "")
# 
#      newCorpus<-data.frame(uri,month$V5,stringsAsFactors = F)
# 
#      write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/ahram.csv",sep = ",",fileEncoding = "UTF-8",append = T)
# 
#     }
#     
#    ids<-487:(486+dim(corpus2011)[1])
#    uri<-paste("AH",corpus2011$V1,corpus2011$V2,corpus2011$V3,ids,sep = "")
#    new.corpus<-data.frame(uri,corpus2011$V2,stringsAsFactors = F)
#    write.table(new.corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/ahram.csv",sep = ",",fileEncoding = "UTF-8",append = T)


# 
#   corpus2010<-read.csv(file="/home/tobias/Schreibtisch/Newspaper Corpus/AlWatan/dec_alwatan.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
#   corpus2011<-read.csv(file="/home/tobias/Schreibtisch/Newspaper Corpus/AlWatan/alwatan.csv", fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
#   
#   corpus2010<-corpus2010[corpus2010$V4!="",]
#   corpus2011<-corpus2011[corpus2011$V4!="",]
#   
#   SPRINTF(corpus2010$V2)
#   
#   ids<-1:dim(corpus2010)[1]
#   uri<-paste("AL",corpus2010$V1,SPRINTF(corpus2010$V2),SPRINTF(corpus2010$V3),"$",ids,sep = "")
#   newCorpus<-data.frame(uri,corpus2010$V4,stringsAsFactors = F)
#   write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/alwatan.csv",sep = ",",fileEncoding = "UTF-8",append = T)
#   
#   
#   # # alwatan hat keine daten für dec 2010!
#  # corpus2010<-corpus2010_11[which(corpus2010_11$V1==2010),]# empty.
#   corpus2011<-corpus2011[which(corpus2011$V1==2011),]
# 
#      sp<-dim(corpus2010)[1]
#      sp<-1
#      for(i in 1:5){
# 
#       month<-corpus2011[which(corpus2011$V2==i),]
#       month<-month[month$V4!="",]
#       ids<-(sp+1):(sp+dim(month)[1])
#     uri<-paste("AL",month$V1,SPRINTF(month$V2),SPRINTF(month$V3),"$",ids,sep = "")
# 
#       newCorpus<-data.frame(uri,month$V4,stringsAsFactors = F)
# 
#       write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/alwatan.csv",sep = ",",fileEncoding = "UTF-8",append = T)
# 
#      }



    
    
corpus2011 <- read.csv("/home/tobias/Schreibtisch/Newspaper Corpus/almasralyoum/2011.csv", sep="\t", header=FALSE,encoding = "UTF-8",quote="",stringsAsFactors=F)
corpus2010 <- read.csv("/home/tobias/Schreibtisch/Newspaper Corpus/almasralyoum/2010.csv", sep="\t", header=FALSE,encoding = "UTF-8",quote="",stringsAsFactors=F)

   corpus2010<-corpus2010[corpus2010$V2!="",]
   corpus2011<-corpus2011[corpus2011$V2!="",]

## object text.v not found
   
#   dim(corpus2010)[1]
   
   ## das jahr startet bei 1 und nicht bei dem index, bei dem es eigentlich starten soll.
   ## deswegen muss ich zunächst rausfinden, bei welchem index es startet.
   ## und dann rechne ich startindex
   corpus2010<-corpus2010[40488:dim(corpus2010)[1],]
   corpus2011<- corpus2011[1:16692,] # unprecise, but anyway. 
   
   S6PRINTF <- function(x) sprintf("%06d", x)
   SPRINTF <- function(x) sprintf("%02d", x)
   
   corpus2010$V1<-paste("AY",S6PRINTF(corpus2010$V1),sep="")
   corpus2011$V1<-paste("AY",S6PRINTF(corpus2011$V1),sep="")



   write.table(corpus2010,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/almasralyoum.csv", sep="\t",fileEncoding = "UTF-8",append = F)
   write.table(corpus2011,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/almasralyoum.csv", sep="\t",fileEncoding = "UTF-8",append = T)

# library(shiny)
# runApp('/home/tobias/Downloads/ToPan-master/')
# options(shiny.maxRequestSize=30*1024^2)
 

  
   

#########################################################################################################
###################################     TRANSLITERATION, STEMMING     ################################### 
#########################################################################################################
library(arabicStemR)

corpus2011<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/ahram.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F,quote = '')

## gibt ja jeweils tupel zurück, ich brauche aber nur den text.
out<-sapply(corpus2011$V2,myStem )


myStem <- function(article){
  out<-stem(article,returnStemList = T, transliteration = F , cleanChars = T, cleanLatinChars = T)
  return(out$text)
}

ids <- 1: length(out)

newCorpus<-data.frame(ids,out,stringsAsFactors = F)
write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced_stem/ahram_stem.csv",sep = ",",fileEncoding = "UTF-8",append = F)

# b<-reverse.transliterate(out[1])


# 
# stop_words<-scan(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/stopwords_ar.txt",what = "", sep="\n",encoding = "UTF-8")
# out<-sapply(stop_words,myStem )
# out<-out[out!=""]
# newCorpus<-data.frame(ids,out,stringsAsFactors = F)
# write.csv(out,col.names = FALSE,row.names = FALSE,"/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/stopwords_ar_tr.txt",sep = ",", quote = F,fileEncoding = "UTF-8",append = F)

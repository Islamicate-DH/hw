
rm(list=ls())


# might be nec. to change this.


# 
# ####
# corpus2011<-read.csv(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/data/Hespress/hespress2011.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F )
# corpus2010<-read.csv(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/data/Hespress/hespress2010.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
# 
# 
# corpus2011<-f.replaceMonthNames(corpus2011,month.col = 2)
# corpus2010<-f.replaceMonthNames(corpus2010,month.col = 2)
# 
# 
# 
f.replaceMonthNames<- function(corpus,month.col=2){
  Sys.setlocale("LC_TIME", "ar_AE.utf8");
  month.dates<-seq(as.Date("2012-01-01"), as.Date("2012-12-31"), "months")
  month.names<-format(month.dates, "%B")

  for(i in 1:11){
    corpus[which(corpus[,month.col]==month.names[i]),month.col]<-i
  }

  corpus[which(corpus[,month.col]== "دجنبر"),month.col]<-12
  corpus[which(corpus[,month.col]== "ديسمبر"),month.col]<-12
  corpus[which(corpus[,month.col]== "نونبر"),month.col]<-11
  corpus[which(corpus[,month.col]== "اكتوبر"),month.col]<-10
  
  
  corpus[which(corpus[,month.col]== "شتنبر"),month.col]<-9
  corpus[which(corpus[,month.col]== "غشت"),month.col]<-8
  corpus[which(corpus[,month.col]== "غشت"),month.col]<-8
  corpus[which(corpus[,month.col]== "يوليوز"),month.col]<-5
  corpus[which(corpus[,month.col]== "ابريل"),month.col]<-4
  
  
  return(corpus)
}

# dec<-corpus2010[which(corpus2010$V2==12),]



# dec<-dec[dec$V4!="",]
# 
# ids<-1:dim(dec)[1]
# uri<-paste("HP",dec$V1,dec$V2,dec$V3,ids,sep = "")
# 
# new.corpus<-data.frame(uri,dec$V4 ,stringsAsFactors = F)
# write.table(new.corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/hespress.csv",sep = ",",fileEncoding = "UTF-8",append = T)
# 
# sp<-dim(dec)[1]
# for(i in 1:5){
#   month<-corpus2011[which(corpus2011$V2==i),]
#   
#   
#   ids<-(sp+1):(sp+dim(month)[1])
#   sp<-sp+dim(month)[1]
#   
#   uri<-paste("HP",month$V1,month$V2,month$V3,ids,sep = "")
#   new.corpus<-data.frame(uri,month$V4 ,stringsAsFactors = F)
#   write.table(new.corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/hespress.csv",sep = ",",fileEncoding = "UTF-8",append = T)
# }
# 






# corpus2010_11<-read.csv(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/data/Thawra/thawra2010_11.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
# 
# corpus2010<-  corpus2010_10[which(corpus2010_11$V1==2010),]
# corpus2011<-corpus2010_11[which(corpus2010_11$V1==2011),]
# 
# dec<-corpus2010[which(corpus2011$V2==12),]
# dec<-dec[dec$V4!="",]
# 
# ids<-1:dim(dec)[1]
# uri<-paste("TH",dec$V1,dec$V2,dec$V3,ids,sep = "")
# 
# new.corpus<-data.frame(uri,dec$V4 ,stringsAsFactors = F)
# write.table(new.corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/thawra.csv",sep = ",",fileEncoding = "UTF-8",append = T)
# 
#  sp<-dim(dec)[1]
#  for(i in 1:5){
#    
#   month<-corpus2011[which(corpus2011$V2==i),]
#   month<-month[month$V4!="",]
#   ids<-(sp+1):(sp+dim(month)[1])
#   uri<-paste("TH",month$V1,month$V2,month$V3,ids,sep = "")
#   
#   newCorpus<-data.frame(uri,month,stringsAsFactors = F)
#   
#   write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/thawra.csv",sep = ",",fileEncoding = "UTF-8",append = T)
# 
#  }
#  
 
 
 
# 
# corpus2011<-read.csv(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/data/Ahram/2011_01_01-2012_12_11.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
# corpus2010<-read.csv(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/data/Ahram/ahram_dec2010.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
# 
# 
#   corpus2010<-f.replaceMonthNames(corpus2010,month.col = 2)
#   corpus2011<-f.replaceMonthNames(corpus2011,month.col = 3)
#   
#    ids<-1:dim(corpus2010)[1]
#    corpus2010<-corpus2010[corpus2010$V4!="",]
# 
#    ids<-1:dim(corpus2010)[1]
#    uri<-paste("AH",corpus2010$V1,corpus2010$V2,corpus2010$V3,ids,sep = "")
#    new.corpus<-data.frame(uri,corpus2010$V4 ,stringsAsFactors = F)
#    
#    
#    write.table(new.corpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/ahram.csv",sep = ",",fileEncoding = "UTF-8",append = T)
#    
#  
#    
#     sp<-dim(corpus2010)[1]
#     for(i in 1:5){
# 
#      month<-corpus2011[which(corpus2011$V3==i),]
#      month<-month[month$V5!="",]
#      ids<-(sp+1):(sp+dim(month)[1])
#      uri<-paste("AH",month$V2,month$V3,month$V4,ids,sep = "")
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
 # corpus2010_11<-read.csv(file="/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/data/AlWatan/alwatan.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
 # # alwatan hat keine daten für dec 2010!
 # corpus2010<-corpus2010_11[which(corpus2010_11$V1==2010),]# empty.
 # corpus2011<-corpus2010_11[which(corpus2010_11$V1==2011),]
 # 
 #     sp<-dim(corpus2010)[1]
 #     sp<-1
 #     for(i in 1:5){
 # 
 #      month<-corpus2011[which(corpus2011$V2==i),]
 #      month<-month[month$V4!="",]
 #      ids<-(sp+1):(sp+dim(month)[1])
 #      uri<-paste("AL",month$V1,month$V2,month$V3,ids,sep = "")
 # 
 #      newCorpus<-data.frame(uri,month$V4,stringsAsFactors = F)
 # 
 #      write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/alwatan.csv",sep = ",",fileEncoding = "UTF-8",append = T)
 # 
 #     }



    
    
corpus2011 <- read.csv("/home/tobias/Dropbox/Dokumente/islamicate2.0/almasralyoum/2011.csv", sep=",", header=FALSE,encoding = "UTF-8",quote="",stringsAsFactors=F)
corpus2010 <- read.csv("/home/tobias/Dropbox/Dokumente/islamicate2.0/almasralyoum/2010.csv", sep=",", header=FALSE,encoding = "UTF-8",stringsAsFactors=F,quote = "")

## object text.v not found
t2010<-corpus2010$V2[43940:length(corpus2010)]
#t2010<-corpus2010$1[43940:length(corpus2010)]



t2011<- corpus2011$V2[1:18584]
t2011.id<- corpus2011$V1[1:18584]

till<-25994+length(t2010)
  
ids <- 25995: till

newCorpus<-data.frame(ids,t2010,stringsAsFactors = F)
      
write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reducedfiles/almasralyoum.csv",sep = ",",fileEncoding = "UTF-8",append = T)
    

# library(shiny)
# runApp('/home/tobias/Downloads/ToPan-master/')
# options(shiny.maxRequestSize=30*1024^2)
 



#########################################################################################################
###################################     TRANSLITERATION, STEMMING     ################################### 
#########################################################################################################
library(arabicStemR)

corpus2011<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/ahram.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F,quote = "")

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

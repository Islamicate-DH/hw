
rm(list=ls())


# might be nec. to change this.
Sys.setlocale("LC_TIME", "ar_AE.utf8");
month.dates<-seq(as.Date("2012-01-01"), as.Date("2012-12-31"), "months")
month.names<-format(month.dates, "%B")


####
# corpus2011<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/Hespress/hespress2011.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
# corpus2010<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/Hespress/hespress2010.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
# 
# 
# 
#   dec<-corpus2010$V4[which(corpus2010$V2==month.names[12])]
# 
#   jan<-corpus2011$V4[which(corpus2011$V2==month.names[1])]
#   feb<-corpus2011$V4[which(corpus2011$V2==month.names[2])]
#   mar<-corpus2011$V4[which(corpus2011$V2==month.names[3])]
#   apr<-corpus2011$V4[which(corpus2011$V2==month.names[4])]
#   may<-corpus2011$V4[which(corpus2011$V2==month.names[5])]
#   text.v<-c(dec,jan,feb,mar,apr,may)
# 
#   ids <- 1: length(text.v)
# 
#   newCorpus<-data.frame(ids,text.v,stringsAsFactors = F)
# 
# 
# write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reducedfiles/hespress.csv",sep = ",",fileEncoding = "UTF-8",append = F)
# 
# 
# 
# 
# 
# corpus2011<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/Thawra/thawra2010_11.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
# 
# 
# 
# 
# dec<-corpus2011$V4[which(corpus2011$V2=12)]
# 
# jan<-corpus2011$V4[which(corpus2011$V2==1)]
# feb<-corpus2011$V4[which(corpus2011$V2==2)]
# mar<-corpus2011$V4[which(corpus2011$V2==3)]
# apr<-corpus2011$V4[which(corpus2011$V2==4)]
# may<-corpus2011$V4[which(corpus2011$V2==5)]
# text.v<-c(dec,jan,feb,mar,apr,may)
# 
# ids <- 1: length(text.v)
# 
# newCorpus<-data.frame(ids,text.v,stringsAsFactors = F)
# 
# 
# write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reducedfiles/thawra.csv",sep = ",",fileEncoding = "UTF-8",append = F)



corpus2011<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/ahram.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
corpus2011<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/Ahram/ahram_dec2010.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)


# 
   dec<-corpus2011$V4[which(corpus2011$V2==month.names[12])]
# 
#   jan<-corpus2011$V5[which(corpus2011$V3==month.names[1])]
#   feb<-corpus2011$V5[which(corpus2011$V3==month.names[2])]
#   mar<-corpus2011$V5[which(corpus2011$V3==month.names[3])]
#   apr<-corpus2011$V5[which(corpus2011$V3==month.names[4])]
#   may<-corpus2011$V5[which(corpus2011$V3==month.names[5])]
#   
#   text.v<-c(dec,jan,feb,mar,apr,may)
# 
   
   t<-486+length(corpus2011$V2)
   ids <- 487:(t)
   ids<-1:length(dec)
   
   text.v < c(dec,corpus2011$V2)
   newCorpus<-data.frame(ids,c(dec,corpus2011$V2),stringsAsFactors = F)
# 
   
   newCorpus<-data.frame(ids,corpus2011$V2,stringsAsFactors = F)
# 
# 
   write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reduced/ahram.csv",sep = ",",fileEncoding = "UTF-8",append = T)
#   
#   
 #  
 #  
 # corpus2011<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/AlWatan/alwatan.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
 # # alwatan hat keine daten für dec 2010!
 # corp1<-corpus2011[which(corpus2011$V1==2010),]
 # corp2<-corpus2011[which(corpus2011$V1==2011),]
 # 
 #   jan<-corp2$V4[which(corp2$V3==1)]
 #   feb<-corp2$V4[which(corp2$V3==2)]
 #   mar<-corp2$V4[which(corp2$V3==3)]
 #   apr<-corp2$V4[which(corp2$V3==4)]
 #   may<-corp2$V4[which(corp2$V3==5)]
 #   text.v<-c(jan,feb,mar,apr,may)
 #   ids <- 1: length(text.v)
 #   newCorpus<-data.frame(ids,text.v,stringsAsFactors = F)
 #    write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reducedfiles/alwatan.csv",sep = ",",fileEncoding = "UTF-8",append = F)
 #   
 #   
 #    
    
    
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

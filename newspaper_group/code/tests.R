
rm(list=ls())


# might be nec. to change this.
Sys.setlocale("LC_TIME", "ar_AE.utf8");
month.dates<-seq(as.Date("2012-01-01"), as.Date("2012-12-31"), "months")
month.names<-format(month.dates, "%B")


####
corpus2011<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/Hespress/hespress2011.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)
corpus2010<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/Hespress/hespress2010.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)



  dec<-corpus2010$V4[which(corpus2010$V2==month.names[12])]

  jan<-corpus2011$V4[which(corpus2011$V2==month.names[1])]
  feb<-corpus2011$V4[which(corpus2011$V2==month.names[2])]
  mar<-corpus2011$V4[which(corpus2011$V2==month.names[3])]
  apr<-corpus2011$V4[which(corpus2011$V2==month.names[4])]
  may<-corpus2011$V4[which(corpus2011$V2==month.names[5])]
  text.v<-c(dec,jan,feb,mar,apr,may)

  ids <- 1: length(text.v)

  newCorpus<-data.frame(ids,text.v,stringsAsFactors = F)


write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reducedfiles/hespress.csv",sep = ",",fileEncoding = "UTF-8",append = F)





corpus2011<-read.csv(file="/home/tobias/Dropbox/Dokumente/islamicate2.0/Thawra/thawra2010_11.csv",fileEncoding = "UTF-8",sep=",",header = FALSE,stringsAsFactors=F)




dec<-corpus2011$V4[which(corpus2011$V2=12)]

jan<-corpus2011$V4[which(corpus2011$V2==1)]
feb<-corpus2011$V4[which(corpus2011$V2==2)]
mar<-corpus2011$V4[which(corpus2011$V2==3)]
apr<-corpus2011$V4[which(corpus2011$V2==4)]
may<-corpus2011$V4[which(corpus2011$V2==5)]
text.v<-c(dec,jan,feb,mar,apr,may)

ids <- 1: length(text.v)

newCorpus<-data.frame(ids,text.v,stringsAsFactors = F)


write.table(newCorpus,col.names = FALSE,row.names = FALSE,"/home/tobias/Dropbox/Dokumente/islamicate2.0/reducedfiles/thawra.csv",sep = ",",fileEncoding = "UTF-8",append = F)



 

# library(shiny)
# runApp('/home/tobias/Downloads/ToPan-master/')
# options(shiny.maxRequestSize=30*1024^2)

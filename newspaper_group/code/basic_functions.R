# sleeping function as found in tafaseer_topic_group

sleep <- function(s)
{
  t0 = proc.time()
  Sys.sleep(s)
  proc.time() - t0
}



generateTimeSequence <- function(start,end){
  days.to.observe<-seq(as.Date(start), as.Date(end), "days")
  days.to.observe<-gsub(" 0", " ", format(days.to.observe, "%Y %m %d"))
  return(gsub(" ","/",days.to.observe))
}

getLinks <- function(homepage.url,link.element){
  homepage <- read_html(homepage.url)
  link.element.v<-homepage %>%
    html_nodes(link.element) %>% html_attr("href")
  homepages.v<-unlist(link.element.v)
  homepages.v<-homepages.v[homepages.v!=""]
  return(homepages.v)
}
# padding.
SPRINTF <- function(x) sprintf("%02d", x)


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

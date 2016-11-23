##                                                                        
##                            Hespress Scraper
##
## 

# sleep, generateTimeSequence


rm(list=ls())

libs<-c("rvest","stringr","tidyr","methods","beepr","curl")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}

source("basic_functions.R")
source("scrapeR.R")
source("cleanR.R")



###############################################################################
##                          CALLING THE SCRIPTS
###############################################################################



## First I set a time-sequence which I want to download. Here I chose 1 year.
## The function generates 365 date for each day (or more if you chose a larger intervall).
days.to.scrape<-generateTimeSequence("2016/1/1","2016/10/31")
hp.base<-"http://www.hespress.com/archive/"

## Here I generate the direct pages to the first index-page of the corresponding day.
## Usually it's not shown since it's implicit, but it makes things easier lateron.
days.to.scrape.url.v<-sapply(hp.base,paste,days.to.scrape,"/index.1.html",sep="")
## The function to scrape the website can be called for each day with sapply.


sapply(days.to.scrape.url.v, scrape.day.hespress)


option_list = list(
  make_option(
    c('-b', '--day'),
    action='store', default=NA, type='character',
    help='Where to start downloading.')
); o = parse_args(OptionParser(option_list=option_list))

#scrape.day(o$day)
#source.folder<- "hespress2011"
#clean.hespress(source.folder)

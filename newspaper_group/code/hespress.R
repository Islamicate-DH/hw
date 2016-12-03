# Copyright Tobias Wenzel
# In Course: Islamicate World 2.0
# University of Maryland, University Leipzig
#
# File description:
#     Hespress main file.
# 
rm(list=ls())


source("basic_functions.R")
source("scrapeR.R")
source("cleanR.R")


## First I set a time-sequence which I want to download. Here I chose 1 year.
## The function generates 365 date for each day (or more if you chose a larger intervall).
days.to.scrape<-generateTimeSequence("2016/1/1","2016/10/31")
hp.base<-"http://www.hespress.com/archive/"

## Here I generate the direct pages to the first index-page of the corresponding day.
## Usually it's not shown since it's implicit, but it makes things easier lateron.
days.to.scrape.url.v<-sapply(hp.base,paste,days.to.scrape,"/index.1.html",sep="")
## The function to scrape the website can be called for each day with sapply.

target.folder <- "~/Schreibtisch/hespress2010"
sapply(days.to.scrape.url.v, scrape.day.hespress, target.folder)


source.folder<- target.folder
clean.hespress(source.folder)

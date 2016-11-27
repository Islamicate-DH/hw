##                  
##                            Al-Watan Scraper
##
##      
rm(list=ls())## clean the workspace
setwd("~/Dokumente/islamicate2.0/project/al-watan") # setting working directory

source("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/code/scrapeR.R")
source("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/code/cleanR.R")
libs<-c("rvest","stringr","tidyr","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}


urls<-scan(file="/media/tobias/tobias_wenzel/Newspaper Archive/Al-Watan/alwatan.links", what="character",sep = "\n")

sapply(urls,scrape.article.alwatan)
scrape.article.alwatan(urls[1])

clean.alwatan("/home/tobias/Dropbox/Dokumente/islamicate2.0/dec2010/")

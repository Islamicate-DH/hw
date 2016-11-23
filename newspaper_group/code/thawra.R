##                                                                        
##                            THAWRA
##
## 


rm(list=ls())

libs<-c("rvest","stringr","tidyr","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}
source("basic_functions.R")

# actually not needed.
#setwd("~/Dokumente/islamicate2.0/project/hespress") # setting working directory
# for scraping
target.folder<- "~/Dokumente/islamicate2.0/hw/corpora/newspaper_archive/tharwa"
base.url<-"http://thawra.sy/"

tharwa.urls <- scan("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/thawra_urls_2014.txt", what="", sep="\n")
lapply(tharwa.urls,scrape.day.thawra)



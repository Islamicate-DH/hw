##                  
##                            Al-Watan Scraper
##
##      
rm(list=ls())## clean the workspace
setwd("~/Dokumente/islamicate2.0/project/al-watan") # setting working directory

libs<-c("rvest","stringr","tidyr","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}



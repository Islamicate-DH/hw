
libs<-c("rvest","stringr","tidyr","optparse","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}

source("scrapeR.R")
source("cleanR.R")

source.folder<-"/home/tobias/Downloads/almasryalyoum/2011"
clean.almasryalyoum(source.folder)


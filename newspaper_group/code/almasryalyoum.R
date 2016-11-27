
libs<-c("rvest","stringr","tidyr","optparse","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}

source("scrapeR.R")
source("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/code/cleanR.R")

source.folder<-"/home/tobias/Schreibtisch/2010"
clean.almasryalyoum(source.folder)


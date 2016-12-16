# Copyright Tobias Wenzel
# In Course: Islamicate World 2.0
# University of Maryland, University Leipzig
#
# File description:
#     Al-Watan main file.
rm(list=ls())## clean the workspace

source("scrapeR.R")
source("cleanR.R")


urls<-scan(file="alwatan.links", what="character",sep = "\n")

target.folder<- "~/Dokumente/hw/corpora/newspaper_archive/alwatan"
sapply(urls,scrape.article.alwatan, target.folder)

source.folder <- target.folder
clean.alwatan(source.folder)

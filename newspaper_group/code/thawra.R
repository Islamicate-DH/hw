# Copyright Tobias Wenzel
# In Course: Islamicate World 2.0
# University of Maryland, University Leipzig
#
# File description:
#     Thawra main file.

rm(list=ls())

source("basic_functions.R")
source("cleanR.R")
source("scrapeR.R")

tharwa.urls <- scan("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/thawra_urls_2014.txt", what="", sep="\n")

target.folder<- "~/Dokumente/hw/corpora/newspaper_archive/tharwa"
lapply(tharwa.urls, scrape.day.thawra, target.folder)


source.folder<- target.folder
clean.thawra(source.folder)

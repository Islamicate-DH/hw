##                                                                        
##                            Ahram Scraper
##
## 

rm(list=ls())
#setwd("~/Dokumente/islamicate2.0/hw/newspaper_group/Aharam/2013/") # setting working directory

libs<-c("rvest","stringr","tidyr","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}

source("basic_functions.R")
######################################################################################################
#                                           NOTES
######################################################################################################

## some dependencies etc.
##libssl-dev
# install.packages('stringi', configure.args='--disable-cxx11')
# libxml2-dev
# sudo apt-get install libcurl4-openssl-dev
# install.packages("rvest") # error fixed
# install.packages("yaml")
#install.packages("optparse")
# install.packages("tidyr)
# do i have to traverse all stories on the right side or just the top stories?  
# the problem is that the top stories include articles about europe etc. too.

# i could also scrape different things like the headlines, wich might be more interesting or the middle east section
# the structure remains the same. please tell me where i should scrape- or do you really want to have everything?


## creating subfolders for months 

## stolen from tafaseer_topic_group...
# Get Parameters passed by the bash script
option_list = list(
  make_option(
    c('-b', '--day'), 
    action='store', default=NA, type='character',
    help='Where to start downloading.')
); o = parse_args(OptionParser(option_list=option_list))


###############################################################################
##                          CALLING THE FUNCTIONS
###############################################################################


## if you're just starting the script
## this might be a better to read:
## the function is called per day.
#days.to.observe.v<-generateTimeSequence("2012-12-11","2016-10-31")
#sapply(days.to.observe.v, scrapeAhramDay)
#sapply(days.to.observe.v, scrapeRaw)



## with bash-script
#scrape.day.ahram(o$day)# causes an error.

#scrape.day.ahram("2013/1/1")
scrape.day.ahram(o$day)


#clean.ahram(dirname = "raw_2012_12_12-2016_10_31")


# Copyright Tobias Wenzel
# In Course: Islamicate World 2.0
# University of Maryland, University Leipzig
#
# File description:
#     Ahram main file. For scraping use bash-script to use tmux.
# 
######################################################################################################
#                                           NOTES
######################################################################################################
## some dependencies etc.
##libssl-dev, libxml2-dev
# install.packages('stringi', configure.args='--disable-cxx11')
# sudo apt-get install libcurl4-openssl-dev
# install.packages("rvest") # error fixed
#install.packages("optparse")
# install.packages("tidyr)

rm(list=ls())


source("scrapeR.R")
source("basic_functions.R")
source("cleanR.R")


## compare tafaseer_topic_group...
# Get Parameters passed by the bash script
option_list = list(
  make_option(
    c('-b', '--day'), 
    action='store', default=NA, type='character',
    help='Where to start downloading.')
); o = parse_args(OptionParser(option_list=option_list))



target.folder <- "~/Downloads/ahram"
scrape.day.ahram(o$day, target.folder)

# source.folder <- target.folder
# clean.ahram(source.folder)


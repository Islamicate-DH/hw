##                                                                        
##                            alghad Scraper
##
## 


rm(list=ls())
source("basic_functions.R")
# actually not needed.
#setwd("~/Dokumente/islamicate2.0/project/hespress") # setting working directory
# for scraping
target.folder<- "~/Dokumente/islamicate2.0/hw/corpora/newspaper_archive/tharwa"
base.url<-"http://thawra.sy/"

libs<-c("yaml","rvest","stringr","tidyr","optparse","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}



# homepage.url<-"http://alghad.com"
# homepage <- read_html(homepage.url)
# # years. i want days
# homepage %>%  html_nodes("ul#tabobj_year li")  %>% html_text()
# 
# getLinks()

scrapeArticle <- function(homepages.day){
  ## would be even better to pass filenames as vectors.
  my.filename <- paste(target.folder,"/", gsub("/", "_", homepages.day),".html", sep = "")
  
  if(!file.exists(my.filename)){
    
    tryCatch({
      homepage.day.article<-read_html(homepages.day,encoding = "Windows-1256")
      write_xml(homepage.day.article,my.filename)
      
      sleep(0.1)}
      ,error = function(e){
        write(homepages.day,paste(target.folder,'log',sep=""),append = TRUE)
      })
    
  }# end of file.exists
  else{
    print(paste("skip",homepages.day,"because i have it already.",sep=" "))
  }
}

scrapeRaw<- function(day.homepage.url){

  ## python-skript:
  ## generates a sequence of 'pseudo-dates', i.e. number which start at some random (?)
  ## point and then increase each day.

  
  homepage <- read_html(day.homepage.url,encoding = "Windows-1256") ## charset!
  print(day.homepage.url)
  ## get links and prepend base.url
  homepages.to.scrape<-homepage %>%  html_nodes("p a")  %>% html_attr("href")
  homepages.day.v<-sapply(base.url,paste, homepages.to.scrape[grep("archive",homepages.to.scrape)], sep="")
  
  sleep(0.1)

  sapply(homepages.day.v, scrapeArticle)

} # end of scrapeRaw-function




tharwa.urls <- scan("/home/tobias/Dokumente/islamicate2.0/hw/newspaper_group/thawra_urls_2014.txt", what="", sep="\n")
lapply(tharwa.urls,scrapeRaw)


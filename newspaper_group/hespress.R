##                                                                        
##                            Hespress Scraper
##
## 

# sleep, generateTimeSequence


rm(list=ls())
source("basic_functions.R")
# actually not needed.
#setwd("~/Dokumente/islamicate2.0/project/hespress") # setting working directory

libs<-c("yaml","rvest","stringr","tidyr","optparse","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}
library(curl)
###############################################################################
##                              FUNCTIONS
###############################################################################


scrape.index<- function(day.links,target.folder){
  for (link in day.links) {
    file <- paste(target.folder, gsub("/", "_", link), sep = "")
    ## if the file is already downloaded, skip it.
    if (!file.exists(file)) {
      tryCatch({
        article.homepage<-read_html(curl(paste("http://www.hespress.com", link, sep = ""), handle = curl::new_handle("useragent" = "Mozilla/5.0")), encoding = "UTF-8")
        write_xml(article.homepage, file)
        sleep(0.1)
      }
      , error = function(e) {
        write(gsub("/", "_", link),
              paste(target.folder,"missed.log",sep=""),
              append = TRUE)
      })
    }
  }
  
}

### source folder ist hier irreführend
scrape.day <- function(hespress.url) {
  target.folder<-"~/Dokumente/islamicate2.0/hw/corpora/newspaper_archive/Hespress/hespress2014/"
    
  ## while there is still another index-page for the current day continue scraping.
  while (length(grep("index", hespress.url)) > 0) {

    tryCatch({ 
      homepage<-read_html(hespress.url)
             
      day.links <- homepage %>% html_nodes("h2.section_title a") %>% html_attr("href")
      scrape.index(day.links,target.folder)## Each index page has several articles which I want to save.
      print(hespress.url)
      hespress.url <- homepage %>% html_node("span.page_active+a") %>% html_attr("href") # go to next index
    }, error = function(e) {
      print(paste(hespress.url,e,sep=" "))
    })

  }
  
}


clean.hespress <- function(source.folder){
  
  for (my.filename in dir(source.folder,full.names = TRUE, no.. = TRUE)){
    # To avoid crashes, I wrapped everything in a tryCatch. If something goes wrong,
    # the page is noted in the log.
    tryCatch({
      
      article.homepage<-read_html(my.filename,encoding = "UTF-8")
      title.c<-article.homepage %>%
        html_nodes("h1.page_title") %>% html_text()
      # date extraction see ahram
      date<-str_split(article.homepage %>%
                        html_nodes("span.story_date") %>% html_text(), " ")
      month<- date[[1]][3]
      day<-date[[1]][2]
      year<-date[[1]][4]
      ## there seems to be "garbage" at the end of some texts. we should exclude non-arabic letter, i.e. a-Z
      text.c<-article.homepage %>%
        html_nodes("div#article_body p") %>% html_text()
      
      ## since all homepages look the same I can skip the if-statements (cf. al-watan.R)
      write.table(data.frame(year,month,day,gsub("\"","",text.c),gsub("\"","",title.c),"Hespress",my.filename),col.names = FALSE,row.names = FALSE,paste(source.folder,".csv",sep=""),sep = ",",fileEncoding = "UTF-8",append = T)
    },error =function(e){write(paste("page",my.filename,"could not be loaded",sep=" "),"log",append = TRUE )})
    
  }
  
  for(i in 1:4){beep(i)}# To remind you to continue working while you are drinking your coffee.
  
}

###############################################################################
##                          CALLING THE SCRIPTS
###############################################################################



## First I set a time-sequence which I want to download. Here I chose 1 year.
## The function generates 365 date for each day (or more if you chose a larger intervall).
days.to.scrape<-generateTimeSequence("2014/1/1","2014/12/31")
hp.base<-"http://www.hespress.com/archive/"

## Here I generate the direct pages to the first index-page of the corresponding day.
## Usually it's not shown since it's implicit, but it makes things easier lateron.
days.to.scrape.url.v<-sapply(hp.base,paste,days.to.scrape,"/index.1.html",sep="")
## The function to scrape the website can be called for each day with sapply.


sapply(days.to.scrape.url.v, scrape.day)


# option_list = list(
#   make_option(
#     c('-b', '--day'), 
#     action='store', default=NA, type='character',
#     help='Where to start downloading.')
# ); o = parse_args(OptionParser(option_list=option_list))
# 
# scrape.day(o$day)
#source.folder<- "hespress2011"
#clean.hespress(source.folder)

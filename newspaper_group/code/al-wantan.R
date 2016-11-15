##                  
##                            Al-Watan Scraper
##
##      
rm(list=ls())## clean the workspace
setwd("~/Dokumente/islamicate2.0/project/al-watan") # setting working directory

libs<-c("yaml","rvest","stringr","tidyr","optparse","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}



clean.alwatan<- function(){

  for (my.filename in dir("raw",full.names = TRUE, no.. = TRUE)){
    # To avoid crashes, I wrapped everything in a tryCatch. If something goes wrong,
    # the page is noted in the log.
      tryCatch({
      ## The files do differ in their structure/tags, so I added some (more or less pragmatic)
      ## if-statements which test, whether the page has a title with the corresponding tag, meaning it exists.
      homepage<-read_html(my.filename,encoding = "UTF-8")
      title.c<-homepage %>% html_nodes("span#ctl00_ContentPlaceHolder1_lblHeading") %>% html_text()
      if(length(title.c)!=0){
        # if length==0, title doesn't exist, i.e. the page doesn't have the tag
        ## Homepages which have a structure like
        ##news.aspx?n=F29C6BDC-0285-4256-8BF5-9E3729766652&d=20120425
        text.c<-homepage %>%
          html_nodes("span#ctl00_ContentPlaceHolder1_lblDescription") %>% html_text()
        year<-str_sub(my.filename,-8,-5)
        month<-str_sub(my.filename,-4,-3)
        day<-str_sub(my.filename,-2,-1)
       }
    
     else{
       ## Homepages which have a structure like
       ##  /watan_news.aspx?id=2999
       title.c<-homepage %>% html_nodes("span#ctl00_ContentPlaceHolder1_LatestNews1_lblHeading") %>% html_text()
       ##  The date is not in filename. Thus we have to extract the digits. 
       ##  If the title doesn't exist we can skip that.
       if(length(title.c)!=0){
         date<-str_split(homepage %>% html_nodes("span#ctl00_ContentPlaceHolder1_LatestNews1_lbl_date") %>% html_text(),"/")
         day<-date[[1]][1]; month<-date[[1]][2]; year<- substr(date[[1]][3],1,4)
         text.c<-homepage %>% html_nodes(" span#ctl00_ContentPlaceHolder1_LatestNews1_lblDescription.NewsTickerDescription") %>% html_text()
       }
     }
     if(length(title.c)!=0){
       # again, check whether there was a title an append the new data to the csv.
      write.table(data.frame(year,month,day,gsub("\"","",text.c),gsub("\"","",title.c),"Al-Watan",my.filename),col.names = FALSE,row.names = FALSE,"alwatan.csv",sep = ",",fileEncoding = "UTF-8",append = T)
     }else{
       # else write a log with a message so we can find the page
       write(paste("page",my.filename, "had no suitable tag/text",sep=" "),"log",append = TRUE )
     }
     },error =function(e){write(paste("page",my.filename,"could not be loaded",sep=" "),"log",append = TRUE )})
    
      
    }
    
    for(i in 1:4){beep(i)}# To remind you to continue working while you are drinking your coffee.

}
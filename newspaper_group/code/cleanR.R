##### clean- functions
libs<-c("yaml","rvest","stringr","tidyr","optparse","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}

###############################################################################
##                              ALMASRYALYOUM
###############################################################################
clean.almasryalyoum <- function(source.folder){
  i<-1
  for (my.filename in dir(source.folder,full.names = TRUE, no.. = TRUE)){
    # To avoid crashes, I wrapped everything in a tryCatch. If something goes wrong,
    # the page is noted in the log.
    #  my.filename <- "/home/tobias/Schreibtisch/article2.aspx?ArticleID=271848"
    tryCatch({
      
      article.homepage<-read_html(my.filename,encoding = "UTF-8")
      
      title.c<- article.homepage %>% html_nodes(xpath="//font[@color='#AB0202'and @size='5']//b") %>% html_text()
      # date extraction see ahram
      
      text.c<-paste(article.homepage %>% html_nodes(xpath="//font[@size='2' and @face='Tahoma']//p") %>% html_text(),collapse = " ")
      
      
      ### dann haben wir halt erstmal kein datum.
      ## wenn wir den zeitraum eingrenzen ist das eh schnuppe
      
      # date<- article.homepage %>% html_nodes(xpath='//table[@id="table32"]') %>% html_text()
      # date<-unlist(str_split(date, " "))
      ### website benutzt dieses format
      ###   &#1634;/ &#1633;&#1632;/ &#1634;&#1632;&#1633;&#1632;
      
      # month<- date[[1]][3]
      # day<-date[[1]][2]
      # year<-date[[1]][4]
      ## there seems to be "garbage" at the end of some texts. we should exclude non-arabic letter, i.e. a-Z
      
      
      ## since all homepages look the same I can skip the if-statements (cf. al-watan.R)
      write.table(data.frame(i,sub("\"","",text.c),gsub("\"","",title.c)),col.names = FALSE,row.names = FALSE,paste(source.folder,".csv",sep=""),sep = ",",quote = "",fileEncoding = "UTF-8",append = T)
      i<-i+1
    },error =function(e){write(paste("page",my.filename,"could not be loaded",sep=" "),"log",append = TRUE )})
    
  }
  
   for(i in 1:4){beep(i)}# To remind you to continue working while you are drinking your coffee.
  
}


###############################################################################
##                              AHRAM
###############################################################################

clean.ahram<- function(dirname){
  
  my.filename<-paste(dirname,".csv",sep = "")
  print(my.filename)
  for(my.file in dir(dirname,pattern = "*.aspx")){
    
    tryCatch({
      
      ahram.homepage <- read_html(paste(dirname,"/",my.file,sep=""),encoding = "UTF-8")
      
      text.c<-ahram.homepage %>% html_node("div#txtBody.bbBodyp") %>% html_text() # get the text
      # gsub removes "
      if(nchar(text.c)>1){
        # if there is any text, append it to the table. 
        title<-ahram.homepage %>% html_node("div#divtitle") %>% html_text() # get title
        my.date<- ahram.homepage %>% html_node("td#header1_DateTD") %>% html_text() # get title
        my.date<-unlist(strsplit(my.date," ")) # splitting the date-string into substrings
        year<-suppressWarnings(min(my.date[which(as.numeric(my.date)>=2010)]))
        month<- my.date[which(my.date==year)-1]
        day<-my.date[which(my.date==year)-2]
        write.table(data.frame(year,month,day,gsub("\"","",text.c),gsub("\"","",title),"Ahram",my.file),col.names = FALSE,row.names = FALSE,my.filename,sep = ",",fileEncoding = "UTF-8",append = T)
      } else{
        # else write a log with a message so we can find the page
        write(paste("page",my.file, "had no suitable tag/text",sep=" "),"log",append = TRUE )
      }
      
    },error =function(e){write(paste("page",my.file,"could not be loaded",sep=" "),"log",append = TRUE )}) 
  }
  for(i in 1:4){beep(i)}
  
}



###############################################################################
##                              ALWATAN
###############################################################################

clean.alwatan<- function(source.dir){
  
  for (my.filename in dir(source.dir,full.names = TRUE, no.. = TRUE)){
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


###############################################################################
##                              HESPRESS
###############################################################################

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


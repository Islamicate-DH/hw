# Copyright Tobias Wenzel
# In Course: Islamicate World 2.0
# University of Maryland, University Leipzig
#
# File description:
#     The functions defined below are used to extract text elements of dowloaded homepages.
#     The elements are year, month, day, article and title and vary in some cases.
libs<-c("rvest","stringr","tidyr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}

###############################################################################
##                              AL-MASRY AL-YOUM
###############################################################################
f.clean.almasryalyoum <- function(source.folder) {
  # Extract the text-elements in files of a given source folder and appends them to 
  # a csv-file. The file has the same name like the source folder. 
  # Al-Masri al-Youm is special in the way they write the date i.e. in hindu-arabic
  # signs. Given the limited time, we decided to use an index and if necessary to 
  # interpolate the date.
  #
  # Args:
  #   source.folder:  A character string to set the target folder.
  article.xpath.element <- "//font[@color='#AB0202'and @size='5']//b"
  date.xpath.element <- "//font[@size='2' and @face='Tahoma']//p"
  
  i <- 1
  for (my.filename in dir(source.folder, full.names = TRUE, no.. = TRUE)) {
    tryCatch({
      article.homepage <- read_html(my.filename, encoding = "UTF-8")
      title.c <- article.homepage %>% html_nodes(
        xpath = article.xpath.element) %>% html_text()
      # date extraction see ahram
      text.c <- article.homepage %>% html_nodes(
        xpath = date.xpath.element) %>% html_text()
      
      text.c <- paste(text.c, collapse = " ")
      text.c <-sub("\"","",text.c)
      title.c <- gsub("\"","",title.c)
      
      if(nchar(text.c)>10){
      write.table(
        data.frame(i,text.c,title.c),
        col.names = FALSE,row.names = FALSE,
        file = paste(source.folder,".csv",sep=""),
        sep = "\t",fileEncoding = "UTF-8",append = T)
      i<-i+1
      }
    }, error = function(e) {
      write(paste("page", my.filename, "could not be loaded", sep = " "),
            "log",
            append = TRUE)
    })  # end of tryCatch
  }  # end of for-loop
}  # end of f.clean.almasryalyoum

###############################################################################
##                              AHRAM
###############################################################################
f.clean.ahram <- function(source.folder) {
  # Extracts text of all Ahram homepage in a given source folder. Here we save 
  # article, year, month, day optionally title. The month remains as
  # month name and is converted lateron. 
  #
  # Args:
  #   source.folder:  A character string to set the target folder.
  my.target.csv <- paste(source.folder, ".csv", sep = "")
  article.css.element <- "div#txtBody.bbBodyp"
  title.css.element <- "div#divtitle"
  date.css.element <- "td#header1_DateTD"
  
  for (my.filename in dir(source.folder, pattern = "*.aspx")) {
    tryCatch({
      ahram.homepage <-
        read_html(paste(source.folder, "/", my.filename, sep = ""), encoding = "UTF-8")
      
      text.c <- ahram.homepage %>% html_node(article.css.element) %>% html_text()

      if (nchar(text.c) > 10) {
        # if there is any text, append it to the table.
        title <- ahram.homepage %>% html_node(title.css.element) %>% html_text()
        
        my.date <- ahram.homepage %>% html_node(date.css.element) %>% html_text()
        my.date <- unlist(strsplit(my.date, " ")) # splitting the date-string into substrings
        year <- suppressWarnings(min(my.date[which(as.numeric(my.date) >= 2010)]))
        month <- my.date[which(my.date == year) - 1]
        day <- my.date[which(my.date == year) - 2]
        
        text.c <- gsub("\"", "", text.c)
        title.c <- gsub("\"", "", title)
        
        write.table(
          data.frame(year, month, day, text.c, title.c),
          col.names = FALSE, row.names = FALSE,
          my.target.csv,
          sep = ",", fileEncoding = "UTF-8", append = T
        )
      } else {
        # else write a log with a message so we can find the page
        write(paste("page", my.filename, "had no suitable tag/text", sep = " "),
              "log", append = TRUE)
      }  # end of if nchar(text.c)
    }, error = function(e) {
      write(paste("page", my.filename, "could not be loaded", sep = " "),
            "log",
            append = TRUE)
    })  # end of tryCatch
  }  # end of for-loop
}  # end of f.clean.ahram

###############################################################################
##                              ALWATAN
###############################################################################
f.clean.alwatan <- function(source.folder) {
  # Extracts text of all homepages in a given source folder of al-Watan. The files do differ
  # in their structure/tags, thus if-statements where added which check if a
  # page has a title with the corresponding tag, i.e. it exists. There are three
  # different file-structures.
  #
  # Args:
  #   source.folder:  A character string to set the target folder.
  my.taret.csv <- paste(source.folder, ".csv", sep = "")
  
  for (my.filename in dir(source.folder, full.names = TRUE, no.. = TRUE)) {
    tryCatch({
      homepage <- read_html(my.filename, encoding = "UTF-8")
      title.css.element <- "span#ctl00_ContentPlaceHolder1_lblHeading"
      title.c <- homepage %>% html_nodes(title.css.element) %>% html_text()
      if (length(title.c) != 0) {
        # if length==0, title doesn't exist, i.e. the page doesn't have the tag
        ## Homepages which have a structure like
        ## news.aspx?n=F29C6BDC-0285-4256-8BF5-9E3729766652&d=20120425
        article.css.element <- "span#ctl00_ContentPlaceHolder1_lblDescription"
        text.c <- homepage %>% html_nodes(article.css.element) %>% html_text()
        
        year <- str_sub(my.filename, -8, -5)
        month <- str_sub(my.filename, -4, -3)
        day <- str_sub(my.filename, -2, -1)
      } else {
        ## Homepages which have a structure like
        ##  /watan_news.aspx?id=2999
        title.css.element <- "span#ctl00_ContentPlaceHolder1_LatestNews1_lblHeading"
        title.c <- homepage %>% html_nodes(title.css.element) %>% html_text()
        ##  The date is not in filename. Thus we have to extract the digits.
        ##  If the title doesn't exist we can skip that.
        if (length(title.c) != 0) {
          date.css.element <- "span#ctl00_ContentPlaceHolder1_LatestNews1_lbl_date"
          article.css.element <- "span#ctl00_ContentPlaceHolder1_LatestNews1_lblDescription.NewsTickerDescription"
          
          date.c <- homepage %>% html_nodes(date.css.element) %>% html_text()
          date <- str_split(date.c,"/")
          day <- date[[1]][1]
          month <- date[[1]][2]
          year <- substr(date[[1]][3], 1, 4)
          text.c <- homepage %>% html_nodes(article.css.element) %>% html_text()
        }
      }  # end of if length title.c != 0
      if (length(text.c) != 0) {
        # again, check whether there was a title an append the new data to the csv.
        text.c <- gsub("\"", "", text.c)
        title.c <- gsub("\"", "", title.c)
        write.table(data.frame(year, month, day, text.c, title.c ),
          col.names = FALSE,  row.names = FALSE,
          file = my.taret.csv, sep = ",", fileEncoding = "UTF-8", append = T
        )
      } else {
        write(paste("page", my.filename,
                    "had no suitable tag/text", sep = " "),
              "log", append = TRUE)
      }  # end of length text.c
    }, error = function(e) {
      write(paste("page", my.filename, "could not be loaded", sep = " "), "log",  append = TRUE)
    })  # end of tryCatch
  }  # end of for-loop
}  # end of f.clean.alwatan

###############################################################################
##                              HESPRESS
###############################################################################
f.clean.hespress <- function(source.folder) {
  # Extracts text elements from HTML-files a given source folder Hespress.
  # There is only one kind of structure and all attributes can be extracted.
  #
  # Args:
  #   source.folder:  A character string to set the target folder.
  
  my.target.csv <- paste(source.folder, ".csv", sep = "")
  article.css.element <- "div#article_body p"
  title.css.element <- "h1.page_title"
  date.css.element <- "span.story_date"
  
  for (my.filename in dir(source.folder, full.names = TRUE, no.. = TRUE)) {
    tryCatch({
      article.homepage <- read_html(my.filename, encoding = "UTF-8")
      title.c <-
        article.homepage %>% html_nodes(title.css.element) %>% html_text()
      
      date.c <- article.homepage %>% html_nodes(date.css.element) %>% html_text()
      date <- str_split(date.c, " ")
      month <- date[[1]][3]
      day <- date[[1]][2]
      year <- date[[1]][4]
      
      text.c <- article.homepage %>% html_nodes(article.css.element) %>% html_text()
      
      text.c <- gsub("\"", "", text.c)
      title.c <- gsub("\"", "", title.c)
      ## since all homepages look the same I can skip the if-statements (cf. al-watan.R)
      write.table(data.frame(year, month, day, text.c, title.c),
        col.names = FALSE, row.names = FALSE,
        file = my.target.csv, sep = "\t", fileEncoding = "UTF-8",
        append = T )
    }, error = function(e) {
      write(paste("page", my.filename, "could not be loaded", sep = " "),
            "log", append = TRUE)
    })  # end of tryCatch
  }  # end of for-loop
}  # end of f.clean.hespress

###############################################################################
##                              THAWRA
###############################################################################
f.clean.thawra <- function(source.folder){
  # Extracting text elemetns of given source folder with Thawra HTML-files.
  # The files are encoded with 'Windows-1256' and are coded to UTF-8 before
  # writing to the target csv. There is only one kind of structure and all 
  # attributes can be extracted.
  # 
  # Args:
  #   source.folder:  A character string to set the target folder.
  my.target.csv <- paste(source.folder, ".csv", sep = "")
  title.xpath.element <- "//font[@color='0000C0'][@size=5]"
  article.css.element <- "font p"
  date.xpath.element <- "//p[@align='right']"
  
  
  for (my.filename in dir(source.folder,full.names = TRUE, no.. = TRUE)){
  # Files with cat in filename don't have any readable information.
    if(length(grep(pattern = "cat",my.filename, invert = TRUE)>1)){
      
      tryCatch({
        
        article.homepage<-read_html(my.filename,encoding = "Windows-1256")
        text.c <- article.homepage %>%html_nodes(article.css.element)  %>% html_text()
        text.c<-paste(text.c,collapse = " ", sep = " ")
        title.c<-article.homepage %>%html_nodes(xpath = title.xpath.element)  %>% html_text()
        
        ## works because homepage is not written very well...
        date.sec<-article.homepage %>%  html_nodes(xpath = date.xpath.element)  %>% html_text()
        date.sec<-strsplit(date.sec, " ")[[1]]
        date.sec<-date.sec[grep("-",date.sec)]  ## splitting string with date and grabbing elements
        my.date<-gsub("[^0-9||-]","",date.sec)
        my.date<-my.date[nchar(my.date)>=5]
        my.date<- strsplit(my.date,"-")[[1]]
        day<-my.date[1]
        month<-my.date[2]
        year<-my.date[3]
        
        text.c<- iconv(to="UTF-8",x = text.c)# no from
        title.c<-iconv(to="UTF-8",x = text.c)
        text.c <-sub("\"","",text.c)
        title.c <- gsub("\"","",title.c)
        
        tryCatch({
          if(nchar(text.c)>1){
            write.table(data.frame(year,month,day,text.c, title.c),
                        col.names = FALSE,row.names = FALSE,
                        file = my.target.csv,
                        sep = ",",fileEncoding = "UTF-8",append = T)
          }  # end of if nchar(text.c)
        },error =function(e){
          print(paste("page",my.filename,"could not be loaded",sep=" "))
        })  # end of (inner) tryCatch
      },error =function(e){
        write(paste("page",my.filename,"could not be loaded",sep=" "),"log",append = TRUE )
      })  # end of (outer) tryCatch
    }  # end of if cat
  }  # end of for-loop
}  # end of f.clean.thawra
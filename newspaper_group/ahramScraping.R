##                                                                        
##                            Ahram Scraper
##
## 

rm(list=ls())
#setwd("~/Dokumente/islamicate2.0/hw/newspaper_group/Aharam/2013/") # setting working directory

libs<-c("yaml","rvest","stringr","tidyr","optparse","methods","beepr")
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



###############################################################################
##                              FUNCTIONS
###############################################################################



getLinks <- function(homepage.url,link.element){
  homepage <- read_html(homepage.url)
  link.element.v<-homepage %>%
    html_nodes(link.element) %>% html_attr("href")
  homepages.v<-unlist(link.element.v)
  homepages.v<-homepages.v[homepages.v!=""]
  return(homepages.v)
}

# the result are relative links, of course. they are ordered in some kind of system 130515-130518 which has little 
# in common with the date but is ascending.

# ahram.day.homepage.v<-ahram.homepage %>%
#   html_nodes("div#TheMainTableDiv a") %>% html_attr("href") 
# homepages.v<-unlist(ahram.day.homepage.v)


# e.g. facebook,twitter-links.
filter_homepages<-function(homepages.v){
  # i should scrape everything first...
  # but that could be a way to choose...
  # these i really don't need
  
  #filtering twitter, fb etc lateron.
  ahram.url<-"http://www.ahram.org.eg/archive/news/" # articles are saved one stage down. 
  result<-c(
    # pages are saved as relative links.
   sapply(ahram.url,paste, homepages.v[grep('http|RssContent|javascript',homepages.v,invert = TRUE)], sep=""),
  # selects all subpages of ahram which are not links of archive
  homepages.v[intersect(grep('http://',homepages.v),
                 grep('ahram',homepages.v)  )]
  )
  return(result)
}

scrapeRaw<- function(day.to.observe){
  target.folder<- "~/Dokumente/islamicate2.0/hw/corpora/newspaper_archive/Aharam/2013"
  base.ahram.url<- "http://www.ahram.org.eg/archive/"
  ahram.url<-"http://www.ahram.org.eg/archive/news/" # articles are saved one stage down. 
  
  ahram.day.url<-paste(ahram.url,day.to.observe,"/index.aspx",sep="")

  homepages.rel.v<-getLinks(ahram.day.url,"a")
  homepages.v<-filter_homepages(homepages.rel.v)# also prepends http
  
  homepages.v<-homepages.v[grep("*[0-9].aspx$", homepages.v)]# i'm only interested in the articles
  
  homepages.rel.v<- gsub("/", "_", homepages.rel.v)
    for(i in 1:length(homepages.v)){
     
     # to avoid the duplicate issue. also resulting in http:__ (not very relevant)
      my.filename <- paste(target.folder, gsub("/", "_", homepages.rel.v[i]), sep = "/")
      print(my.filename)
      if(!file.exists(my.filename)){

        tryCatch({
          ahram.homepage<-read_html(homepages.v[i],encoding = "UTF-8")
          write_xml(ahram.homepage,my.filename)
          
          sleep(0.1)}
          ,error = function(e){
            write(homepages.v[i],paste(target.folder,'log',sep=""),append = TRUE)
          })

      }# end of file.exists
      else{print(paste("skip",homepages.v[i],"because i have it already.",sep=" "))}
    }# end of for-loop
} # end of scrapeRaw-function



clean.ahram<- function(dirname){
  my.filename<-paste(dirname,".csv",sep = "")
  
  for(my.file in dir(dirname,pattern = "aspx")){
    
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

#scrapeAhramDay("2007/8/1")

  ## with bash-script
#scrapeAhramDay(o$day)# causes an error.

#scrapeRaw("2013/1/1")
scrapeRaw(o$day)


#clean.ahram(dirname = "raw_2012_12_12-2016_10_31")



# might be nec. to change this.
Sys.setlocale("LC_TIME", "ar_AE.utf8");
month.dates<-seq(as.Date("2012-01-01"), as.Date("2012-12-31"), "months")
month.names<-format(month.dates, "%B")



## how to get your data (example)
# 
# days.to.load.v<-generateTimeSequence("2006-01-10","2006-1-11")
# result<-sapply(days.to.load.v,my.yaml.loader)
# result[,"2006/1/10"]
# 
# my.yaml.loader <- function(day.to.load){
#   my.filename<-paste("data/",paste(day.to.load),".yaml",sep="")
#   return(as.data.frame(yaml.load_file(my.filename)))
# }



# 
# 
# scrapeAhramDay <- function(day.to.observe){
#   base.ahram.url<- "http://www.ahram.org.eg/archive/"
#   ahram.url<-"http://www.ahram.org.eg/archive/news/" # articles are saved one stage down. 
#   
#   my.filename<-paste("data/",paste(day.to.observe),".yaml",sep="")# the data-format fits the datastructure year/month/day
#   
#   if(!file.exists(my.filename)){
#     
#     ahram.day.url<-paste(ahram.url,day.to.observe,"/index.aspx",sep="")
#     homepages.v<-getLinks(ahram.day.url,"div#ImpNewsDiv a")### div#TheMainTableDiv a
#     cat("\nNow I'm scraping all of the (top) articles written on ",day.to.observe,".\n",sep="")
#     titles.v<-NULL; abstract.v<-NULL; text.v<-NULL# initialize variables with NULL to omit overwriting of existing strings.
#     
#     for(i in 1:length(homepages.v)){
#       
#       #print(paste(base.ahram.url,homepages.v[i],sep="",collapse = ""))
#       
#       ahram.homepage <- read_html(paste(base.ahram.url,homepages.v[i],sep="",collapse = ""),encoding = "UTF-8") # encoding solves the encoding-issue
#       
#       titles.v[i]<-ahram.homepage %>% html_node("div#divtitle") %>% html_text() # get title
#       # titles.v[i]<-gsub('/r||/n','',titles.v[i])
#       abstract.v[i]<-ahram.homepage %>% html_node("div#abstractDiv") %>% html_text() #get the abstract
#       text.v[i]<-ahram.homepage %>% html_node("div#txtBody.bbBodyp") %>% html_text() # get the text
#       sleep(0.5)# ...be patient. this is going to take forever.
#       
#     }
#     
#     # @todo META-Data  # subtitle in span#txtSource.bbsubtitle
#     
#     my.df<-data.frame(rep("Ahram",length(homepages.v)),day.to.observe,titles.v,abstract.v,text.v)
#     colnames(my.df)<- c("newspaper","date","title","abstract","article")
#     
#     
#     # create dir if needed.
#     dir.create(gsub('/..yaml','',my.filename), showWarnings = FALSE, recursive = TRUE) # extracting year/month from year/month/day
#     # \r and \n still present. not a big problem, they can be removed with other stopwords.
#     write(as.yaml(my.df),my.filename) #write.table(my.df,my.filename,sep="\t",quote = FALSE)
#   } else    
#   {   warning("skip this day.")   } 
# }

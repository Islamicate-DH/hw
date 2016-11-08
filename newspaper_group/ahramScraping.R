


rm(list=ls())

## keep in mind that your structure might be different
setwd("~/Dokumente/islamicate2.0/project/") # setting working directory
#library(methods) ## is not load by Rscript ('bash-way') by default
libs<-c("yaml","rvest","stringr","tidyr","optparse","methods")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}

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


######################################################################################################
#                                           FUNCTIONS
######################################################################################################

# sleeping function as found in tafaseer_topic_group
sleep <- function(s)
{
  t0 = proc.time()
  Sys.sleep(s)
  proc.time() - t0
}

# # create a sequence of days
getDaysToObserve <- function(start,end){
  days.to.observe<-seq(as.Date(start), as.Date(end), "days")
  days.to.observe<-gsub(" 0", " ", format(days.to.observe, "%Y %m %d"))
  return(gsub(" ","/",days.to.observe))
}


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
  
  base.ahram.url<- "http://www.ahram.org.eg/archive/"
  ahram.url<-"http://www.ahram.org.eg/archive/news/" # articles are saved one stage down. 
  
  ahram.day.url<-paste(ahram.url,day.to.observe,"/index.aspx",sep="")

  homepages.rel.v<-getLinks(ahram.day.url,"a")
  homepages.v<-filter_homepages(homepages.rel.v)# also prepends http
  homepages.rel.v<- gsub("/", "_", homepages.rel.v)
    for(i in 1:length(homepages.v)){
     
     # to avoid the duplicate issue. also resulting in http:__ (not very relevant)
      my.filename<-paste("~/Downloads/ahram/nt2013/",homepages.rel.v[i],sep="")
      if(!file.exists(my.filename)){

        tryCatch({
          ahram.homepage<-read_html(homepages.v[i],encoding = "UTF-8")
          write_xml(ahram.homepage,my.filename)
          
          sleep(0.1)}
          ,error = function(e){
            write(homepages.v[i],"~/Downloads/ahram/nt2013/missed.log",append = TRUE)
          })

      }# end of file.exists
      else{print(paste("skip",homepages.v[i],"because i have it already.",sep=" "))}
    }# end of for-loop
} # end of scrapeRaw-function


## stolen from tafaseer_topic_group...
# Get Parameters passed by the bash script
option_list = list(
  make_option(
    c('-b', '--day'), 
    action='store', default=NA, type='character',
    help='Where to start downloading.')
); o = parse_args(OptionParser(option_list=option_list))




## if you're just starting the script
## this might be a better to read:
## the function is called per day.
#days.to.observe.v<-getDaysToObserve("2012-12-11","2016-10-31")
#sapply(days.to.observe.v, scrapeAhramDay)
#sapply(days.to.observe.v, scrapeRaw)

#scrapeAhramDay("2007/8/1")

  ## with bash-script
#scrapeAhramDay(o$day)# causes an error.

#scrapeRaw("2011/6/1")
scrapeRaw(o$day)
## how to get your data (example)
# 
# days.to.load.v<-getDaysToObserve("2006-01-10","2006-1-11")
# result<-sapply(days.to.load.v,my.yaml.loader)
# result[,"2006/1/10"]
# 
# my.yaml.loader <- function(day.to.load){
#   my.filename<-paste("data/",paste(day.to.load),".yaml",sep="")
#   return(as.data.frame(yaml.load_file(my.filename)))
# }


scrapeAhramDay <- function(day.to.observe){
  base.ahram.url<- "http://www.ahram.org.eg/archive/"
  ahram.url<-"http://www.ahram.org.eg/archive/news/" # articles are saved one stage down. 
  
  my.filename<-paste("data/",paste(day.to.observe),".yaml",sep="")# the data-format fits the datastructure year/month/day
  
  if(!file.exists(my.filename)){
    
    ahram.day.url<-paste(ahram.url,day.to.observe,"/index.aspx",sep="")
    homepages.v<-getLinks(ahram.day.url,"div#ImpNewsDiv a")### div#TheMainTableDiv a
    cat("\nNow I'm scraping all of the (top) articles written on ",day.to.observe,".\n",sep="")
    titles.v<-NULL; abstract.v<-NULL; text.v<-NULL# initialize variables with NULL to omit overwriting of existing strings.
    
    for(i in 1:length(homepages.v)){
      
      #print(paste(base.ahram.url,homepages.v[i],sep="",collapse = ""))
      
      ahram.homepage <- read_html(paste(base.ahram.url,homepages.v[i],sep="",collapse = ""),encoding = "UTF-8") # encoding solves the encoding-issue
      
      titles.v[i]<-ahram.homepage %>% html_node("div#divtitle") %>% html_text() # get title
      # titles.v[i]<-gsub('/r||/n','',titles.v[i])
      abstract.v[i]<-ahram.homepage %>% html_node("div#abstractDiv") %>% html_text() #get the abstract
      text.v[i]<-ahram.homepage %>% html_node("div#txtBody.bbBodyp") %>% html_text() # get the text
      sleep(0.5)# ...be patient. this is going to take forever.
      
    }
    
    # @todo META-Data  # subtitle in span#txtSource.bbsubtitle
    
    my.df<-data.frame(rep("Ahram",length(homepages.v)),day.to.observe,titles.v,abstract.v,text.v)
    colnames(my.df)<- c("newspaper","date","title","abstract","article")
    
    
    # create dir if needed.
    dir.create(gsub('/..yaml','',my.filename), showWarnings = FALSE, recursive = TRUE) # extracting year/month from year/month/day
    # \r and \n still present. not a big problem, they can be removed with other stopwords.
    write(as.yaml(my.df),my.filename) #write.table(my.df,my.filename,sep="\t",quote = FALSE)
  } else    
  {   warning("skip this day.")   } 
}




######################################################################################################
#                                           MORE Code...
######################################################################################################

## vectorised approach. 
# text.v<-sapply(homepages.v, getElementOfHomepage,my.element="div#divtitle")
# abstract.v<-sapply(homepages.v, getElementOfHomepage,my.element="div#abstractDiv")
# text.v<-sapply(homepages.v, getElementOfHomepage,my.element="div#txtBody.bbBodyp")
# getElementOfHomepage <- function(my.element){
#   hp.element<-ahram.homepage %>% html_nodes(my.element) %>% html_text() # get title
#   sleep(0.1)
#   return(hp.element)
# }


# # Scrapes homepages with a given time-range (days).
# scrapeAhram <- function(days.to.observe){
#   
#   # dotted.line<-rep("-",130)
#   # cat(dotted.line,"\n","\t\t\t\t\tWelcome to our Ahram-Scraper!","\n",dotted.line,collapse="",sep="")
#   
#   base.ahram.url<- "http://www.ahram.org.eg/archive/"
#   ahram.url<-"http://www.ahram.org.eg/archive/news/" # articles are saved one stage down. 
#   
#   
#   for(day in 1:length(days.to.observe)){
#     my.filename<-paste("data/",paste(days.to.observe[day]),".yaml",sep="")# the data-format fits the datastructure year/month/day
#     
#     if(!file.exists(my.filename)){
#       ## 
#       
#       ahram.day<-paste(ahram.url,days.to.observe[day],"/index.aspx",sep="")
#       homepages.v<-getLinksOfAhram(ahram.day)
#       sleep(0.1)# ...be patient. this is going to take forever.
#       cat("\nNow I'm scraping all of the (top) articles written on ",days.to.observe[day],".",sep="")
#       
#       titles.v<-rep("",length(homepages.v))
#       abstract.v<-rep("",length(homepages.v))
#       text.v<-rep("",length(homepages.v))
#       
#       for(i in 1:length(homepages.v)){
#         
#         
#         
#         cat("I'm currently scraping ", base.ahram.url,homepages.v[i],"\n",sep="")
#         ahram.homepage <- read_html(paste(base.ahram.url,homepages.v[i],sep="") )
#         # write(length(ahram.homepage),my.filename)
#         # result<-getHomepageContent(ahram.homepage)
#         # titles.v[i]<-result[1]
#         # abstract.v[i]<-result[2]
#         # text.v[i]<-result[2]
#         titles.v[i]<-ahram.homepage %>% html_nodes("div#divtitle") %>% html_text() # get the title
#         abstract.v[i]<-ahram.homepage %>% html_nodes("div#abstractDiv") %>% html_text() # get the abstract
#         text.v[i]<-ahram.homepage %>% html_nodes("div#txtBody.bbBodyp") %>% html_text() # get the text
#         
#         sleep(0.1)# ...be patient. this is going to take forever.
#       }
#       
#       # cat("Writing all of",days.to.observe[day],"to the corresponding file in data/year/month",sep=" ")
#       
#       # @todo META-Data
#       # subtitle in span#txtSource.bbsubtitle
#       my.df<-data.frame(rep("Ahram",length(homepages.v)),days.to.observe[day],titles.v,abstract.v,text.v)
#       colnames(my.df)<- c("newspaper","date","title","abstract","article")
#       
#       write(as.yaml(my.df),my.filename) #write.table(my.df,my.filename,sep="\t",quote = FALSE)
#       
#       sleep(2)
#     }
#     
#   }
#   print("finish.")
# }


# Returns specific text-parts of the homepage.

# #could be done like this div#TheMainTableDiv title_list.a
# getHomepageContent <- function(ahram.homepage){
#   # there might be less because some of it is written in italic below
#   # that's the subtitle
#   print("getHomepageContent")
#   my.title<-ahram.homepage %>% # load the page
#     html_nodes("div#divtitle") %>% # isloate the text
#     html_text() # get the title
#   
#   my.abstract<-ahram.homepage %>% # load the page
#     html_nodes("div#abstractDiv") %>% # isloate the text
#     html_text() # get the abstract
#   
#   my.text<-ahram.homepage %>% # load the page
#     html_nodes("div#txtBody.bbBodyp") %>% # isloate the text
#     html_text() # get the text
#   
#   return(c(my.title,my.abstract,my.text))
# }
# getLinksOfAhram <- function(ahram.day){
#   ahram.homepage <- read_html(ahram.day)
#   
#   ahram.day.homepage.v<-ahram.homepage %>%
#     html_nodes("div#ImpNewsDiv a") %>% html_attr("href")
#   homepages.v<-unlist(ahram.day.homepage.v)
#   homepages.v<-homepages.v[homepages.v!=""]
#   #homepages.v<-homepages.v[grep("comment|#",homepages.v,invert = TRUE)]## remove comments and starting #
#   
#   return(homepages.v)
# }
# 







## keep in mind that your structure might be different
setwd("~/Dokumente/islamicate2.0/project/") # setting working directory

libs<-c("yaml","rvest","stringr","tidyr","optparse")
for(i in 1:length(libs)){
suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}

######################################################################################################
#                                           NOTES
######################################################################################################

## some dependencies etc.

# install.packages('stringi', configure.args='--disable-cxx11')
# sudo apt-get install libxml2-dev
# sudo apt-get install libcurl4-openssl-dev
# install.packages("rvest") # error fixed
# install.packages("yaml")
#install.packages("optparse")

# do i have to traverse all stories on the right side or just the top stories?  
# the problem is that the top stories include articles about europe etc. too.

# i could also scrape different things like the headlines, wich might be more interesting or the middle east section
# the structure remains the same. please tell me where i should scrape- or do you really want to have everything?


## creating subfolders for months 

# end=2012
# for(year in 2005:end){
#   for(month in 1:12){
#     dir.create(file.path("data/",year,month), showWarnings = FALSE,recursive = TRUE)
#   }
# }

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
# getDaysToObserve <- function(start,end){
#   days.to.observe<-seq(as.Date(start), as.Date(end), "days")
#   days.to.observe<-gsub(" 0", " ", format(days.to.observe, "%Y %m %d"))
#   return(gsub(" ","/",days.to.observe))
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


# the result are relative links, of course. they are ordered in some kind of system 130515-130518 which has little 
# in common with the date but is ascending.

# ahram.day.homepage.v<-ahram.homepage %>%
#   html_nodes("div#TheMainTableDiv a") %>% html_attr("href") 
# homepages.v<-unlist(ahram.day.homepage.v)

getLinksOfAhram <- function(ahram.day){
  ahram.homepage <- read_html(ahram.day)

  ahram.day.homepage.v<-ahram.homepage %>%
    html_nodes("div#ImpNewsDiv a") %>% html_attr("href")
  homepages.v<-unlist(ahram.day.homepage.v)
  homepages.v<-homepages.v[homepages.v!=""]
  #homepages.v<-homepages.v[grep("comment|#",homepages.v,invert = TRUE)]## remove comments and starting #

  return(homepages.v)
}





# Scrapes Articles of one Day (in combination with bash-script)
scrapeAhramDay <- function(day.to.observe){
  
  base.ahram.url<- "http://www.ahram.org.eg/archive/"
  ahram.url<-"http://www.ahram.org.eg/archive/news/" # articles are saved one stage down. 
  my.filename<-paste("data/",paste(day.to.observe),".yaml",sep="")# the data-format fits the datastructure year/month/day

  
  if(!file.exists(my.filename)){
    
    ahram.day<-paste(ahram.url,day.to.observe,"/index.aspx",sep="")
    homepages.v<-getLinksOfAhram(ahram.day)
    
    cat("\nNow I'm scraping all of the (top) articles written on ",day.to.observe,".\n",sep="")
    
    titles.v<-NULL
    abstract.v<-NULL
    text.v<-NULL
    
    for(i in 1:length(homepages.v)){
      
      
      print(paste(base.ahram.url,homepages.v[i],sep="",collapse = ""))
      ahram.homepage <- read_html(paste(base.ahram.url,homepages.v[i],sep="",collapse = ""))
      ## HERE
      # causes an error when script is started with tmux 
      # Fehler in as.vector(x, "list") : 
      #   cannot coerce type 'environment' to vector of type 'list'
      # Ruft auf: scrapeAhramDay ... <Anonymous> -> lapply -> as.list -> as.list.default
      # Ausführung angehalten
      
      titles.v[i]<-ahram.homepage %>% html_nodes("div#divtitle") %>% html_text() # get title
      abstract.v[i]<-ahram.homepage %>% html_nodes("div#abstractDiv") %>% html_text() #get the abstract
      text.v[i]<-ahram.homepage %>% html_nodes("div#txtBody.bbBodyp") %>% html_text() # get the text
      
      sleep(0.1)# ...be patient. this is going to take forever.
    }
    
    
    # @todo META-Data
    # subtitle in span#txtSource.bbsubtitle
    my.df<-data.frame(rep("Ahram",length(homepages.v)),day.to.observe,titles.v,abstract.v,text.v)
    colnames(my.df)<- c("newspaper","date","title","abstract","article")
    
    write(as.yaml(my.df),my.filename) #write.table(my.df,my.filename,sep="\t",quote = FALSE)
    
    
  } else{
    print("something went wrong.")
  } #end of if(!file.exists(my.filename))
}

## stolen from tafaseer_topic_group...
# Get Parameters passed by the bash script

option_list = list(
  make_option(
    c('-b', '--start'), 
    action='store', default=NA, type='character',
    help='Where to start downloading.')
); o = parse_args(OptionParser(option_list=option_list))

# with bash-script

scrapeAhramDay(o$start)# causes an error.
#scrapeAhramDay('2005/1/1') # works just fine.
# if you're just starting the script
# scrapeAhram(getDaysToObserve("2005-01-01","2005-01-07"))

# how to get your data (example)
#my.yaml.ob.as.data.frame<-as.data.frame(yaml.load_file("data/2005/1/1.yaml"))







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
#       ## dir.create(days.to.observe[day], showWarnings = FALSE, recursive = TRUE) ## filename includes .yaml
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





#library(methods) ## is not load by Rscript ('bash-way') by default
libs<-c("yaml","rvest","stringr","tidyr","optparse","methods")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}
setwd("~/Dokumente/islamicate2.0/project/") # setting working directory

articles<-dir("data/2011/4/1")
rawHTML <- paste(readLines("index.aspx.5"), collapse="\n")


# better with path
ahram.homepage <- read_html(rawHTML) # encoding solves the encoding-issue
  
  titles.v<-ahram.homepage %>% html_node("div#divtitle") %>% html_text() # get title
  abstract.v<-ahram.homepage %>% html_node("div#abstractDiv") %>% html_text() #get the abstract
  text.v<-ahram.homepage %>% html_node("div#txtBody.bbBodyp") %>% html_text() # get the text
  sleep(0.5)# ...be patient. this is going to take forever.
  

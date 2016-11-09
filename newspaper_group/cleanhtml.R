#library(methods) ## is not load by Rscript ('bash-way') by default

libs<-c("yaml","rvest","stringr","tidyr","optparse","methods","beepr")
for(i in 1:length(libs)){
  suppressPackageStartupMessages(library(libs[i], character.only = TRUE))
}
setwd("~/Dokumente/islamicate2.0/project/ahram") # setting working directory

#install.packages("beepr")


# might be nec. to change this.
Sys.setlocale("LC_TIME", "ar_AE.utf8");
month.dates<-seq(as.Date("2012-01-01"), as.Date("2012-12-31"), "months")
month.names<-format(month.dates, "%B")

## da stimmt noch was nicht. muss ich jetzt alles nochmal runterladen?
## das ist nur von 12/13

dirname<-"raw_2012_12_12-2016_10_31"

clean.ahram<- function(){
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
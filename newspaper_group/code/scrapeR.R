###############################################################################
###############################################################################
##                              SCRAPE-FUNCTIONS
###############################################################################
###############################################################################


###############################################################################
##                              HESPRESS
###############################################################################

scrape.index.hespress<- function(day.links,target.folder){
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


scrape.day.hespress <- function(hespress.url) {
  target.folder<-"~/Downloads/hespress2016/" ##"~/Dokumente/islamicate2.0/hw/corpora/newspaper_archive/Hespress/hespress2015/"
  
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


###############################################################################
##                              THAWRA
###############################################################################

scrape.article.thawra <- function(homepages.day){
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

scrape.day.thawra<- function(day.homepage.url){
  
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
  
} # end of scrape.day.thawra-function

###############################################################################
##                              AHRAM
###############################################################################

scrape.day.ahram<- function(day.to.observe){
  target.folder<- "~/Downloads/ahram"
  base.ahram.url<- "http://www.ahram.org.eg/archive/"
  ahram.url<-"http://www.ahram.org.eg/archive/news/" # articles are saved one stage down. 
  
  ahram.day.url<-paste(ahram.url,day.to.observe,"/index.aspx",sep="")

  homepages.rel.v<-getLinks(ahram.day.url,"a")

  homepages.v<-filter_homepages.ahram(homepages.rel.v)# also prepends http

  homepages.v<-homepages.v[grep("*[0-9].aspx$", homepages.v)]# i'm only interested in the articles
  print(homepages.v)
  homepages.names.v<- gsub("/", "_", homepages.v)
  for(i in 1:length(homepages.v)){
    
    # to avoid the duplicate issue. also resulting in http:__ (not very relevant)
    my.filename <- paste(target.folder, gsub("/", "_", homepages.names.v[i]), sep = "/")
    #print(my.filename)
     if(!file.exists(my.filename)){
    # 
       tryCatch({
         ahram.homepage<-read_html(homepages.v[i],encoding = "UTF-8")
         write_xml(ahram.homepage,my.filename)
    # 
         sleep(0.1)}
         ,error = function(e){
           print("something went wrong while downloading.")
    #       #write(homepages.v[i],paste(target.folder,'/log',sep=""),append = TRUE)
         })
    # 
     } else{
        print(paste("skip",homepages.v[i],"because i have it already.",sep=" "))
        }# end of file.exists
  }# end of for-loop
} # end of scrapeRaw-function

# e.g. facebook,twitter-links.
filter_homepages.ahram<-function(homepages.v){
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

getLinks <- function(homepage.url,link.element){
  homepage <- read_html(homepage.url)
  link.element.v<-homepage %>%
    html_nodes(link.element) %>% html_attr("href")
  homepages.v<-unlist(link.element.v)
  homepages.v<-homepages.v[homepages.v!=""]
  return(homepages.v)
}
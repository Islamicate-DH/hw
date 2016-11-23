# sleeping function as found in tafaseer_topic_group

sleep <- function(s)
{
  t0 = proc.time()
  Sys.sleep(s)
  proc.time() - t0
}



generateTimeSequence <- function(start,end){
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


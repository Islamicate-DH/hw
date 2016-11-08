
## little help scrip which seperates
## the links at http:// - which was need because of a bug earlier.


links<-paste(scan("/home/tobias/Downloads/ahram/raw_2012_12_12-2016_10_31/links_complete", what="character", sep="\n"),collapse = "")


links<-strsplit(as.character(links),"http://",fixed = TRUE)

for (link in links){
  write(paste("http://",link,"\n",sep = ""),"/home/tobias/Downloads/ahram/raw_2012_12_12-2016_10_31/fixed",append = TRUE)
}
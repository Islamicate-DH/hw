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
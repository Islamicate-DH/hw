

setwd("~/Dokumente/islamicate2.0/project/ahram") # setting working directory



# might be nec. to change this.
Sys.setlocale("LC_TIME", "ar_AE.utf8");
month.dates<-seq(as.Date("2012-01-01"), as.Date("2012-12-31"), "months")
month.names<-format(month.dates, "%B")

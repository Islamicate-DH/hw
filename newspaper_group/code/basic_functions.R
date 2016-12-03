# Copyright Tobias Wenzel
# In Course: Islamicate World 2.0
# University of Maryland, University Leipzig
#
# File description:
#   Rudimental functions used by the scrapeR, cleanR and uriR script.

sleep <- function(s) {
  Sys.sleep(s)
}  # end of sleep

f.generateTimeSequence <- function(start, end) {
  # Generates a time sequence, i.e. a string vector with formated
  # dates.
  days.to.observe <- seq(as.Date(start), as.Date(end), "days")
  days.to.observe <-  gsub(" 0", " ", format(days.to.observe, "%Y %m %d"))
  return(gsub(" ", "/", days.to.observe))
}  # end of f.generateTimeSequence

# Used for padding (URI).
SPRINTF <- function(x) sprintf("%02d", x)

f.replaceMonthNames <- function(corpus, month.col = 2) {
  # Replaces month-names with numbers to create a URI.  
  #
  # Args:
  #   corpus: matrix with text, title and date columns
  #   month.col: column with month-name
  Sys.setlocale("LC_TIME", "ar_AE.utf8")
  
  month.dates <-
    seq(as.Date("2012-01-01"), as.Date("2012-12-31"), "months")
  month.names <- format(month.dates, "%B")
  
  for (i in 1:11) {
    corpus[which(corpus[, month.col] == month.names[i]), month.col] <- i
  }
  
  corpus[which(corpus[, month.col] == "ابريل"), month.col] <- 4
  corpus[which(corpus[, month.col] == "يوليوز"), month.col] <- 5
  corpus[which(corpus[, month.col] == "غشت"), month.col] <- 8
  corpus[which(corpus[, month.col] == "غشت"), month.col] <- 8
  corpus[which(corpus[, month.col] == "شتنبر"), month.col] <- 9
  corpus[which(corpus[, month.col] == "اكتوبر"), month.col] <- 10
  corpus[which(corpus[, month.col] == "نونبر"), month.col] <- 11
  corpus[which(corpus[, month.col] == "ديسمبر"), month.col] <- 12
  corpus[which(corpus[, month.col] == "دجنبر"), month.col] <- 12
  
  return(corpus)
}  # end of f.replaceMonthNames

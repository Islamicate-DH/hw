# Author: Tobias Wenzel
# Month/Year: 10/2016
# In course: Studying the islamicate Culture through Text Analysis 
# Description: Code snippets and exercises of Chapter 3 in 'Jockers. Text Analysis with R.'

setwd("~/Dokumente/islamicate2.0/hw/wenzel_tobias/") # setting working directory

################  FUNCTIONS   ################

# Get Meta-Data of the Book. Specify the path to the text, first and last line of the novel. 
f.getMetaData <- function(pathToText.c, firstline.c, lastline.c){
  start.metadata.v <- text.v[1:start.v -1] # everything before the novel starts
  end.metadata.v <- text.v[(end.v+1):length(text.v)] # everything after the novel
  metadata.v <- c(start.metadata.v, end.metadata.v) # combine both in one variable
}

# Get the Novel-Part of the Book. Specify the path to the text, first and last line of the novel. 
f.getNovelLines <- function(pathToText.c,firstline.c, lastline.c){
  text.v <- scan(pathToText.c, what="character", sep="\n")
  return(text.v[ which(text.v == firstline.c):which(text.v == lastline.c) ]) # and save the novel in novel.lines.v
}

# Seperate Words of a given Text (Vector)
f.sepWords <- function(novel.lines.v){
  novel.v <- paste(novel.lines.v, collapse=" ")
  novel.lower.v <- tolower(novel.v)  # convert to lowercase
  novel.words.l <- strsplit(novel.lower.v, "\\W") # splitting into words
  novel.word.v <- unlist(novel.words.l) # simplify to vector
  not.blanks.v <-  which(novel.word.v!="") # vector with all places where it's not blank
  return(novel.word.v[not.blanks.v]) # "deleting the blanks"
}

# Get a frequency-table of a given text (Vetor)
f.getFreqTable <- function(novel.word.v) {
  novel.freqs.t <- table(novel.word.v) # frequency-table
  sorted.moby.freqs.t <- sort(novel.freqs.t , decreasing=TRUE)
  return(sorted.moby.freqs.t)
}

################  END-OF: FUNCTIONS   ################

### Get information of Moby Dick and plot.
moby.lines.v <- f.getNovelLines("data/plainText/melville.txt","CHAPTER 1. Loomings.","orphan.")
moby.word.v <- f.sepWords(moby.lines.v)
sorted.moby.freqs.t <- f.getFreqTable(moby.word.v)

sorted.moby.rel.freqs.t <- 100*(sorted.moby.freqs.t/sum(sorted.moby.freqs.t))
plot(sorted.moby.rel.freqs.t[1:10], type="b",
     xlab="Top Ten Words", ylab="Percentage of Full Text (Moby)", xaxt ="n")
axis(1,1:10, labels=names(sorted.moby.rel.freqs.t [1:10]))


################  EXERCISE 3.1   ################
# Get information of SENSE AND SENSIBILITY and plot.
sense.lines.v  <- f.getNovelLines("data/plainText/austen.txt","CHAPTER 1","between themselves, or producing coolness between their husbands.")
sense.word.v <- f.sepWords(sense.lines.v)
sorted.sense.freqs.t <- f.getFreqTable(sense.word.v)

sorted.sense.rel.freqs.t <- 100*(sorted.sense.freqs.t/sum(sorted.sense.freqs.t))
plot(sorted.sense.rel.freqs.t[1:10], type="b",
     xlab="Top Ten Words", ylab="Percentage of Full Text (Sense)", xaxt ="n")
axis(1,1:10, labels=names(sorted.sense.rel.freqs.t [1:10]))


# i save the top 10 of each book to make it easier to read.
sense.topTenwords.c <- names(sorted.sense.rel.freqs.t[1:10])
moby.toTenwords.c <- names(sorted.moby.rel.freqs.t [1:10])
################  EXERCISE 3.2   ################
# all unique words in the top ten list of both books
unique(c(sense.topTenwords.c,moby.toTenwords.c))

################  EXERCISE 3.3   ################
### EXERCISE 3.3###
# words which are in sense and also in moby
sorted.sense.rel.freqs.t[which(sense.topTenwords.c %in% moby.toTenwords.c)]


################  EXERCISE 3.4   ################
# words which are in sense but not in moby
sorted.sense.rel.freqs.t[which(!(sense.topTenwords.c %in% moby.toTenwords.c))]



# Text Analysis with an arabic Text. 
################  EXERCISE 3.1   ################

startline.c <- "# البحر : متقارب تام 1"
endline.c <- "# % مضى ثلاث سنين منذ حل بها % % و عام حلت وهذا التابع الخامي % %"
arab01.lines.v <- f.getNovelLines("arabicCorpus/up0600AH/0001HarithIbnHilliza.Diwan.JK007504-ara1", startline.c, endline.c)
arab01.word.v <- f.sepWords(arab01.lines.v)
# ^ meaning it starts with...
arab01.word.v <- arab01.word.v[grep("[^a-zA-Z0-9]",arab01.word.v)] # no numbers and page-count (letters)

sorted.arab01.freqs.t <- f.getFreqTable(arab01.word.v)
sorted.arab01.rel.freqs.t <- 100*(sorted.arab01.freqs.t/sum(sorted.arab01.freqs.t))

plot(sorted.arab01.rel.freqs.t[1:10], type="b",
     xlab="Top Ten Words", ylab="Percentage of Full Text (arab)", xaxt ="n")
axis(1,1:10, labels=names(sorted.arab01.rel.freqs.t [1:10]))


# yet another arabic book, which i will use to compare against the first.
startline.c <- "# جزء فيه أحاديث الليث PageV01P001"
endline.c <- "~~أبغضتكم PageV01P056"
arab02.lines.v <- f.getNovelLines("arabicCorpus/up0600AH/0175LaythIbnSacd.MajlisMinFawaid.JK000863-ara1", startline.c, endline.c)
arab02.word.v <- f.sepWords(arab02.lines.v)
arab02.word.v <- arab02.word.v[grep("[^a-zA-Z0-9]",arab02.word.v)] 
sorted.arab02.freqs.t <- f.getFreqTable(arab02.word.v)
sorted.arab02.rel.freqs.t <- 100*(sorted.arab02.freqs.t/sum(sorted.arab02.freqs.t))
# plot(sorted.arab02.rel.freqs.t[1:10], type="b",
#      xlab="Top Ten Words", ylab="Percentage of Full Text (arabic)", xaxt ="n")
# axis(1,1:10, labels=names(sorted.arab02.rel.freqs.t [1:10]))


arab01.toTenwords.c <- names(sorted.arab01.rel.freqs.t [1:10])
arab02.toTenwords.c <- names(sorted.arab02.rel.freqs.t [1:10])

################  EXERCISE 3.2   ################
# all unique words in the top ten list of both books
unique(c(arab01.toTenwords.c,arab02.toTenwords.c))

################  EXERCISE 3.3   ################
### EXERCISE 3.3###
# words which are in 2nd and also in 1st book
sorted.arab02.freqs.t[which(arab02.toTenwords.c %in% arab01.toTenwords.c)]

################  EXERCISE 3.4   ################
# words which are in 2nd but not in 1st book
sorted.arab02.freqs.t[which(!(sorted.arab02.freqs.t %in% sorted.arab01.freqs.t))]



# text.v <- scan("data/plainText/melville.txt", what="character", sep="\n")
# start.v <- which(text.v == "CHAPTER 1. Loomings.")
# end.v <- which(text.v == "orphan.") 
# start.metadata.v <- text.v[1:start.v -1] # everything before the novel starts
# end.metadata.v <- text.v[(end.v+1):length(text.v)] # everything after the novel
# metadata.v <- c(start.metadata.v, end.metadata.v) # combine both in one variable
# novel.lines.v <- text.v[start.v:end.v] # and save the novel in novel.lines.v
# novel.v <- paste(novel.lines.v, collapse=" ")
# # convert to lowercase
# novel.lower.v <- tolower(novel.v)
# moby.words.l <- strsplit(novel.lower.v, "\\W") # splitting into words
# moby.word.v <- unlist(moby.words.l) # simplify to vector
# not.blanks.v <-  which(moby.word.v!="") # vector with all places where it's not blank
# moby.word.v <-moby.word.v[not.blanks.v] # "deleting the blanks"
# moby.freqs.t <- table(moby.word.v) # frequency-table 
# sorted.moby.freqs.t <- sort(moby.freqs.t , decreasing=TRUE)

# sorted.moby.freqs.t["he"]
# sorted.moby.freqs.t["she"]
# sorted.moby.freqs.t["him"]
# sorted.moby.freqs.t["her"]
# sorted.moby.freqs.t["him"]/sorted.moby.freqs.t["her"]
# sorted.moby.freqs.t["he"]/sorted.moby.freqs.t["she"]
# length(moby.word.v)
# sorted.moby.rel.freqs.t <- 100*(sorted.moby.freqs.t/sum(sorted.moby.freqs.t))
# sorted.moby.rel.freqs.t["the"]
# plot(sorted.moby.rel.freqs.t[1:10], type="b",
#      xlab="Top Ten Words", ylab="Percentage of Full Text A", xaxt ="n")
# axis(1,1:10, labels=names(sorted.moby.rel.freqs.t [1:10]))

# # EXERCISE 3.1
# text.v <- scan("data/plainText/austen.txt", what="character", sep="\n")
# start.v <- which(text.v == "CHAPTER 1")
# end.v <- which(text.v == "between themselves, or producing coolness between their husbands.")
# start.metadata.v <- text.v[1:start.v -1] # everything before the novel starts
# end.metadata.v <- text.v[(end.v+1):length(text.v)] # everything after the novel
# metadata.v <- c(start.metadata.v, end.metadata.v) # combine both in one variable
# novel.lines.v <- text.v[start.v:end.v] # and save the novel in novel.lines.v
# novel.v <- paste(novel.lines.v, collapse=" ")
# # convert to lowercase
# novel.lower.v <- tolower(novel.v)
# sense.words.l <- strsplit(novel.lower.v, "\\W") # splitting into words
# sense.word.v <- unlist(sense.words.l) # simplify to vector
# not.blanks.v <-  which(sense.word.v!="") # vector with all places where it's not blank
# sense.word.v <-sense.word.v[not.blanks.v] # "deleting the blanks"
# sense.freqs.t <- table(sense.word.v) # frequency-table 
# sorted.sense.freqs.t <- sort(sense.freqs.t , decreasing=TRUE)


# sorted.sense.rel.freqs.t <- 100*(sorted.sense.freqs.t/sum(sorted.sense.freqs.t))
# plot(sorted.sense.rel.freqs.t[1:10], type="b",
#      xlab="Top Ten Words", ylab="Percentage of Full Text B", xaxt ="n")
# axis(1,1:10, labels=names(sorted.sense.rel.freqs.t [1:10]))





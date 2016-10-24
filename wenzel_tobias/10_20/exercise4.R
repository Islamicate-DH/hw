# Author: Tobias Wenzel
# Month/Year: 10/2016
# In course: Studying the islamicate Culture through Text Analysis 
# Description: Code snippets and exercises of Chapter 4 in 'Jockers. Text Analysis with R.'

setwd("~/Dokumente/islamicate2.0/TextAnalysisWithR/") # setting working directory


################  FUNCTIONS   ################

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

################  END-OF: FUNCTIONS   ################

moby.lines.v <- f.getNovelLines("data/plainText/melville.txt","CHAPTER 1. Loomings.","orphan.")
moby.word.v <- f.sepWords(moby.lines.v)
n.time.v <- seq(1:length(moby.word.v))
word.c <- "whales"
whales.v <- which(moby.word.v == word.c) # all pos. of whale in moby
w.count.v <- rep(NA,length(n.time.v))
w.count.v[whales.v] <- 1 # cool.
plot(w.count.v, main="Dispersion Plot of given word in Moby Dick",
     xlab="Novel Time", ylab=word.c, type="h", ylim=c(0,1), yaxt='n')

# rm(list = ls())# remove all obj.
# ls()# list all objects

novel.lines.v <- f.getNovelLines("data/plainText/melville.txt","CHAPTER 1. Loomings.","orphan.")
# ^ ~start with CHAPTER and Number
chap.positions.v <- grep("^CHAPTER \\d", novel.lines.v)
# novel.lines.v[chap.positions.v]

novel.lines.v <- c(novel.lines.v, "END") # adds END
last.position.v <- length(novel.lines.v)
chap.positions.v <- c(chap.positions.v , last.position.v)

# for(i in 1:length(chap.positions.v)){
#   print(chap.positions.v[i]) 
# }

# for(i in 1:length(chap.positions.v)){
#   print(paste("Chapter ",i, " begins at position ",
#               chap.positions.v[i]), sep="")
# }


chapter.raws.l <- list()
chapter.freqs.l <- list()

for(i in 1:length(chap.positions.v)){
  # because last field holds END
  if(i != length(chap.positions.v)){
    chapter.title <- novel.lines.v[chap.positions.v[i]]
    start <- chap.positions.v[i]+1
    end <- chap.positions.v[i+1]-1
    chapter.lines.v <- novel.lines.v[start:end]
    
    # chapter.words.v <- tolower(paste(chapter.lines.v, collapse=" "))
    # chapter.words.l <- strsplit(chapter.words.v, "\\W")
    # chapter.word.v <- unlist(chapter.words.l)
    chapter.word.v <-f.sepWords(chapter.lines.v) # chapter.word.v[which(chapter.word.v!="")]
    
    chapter.freqs.t <- table(chapter.word.v)
    chapter.raws.l[[chapter.title]] <- chapter.freqs.t
    chapter.freqs.t.rel <- 100*(chapter.freqs.t/sum(chapter.freqs.t))
    chapter.freqs.l[[chapter.title]] <- chapter.freqs.t.rel
  }
}

# x<-  list(a = 1:10, b = 2:25, b=100:1090)
# lapply(x, mean)
 # chapter.freqs.l[[2]]["whale"]
 # lapply(chapter.freqs.l, '[', 'whale')
 # chapter.freqs.l[[1]]["whale"]
# x<-list(1:3,4:6,7:9)
# do.call(rbind,x) # convert to 3x3 matrix
whale.l<- lapply(chapter.freqs.l,'[','whale')
# do.call() applies a function to a given object

whales.m <- do.call(rbind, whale.l) # bind freq for whale

ahab.l <- lapply(chapter.freqs.l, '[', 'ahab') # get word freq of chap with index ahab
ahabs.m <- do.call(rbind, ahab.l) # bind the rows into a matrix
whales.v <- whales.m[,1] # Select first col
ahabs.v <- ahabs.m[,1]
# since both resulting tables have the same row-count, we glue the cols together
whales.ahabs.m <- cbind(whales.v, ahabs.v)
# dim(whales.ahabs.m)
colnames(whales.ahabs.m) <- c("whale", "ahab")
barplot(whales.ahabs.m, beside=T, col="grey")

################  EXERCISE 4.1   ################
# Plot of three different words: whale, ahab and queequeg
#queequeg

queequeg.l <- lapply(chapter.freqs.l, '[', 'queequeg')
queequeg.m <- do.call(rbind, queequeg.l)
queequeg.v <- queequeg.m[,1]
whales.ahabs.queequeg.m <- cbind(whales.v, ahabs.v, queequeg.v)
colnames(whales.ahabs.queequeg.m) <- c("whale", "ahab","queequeg")
barplot(whales.ahabs.queequeg.m, beside=T, col="grey")

################  EXERCISE 4.2   ################
# plot of whale's and ahab's raw freq
whale.raw.l<-lapply(chapter.raws.l, '[', 'whale')
whales.raw.m <- do.call(rbind, whale.raw.l)

ahab.raw.l <- lapply(chapter.raws.l, '[', 'ahab')
ahabs.raw.m <- do.call(rbind, ahab.raw.l)

whales.raw.v <- whales.raw.m[,1]
ahabs.raw.v <- ahabs.raw.m[,1]
whales.ahabs.raw.m <- cbind(whales.raw.v, ahabs.raw.v)

colnames(whales.ahabs.raw.m) <- c("whale", "ahab")
barplot(whales.ahabs.raw.m, beside=T, col="grey")

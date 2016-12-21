setwd("~/Documents/TextAnalysisWithR")
text.v <- scan("data/plainText/melville.txt", what="character", sep="\n")
text.v
text.v[1]
start.v <- which(text.v == "CHAPTER 1. Loomings.")
end.v <- which(text.v == "orphan.")
start.v
end.v
length(text.v)
start.metadata.v <- text.v[1:start.v -1]
end.metadata.v <- text.v[(end.v+1):length(text.v)]
metadata.v <- c(start.metadata.v, end.metadata.v)
novel.lines.v <- text.v[start.v:end.v]
text.v[start.v]
text.v[start.v-1]
text.v[end.v]
text.v[end.v+1]
length(text.v)
length(novel.lines.v)
novel.v <- paste(novel.lines.v, collapse=" ")
length(novel.v)
novel.v[1]
novel.lower.v <- tolower(novel.v)
moby.words.l <- strsplit(novel.lower.v, "\\W")
class(novel.lower.v)
class(moby.words.l)  
str(moby.words.l)
moby.word.v <- unlist(moby.words.l)
not.blanks.v <- which(moby.word.v!="")
not.blanks.v
not.blanks.v[1:10]
moby.word.v <- moby.word.v[not.blanks.v]
moby.word.v
moby.word.v[1:10]
moby.word.v[99986]
moby.word.v[4:6]
moby.word.v[c(4,5,6)]
which(moby.word.v=="whale")
moby.word.v[which(moby.word.v=="whale")]
length(moby.word.v[which(moby.word.v=="whale")])
length(moby.word.v)
whale.hits.v <- length(moby.word.v[which(moby.word.v=="whale")])
total.words.v <- length(moby.word.v)
whale.hits.v/total.words.v
length(unique(moby.word.v))
moby.freqs.t <- table(moby.word.v)
sorted.moby.freqs.t <- sort(moby.freqs.t , decreasing=TRUE)
sorted.moby.freqs.t
moby.word.v

sorted.moby.freqs.t <- sort(moby.freqs.t , decreasing=TRUE)
sorted.moby.freqs.t
tenmostmentioned.v <- sorted.moby.freqs.t [1:10]
tenmostmentioned.v
?plot
mynums.v <- c(1:10)
plot(mynums.v)
plot(tenmostmentioned.v)

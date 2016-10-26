# AYSHA KHAN / JOCKERS 2

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

novel.v <- paste(novel.lines.v, collapse=" ")
length(novel.v)

novel.lower.v <- tolower(novel.v)
moby.words.1 <- strsplit(novel.lower.v, "\\W")

class(novel.lower.v)
class(moby.words.1)
str(moby.words.1)
moby.word.v <- unlist(moby.words.1)

not.blanks.v <- which(moby.word.v!="")
not.blanks.v[1:10]
moby.word.v <- moby.word.v[not.blanks.v]
moby.word.v[1:10]

which(moby.word.v=="whale")
moby.word.v[which(moby.word.v=="whale")]

length(moby.word.v[which(moby.word.v=="whale")])
length(moby.word.v)

# count of occurrences of whale into whale.hits.v
whale.hits.v <- length(moby.word.v[which(moby.word.v=="whale")])
# count of total words into total.words.v
total.words.v <- length(moby.word.v)
# divide
whale.hits.v/total.words.v

length(unique(moby.word.v))
moby.freqs.t <- table(moby.word.v)
sorted.moby.freqs.t <- sort(moby.freqs.t , decreasing=TRUE)


# PRACTICE

mynums.v <- sorted.moby.freqs.t[1:10]
plot(mynums.v)
setwd("~/Documents/TextAnalysisWithR")
text.v <- scan("data/plainText/melville.txt", what="character", sep="\n")
start.v <- which(text.v == "CHAPTER 1. Loomings.")
end.v <- which(text.v == "orphan.")
length(text.v)
# [1] 18874
start.metadata.v <- text.v[1:start.v -1]
end.metadata.v <- text.v[(end.v+1):length(text.v)]
metadata.v <- c(start.metadata.v, end.metadata.v)
novel.lines.v <-  text.v[start.v:end.v]
novel.v <- paste(novel.lines.v, collapse=" ")
novel.lower <- tolower(novel.v)
moby.words.1 <- strsplit(novel.lower, "\\W")
moby.word.v <- unlist(moby.words.1)
not.blanks.v <- which(moby.word.v !="")
moby.word.v <- moby.word.v[not.blanks.v]
which(moby.word.v == "whale")
length(moby.word.v[which(moby.word.v=="whale")])
# [1] 1150
length(moby.word.v)
# [1] 214889
whale.hits.v <- length(moby.word.v[which(moby.word.v == "whale")])
total.words.v <- length(moby.word.v)
whale.hits.v / total.words.v
# [1] 0.005316
length(unique(moby.word.v))
# [1] 16872
moby.freqs.t <- table(moby.word.v)
sorted.moby.freqs.t <- sort(moby.freqs.t, decreasing =TRUE)
top.ten.moby.freqs.t <- sorted.moby.freqs.t[1:10]
plot(top.ten.moby.freqs.t)
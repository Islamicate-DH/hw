text.v <- scan("R/TextAnalysisWithR/data/plainText/melville.txt", what="character", sep="\n")
start.v <- which(text.v == "CHAPTER 1. Loomings.")
end.v <- which(text.v == "orphan.")
start.metadata.v <- text.v[1:start.v -1]
end.metadata.v <- text.v[(end.v+1):length(text.v)]
metadata.v <- c(start.metadata.v, end.metadata.v)
novel.lines.v <- text.v[start.v:end.v]
novel.v <- paste(novel.lines.v, collapse=" ")
novel.lower.v <- tolower(novel.v)
moby.words.l <- strsplit(novel.lower.v, "\\W")
moby.word.v <- unlist(moby.words.l)
not.blanks.v <- which(moby.word.v!="")
moby.word.v <- moby.word.v[not.blanks.v]
whale.hits.v <- length(moby.word.v[which(moby.word.v=="whale")])
total.words.v <- length(moby.word.v)
moby.freqs.t <- table(moby.word.v)
sorted.moby.freqs.t <- sort(moby.freqs.t , decreasing=T)
sorted.moby.rel.freqs.t <- 100*(sorted.moby.freqs.t/sum(sorted.moby.freqs.t))
plot(sorted.moby.rel.freqs.t[1:10], type="b", xlab="Top Ten Words", ylab="Percentage of Full Text", xaxt="n")
most.freq.words.v <- c("to", "the", "of", "and", "her", "i", "in", "a", "was", "it", "his", "that")
text.v <- scan("R/TextAnalysisWithR/data/plainText/austen.txt", what="character", sep="\n")
start.v <- which(text.v=="CHAPTER 1")
end.v <- which(text.v=="THE END")
start.meta.v <- text.v[1:start.v -1]
end.meta.v <- text.v[(end.v+1) :length(text.v)]
metadata.v <- c(start.meta.v, end.meta.v)
novel.lines.v <- text.v[start.v:end.v]
novel.v <- paste(novel.lines.v, collapse=" ")
novel.lower.v <- tolower(novel.v)
austen.words.l <- strsplit(novel.lower.v, "\\W")
austen.word.v <- unlist(austen.words.l)
not.blanks.v <- austen.word.v[which(austen.word.v!="")]
austen.freqs.t <- table(not.blanks.v)
sorted.austen.freqs.t <- sort(austen.freqs.t, decreasing=TRUE)
most.freq.v <- sorted.austen.freqs.t[1:10]
plot(most.freq.v, xlab="Words", ylab="Total Frequency in the Book")
sorted.austen.rel.freqs.t <- 100*(sorted.austen.freqs.t/sum(sorted.austen.freqs.t))
rel.most.freq.v <- sorted.austen.rel.freqs.t[1:10]
plot(rel.most.freq.v, type="b", xlab="Top Ten Words", ylab="Percentage of Full Text", xaxt ="n")
axis(1,1:10, labels=names(sorted.austen.rel.freqs.t [1:10]))
most.freq.words.v <- c("to", "the", "of", "and", "her", "i", "in", "a", "was", "it", "his", "that")
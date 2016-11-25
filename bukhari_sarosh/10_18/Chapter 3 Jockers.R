text.v <- scan("data/plainText/austen.txt", what="character", sep="\n") 
start.v <- which(text.v == "CHAPTER 1")
end.v <- which(text.v == "THE END")
start.metadata.v <- text.v[1:start.v -1]
end.metadata.v <- text.v[(end.v+1):length(text.v)]
metadata.v <- c(start.metadata.v, end.metadata.v) 
novel.lines.v <- text.v[start.v:end.v]
novel.v <- paste(novel.lines.v, collapse=" ")
novel.lower.v <- tolower(novel.v)
sense.words.l <- strsplit(novel.lower.v, "\\W")
sense.word.v <- unlist(sense.words.l)
not.blanks.v <- which(sense.word.v!="")
sense.word.v <- sense.word.v[not.blanks.v]
sense.freqs.t <- table(sense.word.v)
sorted.senes.freqs.t <- sort(sense.freqs.t , decreasing=T)
sorted.sense.rel.freqs.t <- 100 * 
(sorted.sense.freqs.t/sum(sorted.sense.freqs.t))
plot(sorted.sense.rel.freqs.t[1:10], 
     main="Sense and Sensibility", type="b",
     xlab="Top Ten Words", ylab="Percentage",xaxt = "n") 
axis(1,1:10, labels=names(sorted.sense.rel.freqs.t[1:10]))

# AYSHA KHAN / JOCKERS 3


# 3.1
sorted.moby.freqs.t <- 100*(sorted.moby.freqs.t/sum(sorted.moby.freqs.t))
plot(sorted.moby.rel.freqs.t[1:10],
     main="Moby Dick",
     type="b",
     xlab="Top Ten Words",
     ylab = "Percentage",
     xaxt="n")
axis(1,1:10, labels=names(sorted.moby.freqs.t[1:10]))

text.v <- scan("data/plaintext/austen.txt", what="character", sep="\n")
start.v <- which(text.v == "CHAPTER 1")
end.v <- which(text.v == "THE END")
novel.lines.v <- text.v[start.v:end.v]
novel.v <- paste(novel.lines.v, collapse=" ")
novel.lower.v <- tolower(novel.v)
sense.words.1 <- strsplit(novel.lower.v, "\\W")
sense.word.v <- unlist(sense.words.1)
not.blanks.v <- which(sense.word.v!="")
sense.word.v <- sense.word.v[not.blanks.v]
sense.freqts.t <- table(sense.word.v)
sorted.sense.freqs.t <- sort(sense.freqts.t, decreasing=TRUE)
sorted.sense.freqs.t <- 100*(sorted.sense.freqs.t/sum(sorted.sense.freqs.t))
plot(sorted.sense.freqs.t[1:10],
     main="Sense and Sensibility",
     type="b",
     xlab="Top Ten Words",
     ylab = "Percentage",
     xaxt="n")
axis(1,1:10, labels=names(sorted.sense.freqs.t[1:10]))

#3.2
top.ten.sense.moby.freq.t <- c(names(sorted.sense.rel.freqs.t[1:10]), names(sorted.moby.rel.freqs.t[1:10]))
unique(top.ten.sense.moby.freq.t)

#3.3
names(sorted.sense.rel.freqs.t[which(names(sorted.sense.rel.freqs.t[1:10]) %in% names(sorted.moby.rel.freqs.t[1:10]))])

#3.4
only.sense <- which(names(sorted.sense.rel.freqs.t[1:10]) %in% names(sorted.moby.rel.freqs.t[1:10]))
names(sorted.sense.rel.freqs.t[1:10])[-only.sense]

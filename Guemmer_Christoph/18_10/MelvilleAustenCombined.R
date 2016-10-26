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
unique(sorted.austen.freqs.t[most.freq.words.v])
unique(sorted.moby.freqs.t[most.freq.words.v])
austen.top.ten.v <- c("to", "the", "of", "and", "her", "a", "i", "in", "was", "it")
moby.top.ten.v <- c("the", "of", "and", "a", "to", "in", "that", "it", "his", "i")
same.v <- austen.top.ten[which(austen.top.ten%in%moby.top.ten)]
same.v

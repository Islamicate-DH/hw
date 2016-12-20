
## Chapter 2 Jockers
setwd("/Users/PrayingEmoji/Documents/TextAnalysisWithR/")
moby.word.v <- scan("data/plainText/melville.txt", what="character", sep="\n")
moby.freqs.t <- table(moby.word.v)
sorted.moby.freqs.t <- sort(moby.freqs.t , decreasing=TRUE)
plot(sorted.moby.freqs.t[1:10], type="b",
     xlab="Top Ten Words", ylab="Word Count",xaxt = "n")
axis(1,1:10, labels=names(sorted.moby.freqs.t[1:10]))


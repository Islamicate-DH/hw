setwd("C:/Users/Thomas/Downloads/TextAnalysisWithR/TextAnalysisWithR")

text.v <- scan("data/plaintext/melville.txt", what="character", sep="\n")

start.v <- which(text.v == "CHAPTER 1. Loomings.")
end.v <- which(text.v == "orphan.")

novel.lines.v <- text.v[start.v:end.v]

novel.v <- paste(novel.lines.v, collapse=" ")

novel.lower.v <- tolower(novel.v)

moby.words.1 <- strsplit(novel.lower.v, "\\W")

moby.word.v <- unlist(moby.words.1)

not.blanks.v <- which(moby.word.v!="")

moby.word.v <- moby.word.v[not.blanks.v]

moby.freqts.t <- table(moby.word.v)

sorted.moby.freqs.t <- sort(moby.freqts.t, decreasing=TRUE)

sorted.moby.freqs.t[1:10]

plot(sorted.moby.freqs.t[1:10])
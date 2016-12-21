n.time.v <- seq(1:length(moby.word.v))
whales.v <- which(moby.word.v == "whale")
w.count.v <- rep(NA, length(n.time.v))
w.count.v[whales.v] <- 1
plot(w.count.v, main = "Dispersion plot of 'whale' in Moby Dick", xlab = "Novel Time", ylab = "whale", type = "h", ylim = c(0,1), yaxt='n')
ahabs.v <- which(moby.word.v == "ahab")
a.count.v <- rep(NA, length(n.time.v))
a.count.v[ahabs.v] <- 1
plot(a.count.v, main = "Dispersion plot of 'ahab' in Moby Dick", xlab = "Novel Time", ylab = "whale", type = "h", ylim = c(0,1), yaxt='n')
rm(list = ls())
text.v <- scan("data/plainText/melville.txt", what="character", sep="\n")
start.v <- which(text.v == "CHAPTER 1. Loomings.")
end.v <- which(text.v == "orphan.")
novel.lines.v <-  text.v[start.v:end.v]
chapter.positions.v <- grep("^CHAPTER \\d", novel.lines.v)
novel.lines.v[chapter.positions.v]
novel.lines.v <- c(novel.lines.v, "END")
last.position.v <- length(novel.lines.v)
chapter.positions.v <- c(chapter.positions.v, last.position.v)
for (i in 1:length(chapter.positions.v)) {
  print(chapter.positions.v[i])
}
for (i in 1:length(chapter.positions.v)) {
  print(paste("Chapter ", i, " begins at position ", chapter.positions.v[i], sep=""))
}
chapter.raws.1 <- list()
chapter.freqs.1 <- list()
for (i in 1:length(chapter.positions.v)) {
  if (i != length(chapter.positions.v)) {
    chapter.title <- novel.lines.v[chapter.positions.v[i]]
    start <- chapter.positions.v[i]+1
    end <- chapter.positions.v[i+1]-1
    chapter.lines.v <- novel.lines.v[start:end]
    chapter.words.v <- tolower(paste(chapter.lines.v, collapse = " "))
    chapter.words.1 <- strsplit(chapter.words.v, "\\W")
    chapter.word.v <- unlist(chapter.words.1)
    chapter.word.v <- chapter.word.v[which(chapter.word.v != "")]
    chapter.freqs.t <- table(chapter.word.v)
    chapter.raws.1[[chapter.title]] <- chapter.freqs.t
    chapter.freqs.t.rel <- 100 * (chapter.freqs.t/sum(chapter.freqs.t))
    chapter.freqs.1[[chapter.title]] <- chapter.freqs.t.rel
  }
}
x <- c(1,2,3,4,5)
y <- c(6,7,8,9,10)
rbind(x,y)
lapply(chapter.freqs.1, '[', 'whale')
whale.1 <- lapply(chapter.freqs.1, '[', 'whale')
rbind(whale.1[[1]], whale.1[[2]], whale.1[[3]])
whales.m <- do.call(rbind, whale.1)
ahab.1 <- lapply(chapter.freqs.1, '[', 'ahab')
ahabs.m <- do.call(rbind, ahab.1)
whales.v <- whales.m[,1]
ahabs.v <- ahabs.m[,1]
whales.ahabs.m <-cbind(whales.v, ahabs.v)
colnames(whales.ahabs.m) <- c("whale", "ahab")
barplot(whales.ahabs.m, beside = T, col = "grey")

#4.1
queequeg.1 <- lapply(chapter.freqs.1, '[', 'queequeg')
queequegs.m <- do.call(rbind, queequeg.1)
queequegs.v <- queequegs.m[,1]
whales.ahabs.queequegs.m <- cbind(whales.v, ahabs.v, queequegs.v)
colnames(whales.ahabs.queequegs.m) <- c("whale", "ahab", "queequeg")
barplot(whales.ahabs.queequegs.m, beside = T, col = "grey")

#4.2
whale.raw <- lapply(chapter.raws.1, '[', 'whale')
whale.raw.m <- do.call(rbind, whale.raw)
whale.raw.v <- whale.raw.m[,1]
ahab.raw <- lapply(chapter.raws.1, '[', 'ahab')
ahab.raw.m <- do.call(rbind, ahab.raw)
ahab.raw.v <- ahab.raw.m[,1]
whales.ahabs.raw.m <- cbind(whale.raw.v, ahab.raw.v)
colnames(whales.ahabs.raw.m) <- c("whale", "ahab")
barplot(whales.ahabs.raw.m, beside = T, col = "grey")

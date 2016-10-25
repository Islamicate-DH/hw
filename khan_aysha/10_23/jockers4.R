n.time.v <- seq(1:length(moby.word.v))
whales.v <- which(moby.word.v == "whale")
w.count.v <- rep(NA, length(n.time.v))
w.count.v[whales.v] <- 1

plot(w.count.v, main="Dispersion Plot of 'whale' in Moby Dick", 
     xlab="Novel Time", ylab="Whale", type="h", ylim=c(0,1), yaxt='n')

ahabs.v <- which(moby.word.v == "ahab")
a.count.v <- rep(NA, length(n.time.v))
a.count.v[ahabs.v] <- 1
plot(a.count.v, main="Disperion Plot of 'ahab' in Moby Dick",
     xlab="Novel Time", ylab="ahab", type="h", ylim=c(0,1), yaxt= 'n')
rm(list = ls())

text.v <- scan("melville.txt", what="character", sep="\n")

start.v <- which(text.v == "CHAPTER 1. Loomings.")

end.v <- which(text.v == "orphan.")

novel.lines.v <- text.v[start.v:end.v]

chap.positions.v <- grep("^CHAPTER \\d", novel.lines.v)

novel.lines.v <- c(novel.lines.v, "END")
last.position.v <- length(novel.lines.v)

chap.positions.v <- c(chap.positions.v, last.position.v)

for(i in 1:length(chap.positions.v)) {
  print(chap.positions.v[i])
}

for(i in 1:length(chap.positions.v)) {
  print(paste("Chapter ", i, "begins at position ",
              chap.positions.v[i]), sep="")
}
chapter.raws.l <- list()
chapter.freqs.l <- list()

for(i in 1:length(chap.positions.v)){
  if(i != length(chap.positions.v)){
    chapter.title <- novel.lines.v[chap.positions.v[i]]
    start <- chap.positions.v[i]+1
    end <- chap.positions.v[i+1]-1
    chapter.lines.v <- novel.lines.v[start:end]
    chapter.words.v <- tolower(paste(chapter.lines.v, collapse= " "))
    chapter.words.l <- strsplit(chapter.words.v, "\\W")
    chapter.word.v <- unlist(chapter.words.l)
    chapter.word.v <- chapter.word.v[which(chapter.word.v!="")]
    chapter.freqs.t <- table(chapter.word.v)
    chapter.raws.l[[chapter.title]] <- chapter.freqs.t
    chapter.freqs.t.rel <- 100*(chapter.freqs.t/sum(chapter.freqs.t))
    chapter.freqs.l[[chapter.title]] <- chapter.freqs.t.rel
  }
}

x <- c(1,2,3,4,5)
y <- c(6,7,8,9,10)
rbind(x,y)
y <- c(6,7,8,9,10,11)

x <- list( a = 1:10, b = 2:25, b=100:1090)

lapply(x, mean)

whale.l <- lapply(chapter.freqs.l, '[', 'whale')

rbind(whale.l[[1]], whale.l[[2]], whale.l[[3]])

x <- list(1:3,4:6,7:9)

do.call(rbind,x)

whales.m <- do.call(rbind, whale.l)
lapply(chapter.freqs.l, '[', 'whale')
ahab.l <- lapply(chapter.freqs.l, '[', 'ahab')
ahabs.m <- do.call(rbind, ahab.l)
whales.v <- whales.m[,1]
ahabs.v <- ahabs.m[,1]
whales.ahabs.m <- cbind(whales.v, ahabs.v)
colnames(whales.ahabs.m) <- c("whale", "ahab")
barplot(whales.ahabs.m, beside=T, col="turquoise")
queequeg.l <- lapply(chapter.freqs.l, '[', 'queequeg')
queequeg.m <- do.call(rbind, queequeg.l)
queequeg.v <- queequeg.m
que.ahab.whale <- cbind(whales.v, ahabs.v, queequeg.v)
colnames(que.ahab.whale) <- c("whale", "ahab", "queequeg")
barplot(que.ahab.whale, beside=T, col="salmon")

chapter.raws.l[[1]]["whale"]
whale.raw.l <- lapply(chapter.raws.l, '[', 'whale')
ahabs.raw.l <- lapply(chapter.raws.l, '[', 'ahab')
queequeg.raw.l <- lapply(chapter.raws.l, '[', 'queequeg')
whale.raw.m <- do.call(rbind, whale.raw.l)
ahabs.raw.m <- do.call(rbind, ahabs.raw.l)
queequeg.raw.m <- do.call(rbind, queequeg.raw.l)


#4.2
whale.raw.v <- whale.raw.m[,1]
ahabs.raw.v <- ahabs.raw.m[,1]
queequeg.raw.v <- queequeg.raw.m[,1]
raw.comparison.moby <- cbind(whale.raw.v, ahabs.raw.v, queequeg.raw.v)
colnames(raw.comparison.moby) <- c("Whale", "Ahab", "Queequeg")
barplot(raw.comparison.moby, beside=T, col="seagreen")
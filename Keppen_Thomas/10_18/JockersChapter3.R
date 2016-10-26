sorted.moby.freqs.t["he"]

sorted.moby.freqs.t["she"]

sorted.moby.freqs.t["him"]/sorted.moby.freqs.t["her"]

sorted.moby.freqs.t["he"]/sorted.moby.freqs.t["she"]

sorted.moby.rel.freqs.t <-100*(sorted.moby.freqs.t/sum(sorted.moby.freqs.t))

sorted.moby.rel.freqs.t["the"]

plot(sorted.moby.rel.freqs.t[1:10], type="b",
     xlab="Top Ten Words", ylab="Percentage of Full Text", xaxt="n")
axis(1,1:10, labels=names(sorted.moby.rel.freqs.t [1:10]))

scan.austen <- scan("plainText/austen.txt", what="character", sep="\n")

start.austen <- which(scanned.austen == "CHAPTER 1")

end.austen <- which(scanned.austen == "THE END")

austen.lines <- scanned.austen[start.austen:end.austen]

austen.collapse <- paste(austen.lines, collapse=" ")

austen.lower <- tolower(austen.collapse)

austen.words.1 <- strsplit(austen.lower, "\\W")

austen.words <- unlist(austen.words.1)

notblank.austen <- which(austen.words!="")

austen.words <- austen.words[notblank.austen]

austen.freqs <- table(austen.words)

sorted.austen.freqs <- sort(austen.freqs, decreasing=TRUE)

rel.sorted.austen.freqs <- 100*(sorted.austen.freqs/sum(sorted.austen.freqs))

plot(rel.sorted.austen.freqs[1:10], type="b",
     xlab="Top Ten Words-Austen", ylab="Percentage of Full Text", xaxt="n")
axis(1,1:10, labels=names(sorted.moby.rel.freqs.t [1:10]))

combined.words <-c(names((sorted.austen.freqs[1:10])),names(sorted.moby.freqs.t[1:10]))

unique(combined.words)

names(sorted.austen.freqs[
  which(names(sorted.austen.freqs[1:10])
        %in% names(sorted.moby.rel.freqs.t[1:10]))])

names(sorted.austen.freqs[
  which(!names(sorted.austen.freqs[1:10])
        %in% names(sorted.moby.rel.freqs.t[1:10]))])

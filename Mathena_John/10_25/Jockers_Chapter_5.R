whales.ahabs.m[which(is.na(whales.ahabs.m))] <- 0
cor(whales.ahabs.m)
mycor <- cor(whales.ahabs.m[,"whale"], whales.ahabs.m[,"ahab"])
cor.data.df <- as.data.frame(whales.ahabs.m)
sample(cor.data.df$whale)
cor(sample(cor.data.df$whale), cor.data.df$ahab)
mycors.v <- NULL
for(i in 1:10000){
  mycors.v <- c(mycors.v, cor(sample(cor.data.df$whale), cor.data.df$ahab))
}
min(mycors.v)
max(mycors.v)
range(mycors.v)
mean(mycors.v)
sd(mycors.v)

#5.1
i.l <- lapply(chapter.freqs.l, '[', 'i')
i.m <- do.call(rbind, i.l)
my.l <- lapply(chapter.freqs.l, '[', 'my')
my.m <- do.call(rbind, my.l)
i.v <- as.vector(i.m[,1])
my.v <- as.vector(my.m[,1])
whales.ahabs.i.my.m <- cbind(whales.v, ahabs.v, i.v, my.v)
whales.ahabs.i.my.m[which(is.na(whales.ahabs.i.my.m))] <- 0
cor(whales.ahabs.i.my.m)

#5.2
my.i.m <- cbind(i.v, my.v)
my.i.m[which(is.na(my.i.m))] <- 0
cor(my.i.m)
my.i.m.corr.data.df <- as.data.frame(my.i.m)
sample(my.i.m.corr.data.df$my)
cor(sample(my.i.m.corr.data.df$my), my.i.m.corr.data.df$i)
mycors2.v <- NULL
for(i in 1:10000){
  mycors2.v <- c(mycors2.v, cor(sample(my.i.m.corr.data.df$my), my.i.m.corr.data.df$i))
}
min(mycors2.v)
max(mycors2.v)
range(mycors2.v)
mean(mycors2.v)
sd(mycors2.v)
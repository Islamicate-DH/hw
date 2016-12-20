whales.ahabs.m[which(is.na(whales.ahabs.m))] <- 0

cor(whales.ahabs.m)

mycor <- cor(whales.ahabs.m[,"whale"], whales.ahabs.m[,"ahab"])

cor.data.df <- as.data.frame(whales.ahabs.m)

sample(cor.data.df$whale)

cor(sample(cor.data.df$whale), cor.data.df$ahab)

mycors.v <- NULL

for(i in 1:10000){
  mycors.v <- c(mycors.v, cor(sample(cor.data.df$whale),cor.data.df$ahab))
}

min(mycors.v)

max(mycors.v)

range(mycors.v)

sd(mycors.v)

mean(mycors.v)

h <- hist(mycors.v, breaks=100, col="grey",
          xlab="Correlation Coefficient",
          main="Histogram of Rand Correction Coefficients\n with Normal Curve",
          plot=T)
xfit <- seq(min(mycors.v), max(mycors.v), length=1000)
yfit <- dnorm(xfit, mean=mean(mycors.v), sd=sd(mycors.v))
yfit <- yfit*diff(h$mids[1:2])*length(mycors.v)
lines(xfit, yfit, col="black", lwd=2)

my.l <- lapply(chapter.freqs.l, '[', 'my')

i.l <- lapply(chapter.freqs.l, '[', 'i')

my.m <- do.call(rbind, my.l)

i.m <- do.call(rbind, i.l)

my.v <- as.vector(my.m[,1])

i.v <- as.vector(i.m[,1])

whales.ahabs.my.i <- c(whales.ahabs.m, my.v, i.v)

whales.ahabs.my.i[which(is.na(whales.ahabs.my.i))] <- 0

whales.ahabs.data.frame <- as.data.frame(whales.ahabs.my.i)


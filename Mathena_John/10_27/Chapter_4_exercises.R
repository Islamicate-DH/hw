#Problem 51
plot(iris$Sepal.Length, iris$Petal.Length)

#Problem 52
species <- c("setosa", "virginica", "versicolor")
colvals <- c("red", "green", "blue")
cols <- colvals[match(iris$Species, species)]
plot(iris$Sepal.Length, iris$Petal.Length, col = cols)

#Problem 53
species <- c("setosa", "virginica", "versicolor")
colvals <- c("red", "green", "blue")
cols <- colvals[match(iris$Species, species)]
plot(iris$Sepal.Length, iris$Petal.Length, col = cols, cex = quantile(iris$Sepal.Width, probs = 0.5))

#Problem 54
species <- c("setosa", "virginica", "versicolor")
colvals <- c("red", "green", "blue")
cols <- colvals[match(iris$Species, species)]
plot(iris$Sepal.Length, iris$Petal.Length, col = cols)
text(iris$Sepal.Length, iris$Petal.Length,labels=iris$Species, col = cols)

#Problem 55
plot(iris$Sepal.Length, iris$Petal.Length)
abline(v=quantile(iris$Sepal.Length, prob=0.5), lty="dashed")
abline(h=quantile(iris$Petal.Length, prob=0.5), lty="dashed")

#Problem 56
species <- c("setosa", "virginica", "versicolor")
colvals <- c("red", "green", "blue")
cols <- colvals[match(iris$Species, species)]
plot(iris$Sepal.Length, iris$Petal.Length, col = cols)
pvals <- tapply(iris$Petal.Length, iris$Species, quantile, probs=0.5)
abline(h=pvals, col = cols, lty="dashed")
svals<- tapply(iris$Sepal.Length, iris$Species, quantile, probs=0.5)
abline(v=svals, col = cols, lty="dashed")

#Problem 57
species <- c("setosa", "virginica", "versicolor")
colvals <- c("red", "green", "blue")
cols <- colvals[match(iris$Species, species)]
plot(iris$Sepal.Length, iris$Petal.Length, col = cols)
hvals <- tapply(iris$Sepal.Length, iris$Species, quantile,probs=0.5)
vvals <- tapply(iris$Petal.Length, iris$Species, quantile,probs=0.5)
text(hvals, vvals, labels = species, cex = 1.0)

#Problem 58
plot(iris$Petal.Length, iris$Sepal.Width)
group <- rep(2, nrow(iris))
group[iris$Petal.Length < 2] = 1
group[iris$Petal.Length < 2 & iris$Sepal.Width < 2.75] = 3

par(mfrow=c(1, 2))
colvals <- c("red", "green", "blue")
plot(iris$Petal.Length, iris$Sepal.Width, col = colvals[group])
plot(iris$Petal.Length, iris$Sepal.Length, col = colvals[group])

#Problem 59
par(mfrow=c(4, 4))
par(mar = c(1,1,1,1))
par(oma = c(2,2,2,2))
for (i in 1:4) {
  for (j in 1:4) {
    plot(iris[,i], iris[,j], cex = 0.75)
  }
}

#Problem 60
par(mfrow=c(4, 4))
par(mar = c(1,1,1,1))
par(oma = c(2,2,2,2))
for (i in 1:4) {
  for (j in 1:4) {
   if (iris[,i] != iris[,j]) plot(iris[,i], iris[,j], cex = 0.75)
   if (iris[,i] == iris[,j]) hist(iris[,i], main="")
  }
}

#Problem 61
plot(InsectSprays$count, col ="white")
lines(InsectSprays$count)

#Problem 62
plot(InsectSprays$count, col ="white")
lines(InsectSprays$count)
points(InsectSprays$count[1:10], col ="black", pch=20)

#Problem 63
plot(InsectSprays$count, col ="white")
for (i in 1:nrow(InsectSprays)) {
  count = InsectSprays$count[i]
  if (count > 0) points(rep(i, count), 1:count, pch=20)
}

#Problem 64
plot(InsectSprays$count, col ="white")
for (i in 1:nrow(InsectSprays)) {
  count = InsectSprays$count[i]
  spray = InsectSprays$spray[i]
  if (count > 0) text(rep(i, count), 1:count, spray)
}

#Problem 65
plot(InsectSprays$count, col ="white")
for (i in 1:nrow(InsectSprays)) {
  count = InsectSprays$count[i]
  spray = InsectSprays$spray[i]
  if (count > 0) text(rep(i, count), 1:count, spray)
}
vbars = seq(0.5, 72.5, by=12)
abline(v=vbars)

#Problem 66
plot(floor(InsectSprays$count/3), col ="white")
for (i in 1:nrow(InsectSprays)) {
  count = floor(InsectSprays$count/3)[i]
  spray = InsectSprays$spray[i]
  if (count > 0) points(rep(i, count), 1:count, pch=20)
}

#Problem 67
plot(floor(InsectSprays$count/3), col ="white")
for (i in 1:nrow(InsectSprays)) {
  count = floor(InsectSprays$count/3)[i]
  spray = InsectSprays$spray[i]
  if (count > 0) points(rep(i, count), 1:count, pch=20)
  frac = (InsectSprays$count/3)[i] - floor(InsectSprays$count/3)[i]
  points(i, count+1, pch = 20, cex = frac)
}

#Problem 68
ap <- matrix(as.numeric(AirPassengers), ncol=12)
rownames(ap) <- month.abb
colnames(ap) <- 1949:1960
tot.flyers.year <- apply(ap, 2, sum)
tot.flyers.month <- apply(ap, 1, sum)

#Problem 69
plot(1:12, ap[,1], col = "black", main = "1949")
axis(1, at=1:12, rownames(ap))
lines(1:12, ap[,1])

#Problem 70
plot(1:12, ap[,1], col = "black", axes=FALSE, ylim=range(ap))
axis(1, at=1:12, rownames(ap))
for (i in 1:nrow(ap)) {
  lines(1:12, ap[,i])
}
text(rep(7,12), ap[7,], colnames(ap), cex=1.0)

#Problem 71
plot(ap[,1], ap[,2], pch=20, ylim = c(95, 185))
text(ap[,1], ap[,2]+3, rownames(ap))

#Problem 72
scaledAP <- ap
for (i in 1:12) {
  scaledAP [,i] <- 100 *scaledAP[,i] / sum(scaledAP[,i])
}

#Problem 73
plot(1:12, scaledAP[,1], col = "black", ylim=range(scaledAP))
axis(1, at=1:12, rownames(scaledAP))
for (i in 1:nrow(scaledAP)) {
  lines(1:12, scaledAP[,i])
}
text(rep(7,12), scaledAP[7,], colnames(scaledAP), cex=0.5)

#Problem 74
plot(0,0, xlim=c(1,12), ylim=c(1,12), col="black", axes=FALSE, main="", xlab=FALSE, ylab = FALSE)
box()
axis(1, at=1:12, colnames(ap), las=2)
axis(2, at=1:12, rownames(ap), las=2)
for (i in 1:12) {
  points(rep(i, 12), 1:12, cex = ap[,i] / mean(ap), pch =20)
}

#Problem 75
plot(0,0, xlim=c(1,12), ylim=c(1,12), col="black", axes=FALSE, main="", xlab=FALSE, ylab = FALSE)
box()
axis(1, at=1:12, colnames(scaledAP), las=2)
axis(2, at=1:12, rownames(scaledAP), las=2)

cols = matrix("blue", nrow = 12, ncol =12)
cols[scaledAP > 100/12] <- "red"
for (i in 1:12) {
  points(rep(i, 12), 1:12, cex = scaledAP[,i] / mean(scaledAP), pch =20, col = cols[,i])
}

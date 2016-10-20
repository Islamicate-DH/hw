#Problem 26
cent_species <- table(round(iris$Sepal.Length), iris$Species)

#Problem 27
cent_species <- table(round(iris$Sepal.Length / 2), iris$Species)

#Problem 28
sepal.hist <- hist(iris$Sepal.Length)

#Problem 29
sepal.hist <- hist(iris$Sepal.Length, breaks=seq(4, 8, by=.25), xlab="Sepal Length", ylab="Frequency")

#Problem 30
par(mfrow=c(1, 3))
hist(iris$Sepal.Length[iris$Species == "setosa"],
     breaks=seq(4, 8, by=.25),
     xlab = "Sepal Length",
     ylab = "count",
     main = "Sepal Length Setosa")
hist(iris$Sepal.Length[iris$Species == "versicolor"],
     breaks=seq(4, 8, by=.25),
     xlab = "Sepal Length",
     ylab = "count",
     main = "Sepal Length Versicolor")
hist(iris$Sepal.Length[iris$Species == "Virginica"],
     breaks=seq(4, 8, by=.25),
     xlab = "Sepal Length",
     ylab = "count",
     main = "Sepal Length Virginica")

#Problem 31
ans31 <- quantile(iris$Petal.Length,prob=(0:10)/10)

#Problem 32
top30 <- quantile(iris$Petal.Length, prob = 0.7)
ans32 <- table(iris$Species, (iris$Petal.Length > top30) == TRUE)

#Problem 33
breaks <- quantile(iris$Petal.Length, prob= (0:10)/10, names = FALSE)
bin <- cut(iris$Petal.Length, breaks, labels = FALSE, include.lowest = TRUE)
ans33 <- table(iris$Species, bin)

#Problem 34
Pedal.Area <- iris$Petal.Length * iris$Petal.Width
breaks.area <- quantile(Pedal.Area, prob = (0:10)/10)
bin.area <- cut(Pedal.Area, breaks.area, labels = FALSE, include.lowest = TRUE)
breaks.length <- quantile(iris$Petal.Length, probs = (0:10)/10)
bin.length <- cut(iris$Petal.Length, breaks.length, labels = FALSE, include.lowest = TRUE)
ans34 <- table(bin.length, bin.area)

#Problem 35
ans35.1 <- quantile(iris$Petal.Length[iris$Species == "setosa"], probs = 0.5)
ans35.2 <- quantile(iris$Petal.Length[iris$Species == "verisicolor"], probs = 0.5)
ans35.3 <- quantile(iris$Petal.Length[iris$Species == "virginica"], probs = 0.5)
ans35 <- c(ans35.1, ans35.2, ans35.3)
names(ans35) <- c("setosa", "versicolor", "virginica")
#setosa versicolor  virginica 
#1.50       4.35       5.55

#Problem 36
species = unique(iris$Species)
ans36 <- rep(0, length=3)
for (j in ans36) {
  ans36[j] <- quantile(iris$Petal.Length[iris$Species == species[j]], probs = 0.5)
}
names(ans36) <- c("setosa", "versicolor", "virginica")
# setosa versicolor  virginica 
#1.50       4.35       5.55

#Problem 37
ans37 <- tapply(iris$Petal.Length, iris$Species, quantile, probs = 0.5)
# setosa versicolor  virginica 
#1.50       4.35       5.55

#Problem 38
ask <- function() {
  for (i in 1:3) {
    abb <- readline("enter state abbreviation here: ")
    ans <- state.name[(abb == state.abb)]
    if (length(ans) == 0) ans = "Error"
    return(ans)
  }
}
ask()

#Problem 39
ask <- function() {
  for (i in 1:100) {
    abb <- readline("enter state abbreviation here: ")
    abb <- toupper(abb)
    ans <- state.name[(abb == state.abb)]
    if (length(ans) == 0) break
    return(ans)
  }
}
ask()

#Problem 40
ask <- function() {
  for (i in 1:100) {
    abb <- readline("enter state abbreviation here: ")
    abb <- toupper(abb)
    ans <- state.name[(abb == state.abb)]
    if (length(ans) == 0) ans == "Try again"
    return(ans)
  }
}
ask()

#Problem 41
for (i in 1:100) { 
  print(sum(1/1:i))
}

#Problem 42
ans42 <- cumsum(1/1:100)

#Problem 43
ask <- function() {
  num <- readline("In what year were you born?: ")
  num <- as.numeric(num)
  age <- 2016 - num
  for (i in 1:age) {
    print(paste(i, 2015-age+i))
  }
}
ask()

#Problem 44
sprays <- unique(InsectSprays$spray)
par(mfrow=c(2,3))
for (i in 1:length(sprays)) {
  hist(InsectSprays$count, breaks = seq(0, 30, by=1.0))
}
#Problem 45
sprays <- unique(InsectSprays$spray)
par(mfrow=c(2,3))
for (i in 1:length(sprays)) {
  hist(InsectSprays$count, breaks = seq(0, 30, by=1.0))
  box()
  text(20, 25, paste(sprays[i]))
}

#Problem 46
ans46 <- quantile(InsectSprays$count, probs = 0.5)
#50% 
#7

#Problem 47
ans47 <- rep(1, nrow(WorldPhones))
for (i in 1:nrow(WorldPhones)) {
  ans47[i] <- sum(WorldPhones[i, ])
}

#Problem 48
ans48 <- apply(WorldPhones, 1, sum)
#1951   1956   1957   1958   1959   1960   1961 
#74494 102199 110001 118399 124801 133709 141700

#Problem 49
ans49 <- 100 * sum(WorldPhones[ ,2]) / sum(apply(WorldPhones, 1, sum))
#[1] 29.85261

#Problem 50
ans50 <- 100 * WorldPhones / apply(WorldPhones, 1, sum)


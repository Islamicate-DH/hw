##Chapter 3 Arnold 
#25
table <- iris
table(round(iris$Sepal.Length), iris$Species)
setosa versicolor virginica
4      5          0         0
5     40          6         1
6      5         36        27
7      0          8        16
8      0          0         6
#26
iTable <- table(round(iris$Sepal.Length)/2, iris$Species)
 iTable
setosa versicolor virginica
2        5          0         0
2.5     40          6         1
3        5         36        27
3.5      0          8        16
4        0          0         6
#28
iHistogram <- hist(iris$Sepal.Length)
#29
hist(iris$Sepal.Length, breaks = 30, xlab =  "Length", ylab = "Count", mainTitle = "Sepal iris Distribution" )
#30
Steosa <- hist(iris$Sepal.Length[iris$Species == "setosa"], breaks=30, xlab ="Length", ylab="Count", mainTitle="Sepal Length: setosa") 

versicolor <- hist(iris$Sepal.Length[iris$Species == "versicolor"], breaks=30, xTitle="Sepal Length", yTitle="Count", mainTile="Sepal Length for: ersicolor") 

virginica <- hist(iris$Sepal.Length[iris$Species == "virginica"], breaks=30, xTitle="Sepal Length", yTitle ="Count", main="Sepal Length: virginica")
#31
quantile(iris$Petal.Length,prob=(0:10)/10)
0%  10%  20%  30%  40%  50%  60%  70%  80%  90% 100% 
1.00 1.40 1.50 1.70 3.90 4.35 4.64 5.00 5.32 5.80 6.90 
#32
Top30 <- quantile(iris$Petal.Length, prob=(0.7) )
T30table <- table(iris$Species, (Top30 > iris$Petal.Length))
#33
Breaks <- quantile(iris$Petal.Length, prob=((0:10)/10), names=FALSE)
bin <- cut(iris$Petal.Length, Breaks, labels=FALSE,include.lowest=TRUE)
ans <- table(iris$Species, bin)
#34
area <- (iris$Petal.Length * iris$Petal.Width)
Breaks <- quantile(iris$Petal.Length, prob=((0:10)/10), names=FALSE)
binL<- cut(iris$Petal.Length, Breaks, labels = FALSE, include.lowest=TRUE)
breaks <- quantile(area, prob=((0:10)/10), names=FALSE)
binA<- cut(area, breaks, labels = FALSE, include.lowest=TRUE)
table(binL, binA)
#35
setosa <- quantile(iris$Petal.Length[iris$Species == "setosa"], probs=0.5) 
versicolor <- quantile(iris$Petal.Length[iris$Species == "versicolor"], probs=0.5) 
virginca <- quantile(iris$Petal.Length[iris$Species == "virginica"], probs=0.5) 
vector <- c(setosa, versicolor, virginica)
names(vector) <- c("setosa", "versicolor", "virginica")
#36
species <- unique(iris$Species) 
for (i in 1:3) { 
  Species[1:3] <- quantile(iris$Petal.Length[iris$Species == species[i]], probs=0.5) 
} 
names(Species) <- c("setosa", "versicolor", "virginica")

#37

tapply(iris$Petal.Length, iris$Species, quantile, probs=0.5)

#38
ask <- function() 
  for(i in 1:3)
    state <- (readline("Enter a state abbreviation: "))
  state<-toupper(state)
  x<- state.name[state == state.abb]
  if(length(x) <=0 )
    x <- Error 
    return(x)
  
#39
  ask <- function() 
    for(i in 1:1000)
      state <- (readline("Enter a state abbreviation: "))
    state<-toupper(state)
    x<- state.name[state == state.abb]
    if(length(x) <=0 ){
      break;
      return(x)
    } 
    
#40

    ask <- function() 
      for(i in 1:1000)
        state <- (readline("Enter a state abbreviation: "))
      state<-toupper(state)
      x<- state.name[state == state.abb]
      if(length(x) !=0 ){
        break;
      } 
      return(x);
    
#41
    for(i in 1:100)
      sum<- sum(1/ 1:i)
      print(sum)
      
#42
    answer <- cumsum(1 / (1:100))
    print(answer)
#43
    ask <- function() {
      birthyear <- readline("birth year: ") 
      birthyear <- as.numeric(year) 
      age <- 2016- birthyear
      for (i in 1:age) {
        print("You were", i, "in", 2016- (age+i) )r
      } 
      
    }
#44
    x<- unique(InsectSprays$spray) 
    par(mfrow=c(2,3)) 
    for (j in 1:length(x)) { 
      hist(InsectSprays$count, breaks=30)
    }
#45
    x<- unique(InsectSprays$spray)
    par(mfrow=c(2,3))
    par(mar=c(0,0,0,0))
    for (j in 1:length(sprays)) {
      hist(InsectSprays$count, breaks=30,
           axes=FALSE)
      box() 
      text(20,25,paste("Spray=’",x[j],"’",sep=""))
    }
#46
    Median <- tapply(InsectSprays$count, InsectSprays$spray,
                     quantile, probs=0.5)
#47
    x<- rep(NA, nrow(WorldPhones))
    for (i in 1:nrow(WorldPhones)) {
      x[i] = sum(WorldPhones[i,])
    }
#48
    x <- apply(WorldPhones, 1, sum)
#49
    x<- 100 * WorldPhones[,2] / apply(WorldPhones, 1, sum)
#50
    X <- 100 * WorldPhones / apply(WorldPhones, 1, sum)






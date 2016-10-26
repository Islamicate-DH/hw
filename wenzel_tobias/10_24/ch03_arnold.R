# Author: Tobias Wenzel
# Month/Year: 10/2016
# In course: Studying the islamicate Culture through Text Analysis 
# Description: Code snippets and exercises of Chapter 3 in 'arnold_humanities'


# setwd("/home/tobias/Dokumente/islamicate2.0/arnold_humanities/ch03_05/")
# geodf <- read.csv("data/ch03/geodf.csv", as.is=TRUE)
# geodf[1:6,]
# tab <- table(geodf$county) # table country as col-title, counts the tracts
# tab[order(tab, decreasing=TRUE)]
# names(tab)[order(tab,decreasing=TRUE)][1:5] # 5 highest countries
# table(geodf$county,geodf$csa)
# ppPerHH <- geodf$population / geodf$households
# hist(ppPerHH)
# hist(ppPerHH[ppPerHH < 5])
# hist(ppPerHH[ppPerHH < 5], breaks=30)
# hist(ppPerHH[ppPerHH < 5], breaks=(13:47) / 10) # 1.3-4.7
# 
# hist(ppPerHH[ppPerHH < 5], breaks=30,
#      col="gray",
#      xlab="People per Household",
#      ylab="Count",main="Household Size by Census Tract - Oregon")
# 
# meansOfCommute <- read.csv("data/ch03/meansOfCommute.csv",
#                            as.is=TRUE)
# meansOfCommute <- as.matrix(meansOfCommute)
# walkPerc<-meansOfCommute[,"walk"]/ meansOfCommute[,"total"]
# walkPerc = round(walkPerc * 100)
# quantile(walkPerc)
# carPerc <- meansOfCommute[,"car"] / meansOfCommute[,"total"]
# carPerc <- round(carPerc * 100)
# quantile(carPerc)
# quantile(walkPerc, prob=(0:10)/10)
# cent <- quantile(walkPerc,prob=seq(0,1,length.out=100),
#                  names=FALSE)
# coff <- quantile(carPerc, prob=0.10)
# lowCarUsageFlag <- (carPerc < coff)
# table(lowCarUsageFlag, geodf$csa)
# 
# # BINS
# 
# breakPoints <- quantile(carPerc, prob=seq(0,1,length.out=11),
#                         names=FALSE)
# bin <- cut(carPerc, breakPoints,labels=FALSE, include.lowest=TRUE)
# table(bin)
# table(bin, geodf$csa)
# 
# bins <- cut(ppPerHH[ppPerHH < 5], breaks=seq(1.3,4.7,by=0.1),
#             labels=FALSE, include.lowest=TRUE)
# table(bins)
# hist(carPerc, breaks=breakPoints)
# 
# hhIncome <- read.csv("data/ch03/hhIncome.csv",as.is=TRUE,
#                      check.names=FALSE)
# hhIncome <- as.matrix(hhIncome)
# hhIncome[1:5,]
# oneRow <- hhIncome[1,-1]
# cumsum(oneRow)
# cumIncome <- matrix(0, ncol=ncol(hhIncome)-1, nrow=nrow(hhIncome))
# for (j in 1:nrow(hhIncome)) {
#     cumIncome[j,] <- cumsum(hhIncome[j,-1]) / hhIncome[j,1]
#     cumIncome[j,] <- round(cumIncome[j,] * 100)
# }
# colnames(cumIncome) <- colnames(hhIncome)[-1]
# 
# # 3.7 Combining Plots
# par(mfrow=c(4,4))
# for(j in 1:16) {
#   hist(hhIncome[,j+1] / hhIncome[,1],
#        breaks=seq(0,0.7,by=0.05), ylim=c(0,600))
# }
# 
# bands <- colnames(hhIncome)[-1]
# bandNames <- paste(bands[-length(bands)],"-",bands[-1], sep="")
# bandNames <- c(bandNames, "200k+")
# 
# par(mfrow=c(4,4))
# par(mar=c(0,0,0,0))
# # some x are not counted...
# for(j in 1:16) {
#   hist(cumIncome[,j], breaks=seq(0,1,length.out=20),axes=FALSE,
#        main="",xlab="",ylab="", ylim=c(0,600), col="grey")
#   box()
#   text(x=0.33,y=500, label=paste("Income band:", bandNames[j]))
# }
# # 3.8 Aggregation
# csaSet <- unique(geodf$csa)
# popTotal <- rep(0, length(csaSet))
# names(popTotal) <- csaSet
# 
# for (j in 1:nrow(geodf)) {
#   index <- match(geodf$csa[j], csaSet)
#   popTotal[index] <- popTotal[index] + geodf$population[j]
# }
# popTotal
# 
# csaSet <- unique(geodf$csa)
# wahTotal <- rep(0, length(csaSet))
# wahTotal/ popTotal
# apply(meansOfCommute[1:10,-1],MARGIN=1,FUN=sum) # margin~rows
# apply(meansOfCommute,2,sum)

################  EXERCISE 26   ################
table(round(iris$Sepal.Length),iris$Species)
################  EXERCISE 27   ################
#table(round(iris$Sepal.Length,0.5),iris$Species)
table(round(iris$Sepal.Length*2)/2, iris$Species)
################  EXERCISE 28   ################
hist(iris$Sepal.Length,breaks = 30)
################  EXERCISE 29   ################
hist(iris$Sepal.Length,breaks = seq(1,8,by=0.5),main="The Iris Dataset",xlab = "Sepal Length",ylab = "Frequency")
################  EXERCISE 30  #################

manseq=seq(1,8,by=0.5)
par(mfrow=c(1,3))
hist(iris$Sepal.Length[iris$Species=="setosa"],breaks =manseq,main = "setosa",xlab = "Sepal Length",ylab = "Freq.")
hist(iris$Sepal.Length[iris$Species=="versicolor"],breaks =manseq,main = "versicolor",xlab = "Sepal Length",ylab = "Freq.")
hist(iris$Sepal.Length[iris$Species=="virginica"],breaks =manseq,main = "virginica",xlab = "Sepal Length",ylab = "Freq.")
    

################  EXERCISE 31  #################
quantile(iris$Petal.Length, prob=(0:10)/10)
################  EXERCISE 32  #################
lowPetalLength <- quantile(iris$Petal.Length,probs = 0.7) # everything below 0.7
table(iris$Species, lowPetalLength > iris$Petal.Length)
# setosa and versicolor have both a petal length with is higher than 70% of the data, virginica is almost always below
################  EXERCISE 33  #################

breakPoints <- quantile(iris$Petal.Length, prob=seq(0,1,length.out=11),
                        names=FALSE)
bin <- cut(iris$Petal.Length, breakPoints,labels=FALSE, include.lowest=TRUE)
table(bin, iris$Species)

################  EXERCISE 34  #################

breakPoints <- quantile(iris$Petal.Length, prob=seq(0,1,length.out=11),
                        names=FALSE)
length.bin <- cut(iris$Petal.Length, breakPoints,labels=FALSE, include.lowest=TRUE)

petal.area <- iris$Petal.Length * iris$Petal.Width
breakPoints <- quantile(petal.area, prob=seq(0,1,length.out=11),
                        names=FALSE)
area.bin <- cut(petal.area, breakPoints,labels=FALSE, include.lowest=TRUE)
table(area.bin, length.bin)

################  EXERCISE 35  #################
ans.v<-rep(0,3)
ans.v[1]<-quantile(iris$Petal.Length[iris$Species=="setosa"],probs = 0.5)
ans.v[2]<-quantile(iris$Petal.Length[iris$Species=="versicolor"],probs = 0.5)
ans.v[3]<-quantile(iris$Petal.Length[iris$Species=="virginica"],probs = 0.5)
names(ans.v)<-c("setosa","versicolor","virginica")

################  EXERCISE 36  #################

no.species <- length(unique(iris$Species))
ans.v<-rep(0,length=no.species)
spec<- unique(iris$Species)
for(i in 1:no.species){
  ans.v[i] <- quantile(iris$Petal.Length[iris$Species == spec[i]],
                       probs=0.5)#quantile(iris$Petal.Length[iris$Species == spec[i]],probs = 0.5)
}
names(ans.v)<-c("setosa","versicolor","virginica")

################  EXERCISE 37  #################
# wow.
tapply(iris$Petal.Length, iris$Species, quantile, probs=0.5)

# 38. As in a previous question, write a function which asks the user for a state
# abbreviation and returns the state name. However, this time, put the question
# in a for loop so the user can decode three straight state abbreviations.

for(i in 1:3){
  abbr <- readline('Enter a state abbreviation.')
  print(state.name[tolower(state.abb)==tolower(abbr)])
}

# 39. The command break immediately exits a for loop; it is often used inside
# of an if statement. Redo the previous question, but break out of the loop
# when a non-matching abbreviation is given. You can increase the number of
# iterations to something large (say, 100), as a user can always get out of the
# function by giving a non-abbreviation.

for(i in 1:100){
  abbr <- readline('Enter a state abbreviation.')
  
  if(length(state.name[tolower(state.abb)==tolower(abbr)])>0){
    print(state.name[tolower(state.abb)==tolower(abbr)])
  }else{
    print("exit loop.")
    break
  }
}

# 40. Now, reverse the process so that the function returns when an abbreviation is
# found but asks again if it is not.

f.ex40 <- function(){
  abbr <- ""
  while(length(state.name[tolower(state.abb)==tolower(abbr)])==0){
    abbr <- readline('Enter a correct state abbreviation.')
  }
  # or return (state.name[tolower(state.abb)==tolower(abbr)])
  print(state.name[tolower(state.abb)==tolower(abbr)])
}
#f.ex40()


# 41. Using a for loop, print the sum 1 + 1/2 + 1/3 + 1/4 + · · · + 1/n for all n
# equal to 1 through 100.

ans<-0
for(i in 1:100){
  print(sum(1 / (1:i)))
}
# 42. Now calculate the sum for all 100 values of n using a single function call.
cumsum(1/(1:100))

# 43. Ask the user for their year of birth and print out the age they turned for every
# year between then and now.

year.of.birth <- as.numeric(readline("enter year of birth"))
year.of.birth:2016-year.of.birth

# 44. The dataset InsectSprays shows the count of insects after applying one of
# six different insect repellents. Construct a two-row three-column grid of his-
#   tograms, on the same scale, showing the number of insects from each spray.
# Do this using a for loop rather than coding each plot by hand.

par(mfrow=c(2,3))
no.sprays<-length(unique(InsectSprays$spray))

for(i in 1:no.sprays){
  hist(InsectSprays$count,main = sprays[i],xlab="count",breaks = seq(0,30,by=5))
}


# 45. Repeat the same two by three plot, but now remove the margins, axes, and
# labels. Replace these by adding the spray identifier (a single letter) to the plot
# with the text command.

par(mfrow=c(2,3))
par(mar=c(0,0,0,0))
no.sprays<-length(unique(InsectSprays$spray))
for(i in 1:no.sprays){
  hist(InsectSprays$count,xlab="",ylab="",axes = FALSE,main = "",breaks = seq(0,30,by=5))
  text(25,30,label=sprays[i])
}
# 46. Calculate the median insect count for each spray.
quantile(InsectSprays$count,probs = 0.5) 
no.sprays<-length(unique(InsectSprays$spray))
sprays<-unique(InsectSprays$spray)
for(i in 1:no.sprays){
  # here i get 1:6 instead of A:F other than with the paste function
  cat("Spray",sprays[i],":",quantile(InsectSprays$count[InsectSprays$spray==sprays[i]],probs = 0.5),"\n",sep=" " )
}

# 47. Using the WorldPhones dataset, calculate the total number of phones used
# in each year using a for loop.
years<-length(rownames(WorldPhones))
total.numbers.year<- rep(0,years)
for(i in 1:years){
  total.numbers.year[i]<-sum(WorldPhones[i,])
}

# 48. Calculate the total number of phones used in each year using a single apply function.
# first col 
apply(WorldPhones,1,sum)

# 49. Calculate the percentage of phones that were in Europe over the years in
# question.
total.phones<-apply(WorldPhones,1,sum)
(WorldPhones[,2]/total.phones)*100

# 50. Convert the entire WorldPhones matrix to percentages; in other words, each
# row should sum to 100.
round((WorldPhones/total.phones)*100,2)

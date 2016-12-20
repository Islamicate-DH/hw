#Problem 1
ask <- function() { 
  num <- readline("enter a number here: ") 
  return(1:num)
}
ask()
#enter a numnber here20
#[1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20

#Problem 2
ask <- function() {
  num <- readline("enter a number here: ")
  num <- as.numeric(num)
  vect <- seq(2, num, by=2)
  return(vect)
}
ask()
#enter a number here: 20
#[1]  2  4  6  8 10 12 14 16 18 20

#Problem 3
ask <- function() {
  num <- readline("enter a number here: ")
  num <- as.numeric(num)
  ans <- sum (1 /(1:num))
  return(ans)
}
ask()
#enter a number here: 20
#[1] 3.59774

#Problem 4
ask <- function() {
  num <- readline("enter a bill total here: ")
  num <- as.numeric(num)
  wtip <- round(num * .15, 2)
  return(wtip)
}
ask()
#enter a bill total here: 20.95
#[1] 3.14

#Problem 5
ask <- function() {
  num <- readline("In what year were you born?: ")
  num <- as.numeric(num)
  age <- 2016 - num
  print(paste("You are", age, "years old"))
}
ask()
#In what year were you born?: 1995
#[1] "You are 21 years old"

#Problem 6
ask <- function() {
  num <- readline("Enter a number here: ")
  num <- as.numeric(num)
  if (num == round(num)) 
    print("Whole Number")
  if (num != round(num)) 
    print("Not a whole number")
}
ask()
#Enter a number here: 3.5
#[1] "Not a whole number"

#Problem 7
ask <- function() {
  num <- readline("enter a number here: ")
  num <- as.numeric(num)
  ftorial <- prod(num:1)
  return(ftorial)
}
ask()
#enter a number here: 6
#[1] 720

#Problem 8
ask <- function() {
  num <- readline("enter a number between one and ten here: ")
  num <- as.numeric(num)
  if (num == 1) ord <- paste(num, "st")
  if (num == 2) ord <- paste(num, "nd")
  if (num == 3) ord <- paste(num, "rd")
  if (num > 3) ord <- paste(num, "th")
  return(ord)
}
ask()
#enter a number between one and ten here: 5
#[1] "5 th"

#Problem 9
ask <- function() {
  num <- readline("enter a number positive whole numberhere: ")
  lnum <- as.numeric(substr(num, nchar(num), nchar(num)))
if (lnum == 1) ord <- paste(num, "st", sep=" ")
if (lnum == 2) ord <- paste(num, "nd", sep=" ")
if (lnum == 3) ord <- paste(num, "rd", sep=" ")
if (lnum > 3) ord <- paste(num, "th", sep=" ")
return(ord)
}
ask()
#enter a number positive whole numberhere: 123
#[1] "123 rd"

#Problem 10
ask <- function() {
  abb <- (readline("enter state abbreviation here: "))
  ans <- abb %in% state.abb
  return(ans)
}
ask()
#enter state abbreviation here: md
#[1] FALSE

#Problem 11
ask <- function() {
  abb <- (readline("enter state abbreviation here: "))
  abb <-toupper(abb)
  ans <- abb %in% state.abb
  return(ans)
}
ask()
#enter state abbreviation here: md
#[1] TRUE

#Problem 12
ask <- function() {
  abb <- readline("enter state abbreviation here: ")
  abb <- toupper(abb)
  ans <- state.name[(abb == state.abb)]
  if (length(ans) == 0) ans = "Error"
  return(ans)
}
ask()
#enter state abbreviation here: md
#[1] "Maryland"

#Problem 13
ask <- function() {
  abb <- readline("enter state name or abbreviation here: ")
  if (any(abb == state.abb)) {
    name <- state.name[abb == state.abb]
  } else if (any(abb == state.abb)) {
    name <- state.abb [abb == state.name]
  } else {
    name <- "Error"
  }
  
    return(name)
}
ask()
#enter state name or abbreviation here: md 
#[1] "Maryland"

#Problem 14
sort(state.x77[,6], decreasing = TRUE)
# Utah         Alaska         Nevada       Colorado     Washington        Wyoming     California 
#67.3           66.7           65.2           63.9           63.5           62.9           62.6 
#Hawaii         Oregon         Kansas          Idaho       Nebraska        Montana           Iowa 
#61.9           60.0           59.9           59.5           59.3           59.2           59.0 
#Massachusetts        Arizona      Minnesota  New Hampshire        Vermont    Connecticut     New Mexico 
#58.5           58.1           57.6           57.6           57.1           56.0           55.2 
#Maine       Delaware      Wisconsin   South Dakota           Ohio        Indiana       Michigan 
#54.7           54.6           54.5           53.3           53.2           52.9           52.8 
#New York        Florida       Illinois     New Jersey       Maryland       Oklahoma   North Dakota 
#52.7           52.6           52.6           52.5           52.3           51.6           50.3 
#Pennsylvania       Missouri       Virginia          Texas   Rhode Island      Louisiana      Tennessee 
#50.2           48.8           47.8           47.4           46.4           42.2           41.8 
#West Virginia        Alabama    Mississippi        Georgia       Arkansas       Kentucky North Carolina 
#41.6           41.3           41.0           40.6           39.9           38.5           38.5 
#South Carolina 
#37.8 

#Problem 15
ans <- sort(state.x77[,6] / state.x77[, 8])
#  Alaska          Texas     California        Montana     New Mexico        Arizona         Nevada 
0.0001177546   0.0001808235   0.0004003556   0.0004066297   0.0004546503   0.0005122689   0.0005933260 
Colorado         Oregon        Wyoming        Georgia   South Dakota       Missouri          Idaho 
0.0006158086   0.0006238044   0.0006470994   0.0006991201   0.0007017313   0.0007072976   0.0007196681 
North Dakota      Minnesota         Kansas       Oklahoma       Arkansas       Nebraska North Carolina 
0.0007261126   0.0007264564   0.0007323902   0.0007501963   0.0007681201   0.0007753357   0.0007889668 
Alabama           Utah    Mississippi       Michigan      Louisiana       Illinois     Washington 
0.0008144671   0.0008197720   0.0008668809   0.0009292993   0.0009392388   0.0009435316   0.0009538831 
Kentucky        Florida      Wisconsin      Tennessee           Iowa       New York   Pennsylvania 
0.0009709962   0.0009724533   0.0010006610   0.0010114208   0.0010546826   0.0011017959   0.0011163991 
Virginia South Carolina           Ohio        Indiana  West Virginia          Maine       Maryland 
0.0012016088   0.0012506203   0.0012983527   0.0014654957   0.0017282925   0.0017690815   0.0052876352 
Vermont  New Hampshire     New Jersey  Massachusetts         Hawaii    Connecticut       Delaware 
0.0061616489   0.0063808574   0.0069804547   0.0074750831   0.0096342412   0.0115178939   0.0275479314 
Rhode Island 
0.0442326025 

#Problem 16
ask <- function() {
  abb <- readline("enter a state abbreviation here: ")
  abb <- toupper(abb)
  colindex <- which(abb == state.abb)
  ans <- state.x77[colindex, 6]
  return(ans)
}
ask()
#enter a state abbreviation here: md
#[1] 52.3

#Problem 17 
vector <- c(sort(state.x77[,3], decreasing = TRUE))
print(vector)
Louisiana    Mississippi South Carolina     New Mexico          Texas        Alabama        Georgia 
2.8            2.4            2.3            2.2            2.2            2.1            2.0 
Arkansas         Hawaii        Arizona North Carolina      Tennessee       Kentucky         Alaska 
1.9            1.9            1.8            1.8            1.7            1.6            1.5 
New York       Virginia  West Virginia        Florida   Rhode Island     California    Connecticut 
1.4            1.4            1.4            1.3            1.3            1.1            1.1 
Massachusetts     New Jersey       Oklahoma   Pennsylvania       Delaware       Illinois       Maryland 
1.1            1.1            1.1            1.0            0.9            0.9            0.9 
Michigan       Missouri   North Dakota           Ohio       Colorado        Indiana          Maine 
0.9            0.8            0.8            0.8            0.7            0.7            0.7 
New Hampshire      Wisconsin          Idaho         Kansas      Minnesota        Montana       Nebraska 
0.7            0.7            0.6            0.6            0.6            0.6            0.6 
Oregon           Utah        Vermont     Washington        Wyoming           Iowa         Nevada 
0.6            0.6            0.6            0.6            0.6            0.5            0.5 
South Dakota 
0.5 

#Problem 18
col1 <- order(state.x77[, 3], decreasing = TRUE)[1:10]
Illiteracy <- rownames(state.x77)[col1]

col2 <- order(state.x77[, 4], decreasing = TRUE)[1:10]
life_expectancy <- rownames(state.x77)[col2]

col3 <- order(state.x77[, 5], decreasing = TRUE)[1:10]
Murder <- rownames(state.x77)[col3]

col4 <- order(state.x77[, 6], decreasing = TRUE)[1:10]
HS_grad <- rownames(state.x77)[col4]

ans <- data.frame(Illiteracy, life_expectancy, Murder, HS_grad, stringsAsFactors = FALSE)
Illiteracy life_expectancy         Murder    HS_grad
1       Louisiana          Hawaii        Alabama       Utah
2     Mississippi       Minnesota        Georgia     Alaska
3  South Carolina            Utah      Louisiana     Nevada
4      New Mexico    North Dakota    Mississippi   Colorado
5           Texas        Nebraska          Texas Washington
6         Alabama          Kansas South Carolina    Wyoming
7         Georgia            Iowa         Nevada California
8        Arkansas     Connecticut         Alaska     Hawaii
9          Hawaii       Wisconsin       Michigan     Oregon
10        Arizona          Oregon North Carolina     Kansas

#Problem 19
ans19 <- ans # from previous
ans20 <- ans19$Illiteracy[which(ans19$Illiteracy %in% ans19$Murder)]
[1] "Louisiana"      "Mississippi"    "South Carolina" "Texas"          "Alabama"        "Georgia"

#Problem 20
ask <- function() {
  class <- readline("enter a class category or 'crew' here: ")
  
  ti2 <- ti[ti$Class == class, ]
  survivals <- sum(ti2$Freq[ti2$Survived == "Yes"])
  deaths <- sum(ti2$Freq[ti2$Survived == "No"])
  
  print(paste("Total deaths", deaths))
  print(paste("Total survivals", survivals))

}
ask()
#enter a class category or 'crew' here: 1st
#[1] "Total deaths 122"
#[1] "Total survivals 203"

#Problem 21
ask <- function() {
  class <- readline("enter a class category or 'crew' here: ")
  
  ti2 <- ti[ti$Class == class, ]
  write.csv(ti2, "titanticOutput.csv")
  
  print(paste("Saved file to ", getwd(), "/titanticOutput.csv", sep = ""))
}
ask()
#enter a class category or 'crew' here: 2nd
#[1] "Saved file to C:/Users/John/Documents/titanticOutput.csv"

#Problem 22
ask <- function() {
  prevwd <- readline("enter the working directory used to save the previous file: ")
  
  setwd(prevwd)
  
  ti3 <- read.csv(file = "titanticOutput.csv", as.is = TRUE)
  return(ti3)
}
#enter the working directory used to save the previous file: C:/Users/John/Documents/
X Class    Sex   Age Survived Freq
1  2   2nd   Male Child       No    0
2  6   2nd Female Child       No    0
3 10   2nd   Male Adult       No  154
4 14   2nd Female Adult       No   13
5 18   2nd   Male Child      Yes   11
6 22   2nd Female Child      Yes   13
7 26   2nd   Male Adult      Yes   14
8 30   2nd Female Adult      Yes   80

#Problem 23
ask <- function() {
  prevwd <- readline("enter the working directory used to save the previous file: ")
  
  setwd(prevwd)
  
  ti3 <- read.csv(file = "titanticOutput.csv", as.is = TRUE)
  print(paste("passenger class:", ti3$Class[1]))
}
#enter the working directory used to save the previous file: C:/Users/John/Documents/
#[1] "passenger class: 2nd"

#Problem 24
percent_change <- as.numeric((WorldPhones[7, ] - WorldPhones[1, ]) / WorldPhones[7, ])
percent_change
N.Amer    Europe      Asia    S.Amer   Oceania    Africa  Mid.Amer 
0.4245469 0.5002895 0.6823153 0.4562612 0.4894541 0.9556110 0.4842007 

#Problem 25
ask <- function() {
  year <- as.numeric(readline("Please select a year between 1951 and 1961: ")) 
  rows <- as.numeric(rownames(WorldPhones))
  newindex <- which(rows <= year)
  newindex <- newindex[length(newindex)]
  ans <- WorldPhones[newindex, 2]
  return(ans)
}
ask()
#Please select a year between 1951 and 1961: 1954
#[1] 21574
# Author: Tobias Wenzel
# Month/Year: 10/2016
# In course: Studying the islamicate Culture through Text Analysis 
# Description: Code snippets and exercises of Chapter 2 in 'arnold_humanities'


# 1. Ask for a positive number and return a vector of all the numbers between 1
# and the input.
f.ch02.ex1 <- function() {
    z <- readline("enter a positive number: ")
    z <- as.numeric(z)
    return(c(1:z))
    
}

# 2. Ask for a number and return a vector of all the even numbers between 1 and
# the input
f.ch02.ex2 <- function() {
  z <- readline("enter a positive number: ")
  z <- as.numeric(z)
  myvec <- c(1:z)
  myvec<-myvec[myvec%%2==0]
  return(myvec)
}

# 3. Ask for a positive integer n. Return the sum: 1 + 1/2 + 1/3 +1/4+· · ·+ 1/n.
f.ch02.ex3 <- function() {
  z <- readline("enter a positive number: ")
  z <- as.numeric(z)
  myres <- 0
  for (number in c(1:z)) {
    myres <- myres+ 1/number
  }
  return(myres)
}
# 4. Ask for the total of a bill and return the amount of a 15 % tip. The round
# function is useful for cleaning up the result to an even penny.

f.ch02.ex4 <- function() {
  z <- readline("enter a positive number: ")
  z <- as.numeric(z)
  z<- z+ z*0.15
  z<- round(z,digits = 2)
  return(z)
}

# 5. Ask for a user’s birth year and print the age they will turn this year. You can
# write the current year directly without trying to determine it externally (it is
# possible to determine the current year, but was not covered in Chap. 2).
f.ch02.ex5 <- function() {
  z <- readline("enter your birthyear: ")
  z <- as.numeric(z)
  currentyear<-format(Sys.time(), "%Y") # current year
  currentyear<-as.numeric(currentyear)
  paste("Your will turn",(currentyear-z),"this year.", sep=" ")
}

# 6. Write a function which asks for a number and determines if it is a whole
# number (or not). Print a message displaying the result using print.
# possible to determine the current year, but was not covered in Chap. 2).
f.ch02.ex6 <- function() {
  z <- readline("enter a number: ")
  z <- as.numeric(z)
  if(z%%1==0){
    print("The number is an integer.")
  }else{
    print("The number is not an integer.")
  }
}

# 7. The factorial of an integer is the product of all the positive integers less than
# or equal to it. For example, the factorial of 4 is equal to 4 ∗ 3 ∗ 2 ∗ 1 = 24.
# There is a function factorial in base R for calculating these. Ask for
# a number and return the factorial, without using the R function. Hint: The
# function prod may be helpful.

f.ch02.ex7 <- function() {
  z <- readline("enter a number: ")
  z <- as.numeric(z)
  myres <- prod(c(1:z))
  return(myres)
}
# 8. Ask the user for a number between 1 and 10 and return the corresponding
# simple ordinal number. For example, 1 should be 1st, 2 should be 2nd, and 4
# should be 4th. Hint: You should not write 10 separate if statements. Notice
# that the numbers 4–10 all have the same ending of “th”.

f.ch02.ex8 <- function() {
  z <- readline("enter a number: ")
  z <- as.numeric(z)
  res.c <-""
  if(z==1){
    res.c <- "1st"
  }else if(z==2){
    res.c <- "2nd"
  }else if(z==3){
    res.c <- "3rd"
  }else if((z>3)&&(z<=10)){
    # mind the brackets
    res.c <- paste(z, "th",sep="")
  }else{
    print("Number too high. Max: 10, Min: 1")
  }
  return(res.c)
}
# 9. Repeat the previous question, but allow the user to input any whole, positive
# number. Hint: Keep the input as a character vector and make use of the
# nchar and substr functions.
f.ch02.ex9 <- function() {
  z <- readline("enter a number: ")
  i<- nchar(z)
  i<-substr(z,i,i) # get last digit
  z <- as.numeric(z)
  res.c <-""
  if(i==1){
    res.c <-paste(z, "st",sep="")
  }else if(i==2){
    res.c <- paste(z, "nd",sep="")
  }else if(i==3){
    res.c <- paste(z, "rd",sep="")
  }else if((i>3)&&(i<=9)){
    # mind the brackets
    res.c <- paste(z, "th",sep="")
  }else{
    print("Something went wrong...")
  }
  return(res.c)
}

# 10. There is a character vector available in base R called state.abb giving the
# two digit postal abbreviations for the 50 US States. Write a function which
# asks for an abbreviation and returns TRUE if it is an abbreviation and FALSE
# otherwise.
f.ch02.ex10 <- function() {
  z <- readline("enter an abbreviation: ")
  if(z %in% state.abb){return(TRUE)}else{return (FALSE)}
}

# 11. Repeat the previous question, but allow for cases where the user inputs a
# different capitalization. For example, “CA”, “Ca”, and “ca” should all return
# as TRUE.

f.ch02.ex11 <- function() {
  z <- readline("enter an abbreviation: ")
  if(tolower(z) %in% tolower(state.abb)){return(TRUE)}else{return (FALSE)}
}

# 12. R provides another vector of state names as a vector called state.name.
# The elements line up with the abbreviations; for example, element 33 of
# the abbreviations is “NC” and element 33 of the names is “North Carolina”.
# Write a function which asks for an abbreviation and returns the corresponding
# state name. If there is none, return the string “error”.

f.ch02.ex12 <- function() {
  z <- readline("enter an abbreviation: ")
  z<-toupper(z)
  if(z %in% state.abb){
    name.c<- state.name[which(state.abb==z)]
    return(name.c)
    }
  else{return ("error")}
}


# 13. Finally, write a function which asks for either a state name or state abbrevia-
#   tion. When given an abbreviation, it returns the state name, and when given a
# name it returns the state abbreviation. If there is no match to either it returns
# the string “error”.


f.ch02.ex13 <- function() {
  z <- readline("enter an abbreviation or a name: ")
  z<-toupper(z) # upper or lowercase in statenames are ok (although not nice)
  if(z %in% state.abb){
    name.c<- state.name[which(state.abb==z)]
    return(name.c)
  } else if (z %in% toupper(state.name)){
    abbrev.c<- state.abb[which(toupper(state.name)==z)]
    return(abbrev.c)
  }  else{
    return ("error")
  }
}

# 14. The object state.x77 is a matrix that gives several summary statistics for
# each of the 50 US States from 1977. Calculate the number of high school
# graduates in each state, and sort from highest to lowest.

sort(100*(state.x77[,"HS Grad"]/state.x77[,"Population"]),decreasing = TRUE) # rel. 

# 15. Calculate the number of high school graduate per square mile in each state.

sort((state.x77[,"HS Grad"]/state.x77[,"Area"]),decreasing = TRUE) 

# 16. Ask the user to provide a state abbreviation, and return the number of high
# school graduates in that state in 1977.

f.ch02.ex16 <- function() {
  z <- readline("enter an abbreviation: ")
  z<-toupper(z)
  if(z %in% state.abb){
    name.c<- state.name[which(state.abb==z)]
    school.grads <- state.x77[name.c,"HS Grad"]
    return(school.grads)
  }
  else{return ("error")}
}

# 17. Now, print a vector of the state names from the highest illiteracy rate to the
# lowest illiteracy rate. Hint: The state names are given as rownames.

names(sort(state.x77[,"Illiteracy"], decreasing = TRUE))

# 18. Construct a data frame with ten rows and three columns(four?): Illiteracy,
# Life expectancy, Murder, and HS grad. Each column gives the names
# of the worst 10 state names. Hint: some measures are good when they are high
# and others are good when the are low. You will need to take account of these.

Illiteracy <- sort(state.x77[,"Illiteracy"],decreasing = TRUE)
Life_expectancy<- sort(state.x77[,"Life Exp"],decreasing = FALSE)
Murder<- sort(state.x77[,"Murder"],decreasing = TRUE)
HS_grad.v<- sort(state.x77[,"HS Grad"],decreasing = FALSE)

data.frame(Illiteracy[1:10], Life_expectancy[1:10], Murder[1:10], HS_grad.v[1:10])

# 19. Using vector notation, print the state names which are in both the top 10 for
# illiteracy and top 10 for murder rates in 1977.
posinIll<-names(Illiteracy[1:10]) %in% names(Murder[1:10]) # indexes with boolean values -> doesn' really work.

# 20. There are several other small datasets contained within the base installation
# of R. One of these is the Titanic dataset, accessed by the object Titanic.
# The format is a bit strange at first, but can be converted to a data frame with
# the following code:
ti <- as.data.frame(Titanic)
# It has a row for each combination of Class, Sex, Age, and Survival flag, along
# with a frequency count (see ?Titanic for more information). Write a func-
#   tion which asks the user to input a Class category (either “1st”, “2nd”, “3rd”,or “Crew”) and prints the total survival and death counts for that category.

f.ch02.ex20 <- function() {
  survived<-table(ti$Class, ti$Survived)
  # cases were left out.
  input.c <- readline("enter a class: ")
  paste(survived[input.c,"No"], "died and", survived[input.c,"Yes"], "survived.")
}

# 21. Take the titanic dataset and again ask the user to select a class. Write the
# subset of the data from this class and save it as a comma separated value file
# named “titanicOutput.csv” in the current working directory. Print to the user
# the full path of the created file.
setwd("/home/tobias/Dokumente/islamicate2.0/arnold_humanities/")
c <- readline("enter a class: ")
output<-ti[ti$Class==c,]
write.csv(output,"titanicOutput.csv")

# 22. Ask the user for the working directory where the previous command was run.
# Set the working directory to this location, read the titanic dataset into R and
# return it.

c <- readline("enter a wd: ")
setwd(c)
ti<-read.csv("titanicOutput.csv")

# 23. Repeat the previous question, but instead print the passenger Class for which
# the file “titanicOutput.csv” was saved

ti[2,2]
ti$Class[1]
# 24. R provides another dataset called WorldPhones giving the number of tele-
#   phones in seven world regions, in thousands, for the years 1951, 1956, 1957,
# 1958, 1959, 1960, and 1961. Calculate the percentage change in number
# of phones for each region between 1951 and 1961. Use vector notation, do
# not do each region by hand! Hint: Percentage change is (new value − old
#                                                         value)/old value.
wp <- WorldPhones
(wp["1961",]-wp["1951",])/wp["1951",]


# 5. Ask the user for a year between 1951 and 1961. Return the number of phones
# in Europe for the year closest, but not after, the input year.
c <- readline("enter a year between 1951 and 1961: ")
nYears <- as.numeric(rownames(WorldPhones))
i <- which(nYears<=c)
i <- i[length(i)]
WorldPhones[i,2]*1000

# answer<-f.ch02.ex1()
# answer <- f.ch02.ex2()
# answer <- f.ch02.ex3()
#  answer <- f.ch02.ex4()
# paste("Total cost including tip is ", answer, "$", sep = "")
# f.ch02.ex5()
# answer <- f.ch02.ex7()
#answer <- f.ch02.ex8()
 #answer <- f.ch02.ex9()
 # answer <- f.ch02.ex10()
 # answer <- f.ch02.ex11()
 # answer <- f.ch02.ex12()
 # answer <- f.ch02.ex13(
 # answer <- f.ch02.ex16()
  f.ch02.ex20()
 
 
answer

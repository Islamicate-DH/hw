# Author: Tobias Wenzel
# Month/Year: 10/2016
# In course: Studying the islamicate Culture through Text Analysis 
# Description: Code snippets and exercises of Chapter 2 in 'Jockers. Text Analysis with R.'

setwd("~/Dokumente/islamicate2.0/hw/wenzel_tobias/") # setting working directory


# loading text-file
# v is indicating the vector
text.v <- scan("data/plainText/melville.txt", what="character", sep="\n")
# load the file from the internet: linebreak leads to an error
# text.v <- scan("http://www.gutenberg.org/cache/epub/2701/pg2701.txt", what="character", sep="\n")
# show the first line
# text.v[1]

# checks, at which index in text.v the first given character sequence arises 
start.v <- which(text.v == "CHAPTER 1. Loomings.")
end.v <- which(text.v == "orphan.") 
# start.v; end.v

# length(text.v) # number of lines

start.metadata.v <- text.v[1:start.v -1] # everything before the novel starts
end.metadata.v <- text.v[(end.v+1):length(text.v)] # everything after the novel
metadata.v <- c(start.metadata.v, end.metadata.v) # combine both in one variable
novel.lines.v <- text.v[start.v:end.v] # and save the novel in novel.lines.v
length(text.v) - length(novel.lines.v) # diff 

# remove linebreaks
novel.v <- paste(novel.lines.v, collapse=" ")
# convert to lowercase
novel.lower.v <- tolower(novel.v)

moby.words.l <- strsplit(novel.lower.v, "\\W") # splitting into words

# class(novel.lower.v) # get data-type
# str(moby.words.l)

moby.word.v <- unlist(moby.words.l) # simplify to vector
not.blanks.v <-  which(moby.word.v!="") # vector with all places where it's not blank

moby.word.v <-moby.word.v[not.blanks.v] # "deleting the blanks"
# moby.word.v[c(4,5,6)]
# moby.word.v[which(moby.word.v=="whale")] # shows all occurences of whale (not indices but words)
# 
# length(moby.word.v[moby.word.v=="whale"])/ length(moby.word.v) # occurences of word "whale" divided by total word count
# 
# length(unique(moby.word.v)) # unique words, then getting the number of them

moby.freqs.t <- table(moby.word.v) # frequency-table 
# moby.freqs.t
sorted.moby.freqs.t <- sort(moby.freqs.t , decreasing=TRUE)

########### Exercise 2.1
# Top 10 Words in Moby Dick
plot(sorted.moby.freqs.t[1:10],
xlab="index no",ylab="occurencies")



# arabic text
text.v <- scan("arabicCorpus/up0600AH/0001HarithIbnHilliza.Diwan.JK007504-ara1", what="character", sep="\n")
start.v <- which(text.v == "# البحر : متقارب تام 1")
end.v <- which(text.v == "# % مضى ثلاث سنين منذ حل بها % % و عام حلت وهذا التابع الخامي % %") 
novel.lines.v <- text.v[start.v:end.v] # and save the novel in novel.lines.v
novel.v <- paste(novel.lines.v, collapse=" ")
# convert to lowercase
novel.lower.v <- tolower(novel.v)
arab.word.v <- unlist(strsplit(novel.lower.v, "\\W"))
arab.word.v <-arab.word.v[arab.word.v!=""] # "deleting the blanks"
# arab.word.v <- arab.word.v[grep("[page]*",arab.word.v, value=FALSE)]

# length(unique(arab.word.v)) # unique words, then getting the number of them

arab.freqs.t <- table(arab.word.v) # frequency-table 
sorted.arab.freqs.t <- sort(arab.freqs.t , decreasing=TRUE)
plot(sorted.arab.freqs.t[1:10],  xlab="index no",ylab="occurencies")

inputDir <-"data/XMLAuthorCorpus"
files.v <- dir(path=inputDir, pattern=".*xml")
chunk.size <- 1000

makeFlexTextChunks <- function(doc.object, chunk.size=10, percentage = TRUE){
  paras <- getNodeSet(doc.object,
                      "/d:TEI/d:text/d:body//d:p",
                      c(d = "http://www.tei-c.org/ns/1.0"))
  words <- paste(sapply(paras,xmlValue), collapse=" ")
  words.lower <- tolower(words)
  words.lower <- gsub("[^[:alnum:][:space:]']", " ", words.lower)
  words.l <- strsplit(words.lower, "\\s+")
  word.v <- unlist(words.l)
  x <- seq_along(word.v)
  if(percentage){
    max.length <- length(word.v)/chunk.size
    chunks.l <- split(word.v, ceiling(x/max.length))
  } else{
    chunks.l <- split(word.v, ceiling(x/chunk.size))
    if (length(chunks.l[[length(chunks.l)]]) <= length(chunks.l[[length(chunks.l)]])/2){
      chunks.l[[length(chunk.l)-1]]<- c(chunks.l[[length(chunks.l)-1]], chunks.l[[length(chunks.l)]])
      chunks.l[[length(chunks.l)]] <- NULL
    }
  
  }
  chunks.l <-lapply(chunks.l, paste, collapse=" ")
  chunks.df <- do.call(rbind, chunks.l)
  return(chunks.df)
}

topic.m <- NULL

for(i in 1:length(files.v)){
  doc.object <- xmlTreeParse(file.path(inputDir, files.v[i]),
                             useInternalNodes=TRUE)
  chunk.m <- makeFlexTextChunks(doc.object, chunk.size, percentage = FALSE)
  textname <- gsub("\\..*","", files.v[i])
  segments.m <- cbind(paste(textname,
                            segment=1:nrow(chinputDir <-"data/XMLAuthorCorpus"
files.v <- dir(path=inputDir, pattern=".*xml")
chunk.size <- 1000

makeFlexTextChunks <- function(doc.object, chunk.size=10, percentage = TRUE){
  paras <- getNodeSet(doc.object,
                      "/d:TEI/d:text/d:body//d:p",
                      c(d = "http://www.tei-c.org/ns/1.0"))
  words <- paste(sapply(paras,xmlValue), collapse=" ")
  words.lower <- tolower(words)
  words.lower <- gsub("[^[:alnum:][:space:]']", " ", words.lower)
  words.l <- strsplit(words.lower, "\\s+")
  word.v <- unlist(words.l)
  x <- seq_along(word.v)
  if(percentage){
    max.length <- length(word.v)/chunk.size
    chunks.l <- split(word.v, ceiling(x/max.length))
  } else{
    chunks.l <- split(word.v, ceiling(x/chunk.size))
    if (length(chunks.l[[length(chunks.l)]]) <= length(chunks.l[[length(chunks.l)]])/2){
      chunks.l[[length(chunk.l)-1]]<- c(chunks.l[[length(chunks.l)-1]], chunks.l[[length(chunks.l)]])
      chunks.l[[length(chunks.l)]] <- NULL
    }
  
  }
  chunks.l <-lapply(chunks.l, paste, collapse=" ")
  chunks.df <- do.call(rbind, chunks.l)
  return(chunks.df)
}

topic.m <- NULL

for(i in 1:length(files.v)){
  doc.object <- xmlTreeParse(file.path(inputDir, files.v[i]),
                             useInternalNodes=TRUE)
  chunk.m <- makeFlexTextChunks(doc.object, chunk.size, percentage = FALSE)
  textname <- gsub("\\..*","", files.v[i])
  segments.m <- cbind(paste(textname,
                            segment=1:nrow(chunk.m), sep="_"), chunk.m)
  topic.m <- rbind(topic.m, segments.m)
}

documents <- as.data.frame(topic.m, stringsAsFactors = F)
colnames(documents) <- c("id", "text")

mallet.instances <- mallet.import(documents$id,
                                  documents$text,
                                  "data/stoplist.csv",
                                  FALSE,
                                  token.regexp ="[\\p{L}']+")
topic.model <- MalletLDA(num.topics = 43)

topic.model$loadDocuments(mallet.instances)

vocabulary <- topic.model$getVocabulary()

word.freqs <- mallet.word.freqs(topic.model)

topic.model$train(400)

topic.words.m <- mallet.topic.words(topic.model,
                                    smoothed=TRUE,
                                    normalized = TRUE)

dim(topic.words.m)

colnames(topic.words.m) <- vocabulary

keywords <- c("california", "ireland")

topic.words.m[, keywords]

imp.row <- which(rowSums(topic.words.m[, keywords]) ==
                   max(rowSums(topic.words.m[, keywords])))

mallet.top.words(topic.model, topic.words.m[imp.row,], 10)

topic.top.words <- mallet.top.words(topic.model,
                                    topic.words.m[imp.row,], 100)

wordcloud(topic.top.words$words,
          topic.top.words$weights,
          c(4,.8), rot.per = 0, random.order = F)
doc.topics.m <- mallet.doc.topics(topic.model,
                                  smoothed = T,
                                  normalized = T)

files.ids.v <- documents[,1]
head(files.ids.v)

file.id.i <- strsplit(files.ids.v, "_")

file.chunk.id.l <- lapply(file.id.i, rbind)
file.chunk.id.m <- do.call(rbind, file.chunk.id.l)

doc.topics.df <- as.data.frame(doc.topics.m)

doc.topics.df <- cbind(file.chunk.id.m[,1], doc.topics.df)

doc.topic.means.df <- aggregate(doc.topics.df[, 2:ncol(doc.topics.df)],
                                list(doc.topics.df[,1]),
                                mean)

barplot(doc.topic.means.df[, "V6"], names.arg=c(1:43))

for (i in 1:43){
  topic.top.words <- mallet.top.words(topic.model, topic.words.m[i,], 100)
}

print(wordcloud(topic.top.words$words,
      topic.top.words$weights, c(4,.8), rot.per=0, random.order=F)
                       
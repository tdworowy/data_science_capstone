curent_wd <- getwd()

libraries <- c("stringr","NLP", "tm", "dplyr", "ggplot2", "RWeka")
for (lib in libraries){
  lib_dir <- paste(curent_wd,"/",lib,sep = '')
  if (!require(lib,lib=lib_dir, character.only = TRUE)){
    dir.create(lib)
    install.packages(lib,lib=lib_dir, dependencies = TRUE)
  }
  library(lib, lib=lib_dir, character.only=TRUE)
}


#Tokenizers
uniTokenizer <- function(x) NGramTokenizer(x, Weka_control(min=1, max=1))
biTokenizer <- function(x) NGramTokenizer(x, Weka_control(min=2, max=2))
triTokenizer <- function(x) NGramTokenizer(x, Weka_control(min=3, max=3))

modelTokenizer <- function(x) NGramTokenizer(x, Weka_control(min=2, max=3))

word_freq <- function(corpus, control_list) {
  tdm <- as.matrix(TermDocumentMatrix(corpus, control=control_list))
  FreqMat <- data.frame(ST = rownames(tdm), 
                        Freq = rowSums(tdm), 
                        row.names = NULL)
  FreqMat[order(-FreqMat$Freq),]
}

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

#generate corpus
generate_corpus <- function(text,stop_words=""){
  Corpus <- VCorpus(VectorSource(paste0(text)))
  corpus <- tm_map(Corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
  corpus <- tm_map(Corpus, toSpace, "@[^\\s]+")
  Corpus <- tm_map(Corpus, removePunctuation)
  Corpus <- tm_map(Corpus, removeNumbers)
  Corpus <- tm_map(Corpus, stripWhitespace)
  Corpus <- tm_map(Corpus, content_transformer(tolower))
  Corpus <- tm_map(Corpus, removeWords, stop_words)
  Corpus
}

# model naive
create_model <- function(text, max_words=3){
    print("Creating model")
    corpus <- generate_corpus(text, stop_words = stopwords("en"))
    one_grams <- word_freq(corpus, list(tokenize = uniTokenizer))
    n_grams <- word_freq(corpus, list(tokenize = modelTokenizer))
    
    
    model <- function(word){
      
      words_grep <- n_grams[grep((paste(word,"\\s", sep = "")), n_grams$ST),]
      count <- max_words
      words <- ""
      if(nrow(words_grep) >0){
        for(str in words_grep[1:max_words, "ST"]){
            next_word <-str_extract(str, paste('(?<=',word,'\\s)\\w+',sep = ""))
            words <- paste(words, next_word)
            count <- count -1
          }
      }
      if (count > 1){
             for (i in 1:count) {
               res <- sample_n(one_grams, 1, weight = one_grams$Freq)
               words <- paste(words, res$ST)
             }
           }
      
      return(words)
      }
    model
}

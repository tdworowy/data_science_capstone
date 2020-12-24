install.packages("tm")
install.packages("fs")
install.packages('RWeka')

library(tm)
library(dplyr)
library(ggplot2)
library(RWeka)
library(stringr)


# Task 1
url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

download.file(url, dest="data/Coursera-SwiftKey.zip", mode="wb") 
unzip ("data/Coursera-SwiftKey.zip", exdir = "data")

data_folder <- "data/final/en_US/"

twitter <-readLines(paste(data_folder,"en_US.twitter.txt",sep = ""))
blog <-readLines(paste(data_folder,"en_US.blogs.txt",sep = ""))
news <-readLines(paste(data_folder,"en_US.news.txt",sep = ""))


sample_size = 1500
twitter <- sample(twitter, sample_size)
blog <- sample(blog, sample_size)
news <- sample(news, sample_size)


#words_ <- c("just","get","said")
twitter_corpus <- generate_corpus(twitter, stop_words = stopwords("en"))
blog_corpus <- generate_corpus(blog, stop_words = stopwords("en"))
news_corpus <- generate_corpus(news, stop_words = stopwords("en"))


#find longest line
max(nchar(blog))
max(nchar(news))

# Task 2 - exploratory annalists 


# one grams
twitter_1_gram <- word_freq(twitter_corpus, list(tokenize = uniTokenizer))
blog_1_gram <- word_freq(blog_corpus,list(tokenize = uniTokenizer))
news_1_gram <- word_freq(news_corpus, list(tokenize = uniTokenizer))

twitter_1_gram[1:10,]
blog_1_gram[1:10,]
news_1_gram[1:10,]


# two grams
twitter_2_gram <- word_freq(twitter_corpus, list(tokenize = biTokenizer))
blog_2_gram <- word_freq(blog_corpus,list(tokenize = biTokenizer))
news_2_gram <- word_freq(news_corpus, list(tokenize = biTokenizer))

twitter_2_gram[1:10,]
blog_2_gram[1:10,]
news_2_gram[1:10,]

# three grams
twitter_3_gram <- word_freq(twitter_corpus, list(tokenize = triTokenizer))
blog_3_gram <- word_freq(blog_corpus,list(tokenize = triTokenizer))
news_3_gram <- word_freq(news_corpus, list(tokenize = triTokenizer))

twitter_3_gram[1:10,]
blog_3_gram[1:10,]
news_3_gram[1:10,]


#top 10 words
plot_words<- function(words){
  ggplot(data = twitter_1_gram[1:10,]) +
    geom_col(aes(y = Freq, x =  reorder(ST, -Freq), fill=ST))
}
plot_words(twitter_1_gram[1:10,])
plot_words(blog_1_gram[1:10,])
plot_words(news_1_gram[1:10,])


# combined
all <- c(twitter, blog, news)
all_corps <- generate_corpus(all, stop_words = stopwords("en"))
all_corps <- generate_corpus(all)
all_1_gram <- word_freq(all_corps, list(tokenize = uniTokenizer))
all_2_gram <- word_freq(all_corps, list(tokenize = biTokenizer))
all_3_gram <- word_freq(all_corps, list(tokenize = triTokenizer))

all_n_gram <- word_freq(all_corps, list(tokenize = modelTokenizer))

all_1_gram[1:10,]
all_2_gram[1:10,]
all_3_gram[1:10,]
all_n_gram[1:3,]
# test model
model <- create_model(all)
model("kicek")
model("of")
model("north")
model("jobs")

model("love")
model("NA")

model("sdwdas")
model("word")




source("../scripts/functions.R") # it will by run by server.R

url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
file <- "../data/Coursera-SwiftKey.zip"
if(!file.exists(file)) {
  download.file(url, dest="../data/Coursera-SwiftKey.zip", mode="wb") 
  unzip ("../data/Coursera-SwiftKey.zip", exdir = "../data")
}

data_folder <- "../data/final/en_US/"

sample_size = 1600
twitter <-readLines(paste(data_folder,"en_US.twitter.txt", sep = ""), n = sample_size)
blog <-readLines(paste(data_folder,"en_US.blogs.txt", sep = ""), n = sample_size)
news <-readLines(paste(data_folder,"en_US.news.txt", sep = ""), n = sample_size)


#twitter <- sample(twitter, sample_size)
#blog <- sample(blog, sample_size)
#news <- sample(news, sample_size)

all <- c(twitter, blog, news)
model <- create_model(all)

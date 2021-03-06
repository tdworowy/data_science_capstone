
read_text <- function(sample_size=1000){
  data_folder <- "data/final/en_US/"
  
  twitter <-readLines(paste(data_folder,"en_US.twitter.txt",sep = ""))
  blog <-readLines(paste(data_folder,"en_US.blogs.txt",sep = ""))
  news <-readLines(paste(data_folder,"en_US.news.txt",sep = ""))
  
  
  twitter <- sample(twitter, sample_size)
  blog <- sample(blog, sample_size)
  news <- sample(news, sample_size)
  all <- c(twitter, blog, news)
  all
  
  }
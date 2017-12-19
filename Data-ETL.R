# load the packages
library(tidytext)
library(dplyr)
library(stringi)

GetData <- function(loc)
{
  #loc
  # load the files
  blogs <-
    readLines(
      # "D:\\Lab\\Final\\final\\en_US\\en_US.blogs.txt",
      paste(loc,"\\en_US.blogs.txt", sep = ""),
      warn = F,
      encoding = 'UTF-8'
    )
  news <-
    readLines(
      paste(loc,"\\en_US.news.txt", sep = ""),
      warn = F,
      encoding = 'UTF-8'
    )
  twitter <-
    readLines(
      paste(loc,"\\en_US.twitter.txt", sep = ""),
      warn = F ,
      encoding = 'UTF-8'
    )
  
  perOfSample <- 0.002
  
  lessBlogs = sample(blogs, perOfSample * length(blogs))
  lessNews = sample(news, perOfSample * length(news))
  lessTwitter = sample(twitter, perOfSample * length(twitter))
  
  combinedData = c(lessBlogs, lessNews, lessTwitter)
  
  # Clean up the data
  
  cleanData <- combinedData
  cleanData  <-
    sapply(cleanData, function(x) {
      gsub('[[:punct:]]', '', x)
    })
  cleanData  <-
    sapply(cleanData, function(x) {
      gsub('[[:cntrl:]]', '', x)
    })
  cleanData  <- sapply(cleanData, function(x) {
    gsub('\\d+', '', x)
  })
  
  cleanData  <- sapply(cleanData, function(x) {
    gsub('\\d+', '', x)
  })
  
  # # remove all non graphical characters
  # cleanData  <- sapply(cleanData, function(x) {
  #   gsub('[^[:graph:]]', '', x)
  # })
  
  cleanData <- stri_trans_general(cleanData, "latin-ascii")
  
  # Need to check if data steming is required
  
  cleanData  <- tolower(cleanData) # Giving error due to special character
  cleanData <- unique(cleanData)
  
  dfWithRowNo <- data.frame(cleanData)
  dfWithRowNo <- dfWithRowNo %>% mutate(id = seq.int(nrow(dfWithRowNo)))
  
  return(dfWithRowNo)
  
}
# load the packages
library(tidytext)
library(dplyr)

GetData <- function(loc)
{
  loc
  # load the files
  blogs <-
    readLines(
      # "D:\\Lab\\Final\\final\\en_US\\en_US.blogs.txt",
      paste(loc,"\\en_US.blogs.txt"),
      warn = F,
      encoding = 'UTF-8'
    )
  news <-
    readLines(
      paste(loc,"\\en_US.news.txt"),
      warn = F,
      encoding = 'UTF-8'
    )
  twitter <-
    readLines(
      paste(loc,"\\en_US.twitter.txt"),
      warn = F ,
      encoding = 'UTF-8'
    )
  
  
  lessBlogs = sample(blogs, .2 * length(blogs))
  lessNews = sample(news, .2 * length(news))
  lessTwitter = sample(twitter, .2 * length(twitter))
  
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
  
  # Need to check if data steming is required
  
  #cleanData  <- sapply(cleanData, function(x) {tolower(x)}) # Giving error due to special character
  cleanData <- unique(cleanData)
  
  return(cleanData)
  
}
library(tidytext)
library(stringr)
library(dplyr)
library(tidyr)

GetNGram <- function(rawFromETL, x) {
  tokenData <-
    rawFromETL %>% unnest_tokens(word, cleanData, token = "ngrams", n = x)
  
  # if (x == 1)
  # {
  #   data(stop_words)
  #   tokenData <-  tokenData %>%
  #     anti_join(stop_words)
  # } else if (x == 2)
  # {
  #   bigrams_separated <- tokenData %>%
  #     separate(word, c("word1", "word2"), sep = " ")
  #   
  #   bigrams_filtered <- bigrams_separated %>%
  #     filter(!word1 %in% stop_words$word) %>%
  #     filter(!word2 %in% stop_words$word)
  #   
  #   tokenData <- bigrams_filtered %>%
  #     unite(word, word1, word2, sep = " ")
  # }
  
  # Data cleaning required for above parameters too
  
  tokenData <- tokenData %>% count(word, sort = TRUE) %>% mutate(word = reorder(word, n))
  
  return(tokenData)
}

GetDataFromFile <- function() {
  
  if (!exists("rawFromETL") || !(length(rawFromETL) > 0))
  {
    rawFromETL <- GetData("en_US")
  } 
  
  oneGram <-  GetNGram(rawFromETL,1)
  twoGram <-  GetNGram(rawFromETL,2)
  threeGram <-  GetNGram(rawFromETL,3)
  fourGram <-  GetNGram(rawFromETL,4)
  fiveGram <-  GetNGram(rawFromETL,5)
  
  save(oneGram,twoGram,threeGram,fourGram,fiveGram, file='fiveGram.RData')
}

LoadDataFromRFile <- function(){
  load('fiveGram.RData')
}

# Implement n gram analysis

source("Ngram.R")
source("Data-ETL.R")
library(stringr)
library(tm)

#GetDataFromFile()

# implementing stupid backoff method

# Check if input something
GetTheScope  <- function(input, countOfPrediction)
{
  cleantext <- CleanText(text = input)
  
  oneGram <- read.csv('oneGram.csv')
  twoGram <- read.csv('twoGram.csv')
  threeGram <- read.csv('threeGram.csv')
  fourGram <- read.csv('fourGram.csv')
  fiveGram <- read.csv('fiveGram.csv')
  
  # We can implement it dynamically but because we have already created n-gram model so here I am using
  # if else so can calculate all model indivisually
  
  #score in 5 gram
  lastWords <-
    paste(tail(strsplit(input, split = " ")[[1]], min(stri_count_words(input), 4)), collapse = ' ')
  matching5Gram <-
    fiveGram %>% filter(grepl(paste("^", lastWords, sep = ''), word))
  matching5Gram <-
    matching5Gram %>% mutate(lastWord = word(word, -1))
  
  totalMatchIn4Gram <-
    fourGram %>% filter(grepl(paste("^", lastWords, "$", sep = ''), word))
  if (nrow(totalMatchIn4Gram) > 0)
  {
    count4 <- totalMatchIn4Gram$n
    if (count4 > 0) {
      score4 <-
        matching5Gram %>% mutate(prob = n / count4)
      score <-  score4
    }
  }
  
  #score in 4 gram
  lastWords <-
    paste(tail(strsplit(input, split = " ")[[1]], min(stri_count_words(input), 3)), collapse = ' ')
  matching4Gram <-
    fourGram %>% filter(grepl(paste("^", lastWords, sep = ''), word))
  matching4Gram <-
    matching4Gram %>% mutate(lastWord = word(word, -1))
  matching4Gram <-
    anti_join(matching4Gram, matching5Gram, by = "lastWord")
  
  totalMatchIn3Gram <-
    threeGram %>% filter(grepl(paste("^", lastWords, "$", sep = ''), word))
  
  if (nrow(totalMatchIn3Gram) > 0)
  {
    count3 <- totalMatchIn3Gram$n
    if (count3 > 0) {
      score3 <-
        matching4Gram %>% mutate(prob = 0.4 * (n / count3))
      
      if (exists("score")) {
        score <- suppressWarnings(union_all(score, score3))
      } else
      {
        score <-  score3
      }
    }
  }
  #score in 3 gram
  lastWords <-
    paste(tail(strsplit(input, split = " ")[[1]], min(stri_count_words(input), 2)), collapse = ' ')
  matching3Gram <-
    threeGram %>% filter(grepl(paste("^", lastWords, sep = ''), word))
  matching3Gram <-
    matching3Gram %>% mutate(lastWord = word(word, -1))
  matching3Gram <-
    anti_join(matching3Gram, matching4Gram, by = "lastWord")
  matching3Gram <-
    anti_join(matching3Gram, matching5Gram, by = "lastWord")
  
  totalMatchIn2Gram <-
    twoGram %>% filter(grepl(paste("^", lastWords, "$", sep = ''), word))
  
  if (nrow(totalMatchIn2Gram) > 0)
  {
    count2 <- totalMatchIn2Gram$n
    if (count2 > 0) {
      score2 <-
        matching3Gram %>% mutate(prob = 0.4 * 0.4 * (n / count2))
      if (exists("score")) {
        score <- suppressWarnings(union_all(score, score2))
      } else
      {
        score <- score2
      }
    }
  }
  
  #score in 2 gram
  lastWords <-
    paste(tail(strsplit(input, split = " ")[[1]], min(stri_count_words(input), 1)), collapse = ' ')
  matching2Gram <-
    twoGram %>% filter(grepl(paste("^", lastWords, sep = ''), word))
  matching2Gram <-
    matching2Gram %>% mutate(lastWord = word(word, -1))
  matching2Gram <-
    anti_join(matching2Gram, matching3Gram, by = "lastWord")
  matching2Gram <-
    anti_join(matching2Gram, matching4Gram, by = "lastWord")
  matching2Gram <-
    anti_join(matching2Gram, matching5Gram, by = "lastWord")
  
  totalMatchIn1Gram <-
    oneGram %>% filter(grepl(paste("^", lastWords, "$", sep = ''), word))
  
  if (nrow(totalMatchIn1Gram) > 0)
  {
    count1 <- totalMatchIn1Gram$n
    if (count1 > 0) {
      score1 <-
        matching2Gram %>% mutate(prob = 0.4 * 0.4 * 0.4 * (n / count1))
      
      if (exists("score")) {
        score <- suppressWarnings(union_all(score, score1))
      } else
      {
        score <- score1
      }
    }
  }
  
  
  #rm(score1, score2, score3, score4)
  
  score <- subset(score, select = c("n", "lastWord", "prob"))
  score <- rename(score, "word" = "lastWord")
  
  data(stop_words)
  score <- score %>% anti_join(stop_words)
  
  score <-
    head(unique(score %>% filter(!is.na(word)) %>% arrange(desc(prob))), countOfPrediction)
  
  return(score)
  
}

CleanText <- function(text) {
  cleantext  <- gsub('[[:punct:]]', '', text)
  cleantext  <- gsub('[[:cntrl:]]', '', cleantext)
  cleantext  <- gsub('\\d+', '', cleantext)
  cleantext  <- iconv(cleantext, to = "ASCII", sub = "")
  cleantext  <- tolower(cleantext)
  
  badwords = c(
    'fuck',
    'shit',
    'asshole',
    'cunt',
    'fag',
    'fuk',
    'fck',
    'fcuk',
    'assfuck',
    'assfucker',
    'fucker',
    'motherfucker',
    'asscock',
    'asshead',
    'asslicker',
    'asslick',
    'assnigger',
    'nigger',
    'asssucker',
    'bastard',
    'bitch',
    'bitchtits',
    'bitches',
    'bitch',
    'brotherfucker',
    'bullshit',
    'bumblefuck',
    'buttfucka',
    'fucka',
    'buttfucker',
    'buttfucka',
    'fagbag',
    'fagfucker',
    'faggit',
    'faggot',
    'faggotcock',
    'fagtard',
    'fatass',
    'fuckoff',
    'fuckstick',
    'fucktard',
    'fuckwad',
    'fuckwit',
    'dick',
    'dickfuck',
    'dickhead',
    'dickjuice',
    'dickmilk',
    'doochbag',
    'douchebag',
    'douche',
    'dickweed',
    'dyke',
    'dumbass',
    'dumass',
    'fuckboy',
    'fuckbag',
    'gayass',
    'gayfuck',
    'gaylord',
    'gaytard',
    'nigga',
    'niggers',
    'niglet',
    'paki',
    'piss',
    'prick',
    'pussy',
    'poontang',
    'poonany',
    'porchmonkey',
    'porch monkey',
    'poon',
    'queer',
    'queerbait',
    'queerhole',
    'queef',
    'renob',
    'rimjob',
    'ruski',
    'sandnigger',
    'sand nigger',
    'schlong',
    'shitass',
    'shitbag',
    'shitbagger',
    'shitbreath',
    'chinc',
    'carpetmuncher',
    'chink',
    'choad',
    'clitface',
    'clusterfuck',
    'cockass',
    'cockbite',
    'cockface',
    'skank',
    'skeet',
    'skullfuck',
    'slut',
    'slutbag',
    'splooge',
    'twatlips',
    'twat',
    'twats',
    'twatwaffle',
    'vaj',
    'vajayjay',
    'va-j-j',
    'wank',
    'wankjob',
    'wetback',
    'whore',
    'whorebag',
    'whoreface'
  )
  
  cleantext <- removeWords(cleantext, badwords)
}

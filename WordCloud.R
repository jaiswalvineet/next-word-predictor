library(wordcloud)

GetWordCloud <- function(){
  
  load('fiveGram.RData')
  oneGram$word <- as.character(oneGram$word)
  oneGram %>%
    anti_join(stop_words) %>%
    with(
      wordcloud(
        word,
        n,
        scale = c(6, 0.5),
        max.words = 150,
        random.order = FALSE,
        rot.per = 0.35,
        use.r.layout = FALSE,
        colors = brewer.pal(8, "Dark2")
      )
    )
}
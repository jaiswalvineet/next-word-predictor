


# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(wordcloud)

source("WordCloud.R")
source("BackOff-Implementation.R")


shinyServer(function(input, output) {
  scoresInput <- reactive({
    validate(
      need(input$inputtext, 'Please provide your input')
    )
    inputText <-  input$inputtext
    noOfRecords <-  input$noOfPredictedWord
    scores <- GetTheScope(inputText, noOfRecords)
  })
  
  
  output$nextWOrdGraph <- renderPlot({
    scores <- scoresInput()
    ggplot(scores, aes(x = scores$word, y = scores$prob)) + geom_bar(stat = "identity", fill =
                                                                       "lightblue") + theme(axis.text.x = element_text(
                                                                         angle = 90,
                                                                         hjust = 1,
                                                                         vjust = 1
                                                                       ))  + labs(title = "", x = "Predicted words", y = "probability")
    
  })
  
  output$wordCloud <- renderPlot({
    scores <- scoresInput()
    wordcloud(
      scores$word,
      scores$prob,
      scale = c(6, 0.5),
      max.words = 150,
      random.order = FALSE,
      rot.per = 0.35,
      use.r.layout = FALSE,
      colors = brewer.pal(8, "Dark2")
    )
  })
  
  
  output$formattedData <- renderDataTable({
    FormattedData <- scoresInput()
      #subset(scoresInput(), select = c("scores$Word", "scores$prob"))
  })
  
  
})

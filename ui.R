
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Next word predictor"),
  tags$h4("Based on 5-gram language model and stupid backoff algorithm") ,

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      textInput("inputtext", "Give your input text", "your house is"),
      helpText("Type in a sentence above and the results will display to the right. It may take sometime to load"),
      sliderInput("noOfPredictedWord",
                  "Number of Predicted words:",
                  min = 1,
                  max = 50,
                  value = 10)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Prediction ", 
                 h4('Next word prediction with probability', align = "center"),
                 plotOutput('nextWOrdGraph'),
                 h4('Word Cloud', align = "center"),
                 plotOutput('wordCloud'),
                 h4('Filtered Data', align = "center"),
                 dataTableOutput('formattedData')
                 ),
        # tabPanel("Word Cloud ", plotOutput("wordCloud"),
        #          helpText("This word cloud is after removing common words")),
        tabPanel("Summary",  includeMarkdown("summary.Rmd"))
      )
    )
  )
))

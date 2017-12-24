
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
      textInput("inputtext", "Give your input text", "How are you "),
      h5('The next word predictor may take sometime to load', align = "left"),
      sliderInput("noOfPredictedWord",
                  "Number of Predicted words:",
                  min = 1,
                  max = 50,
                  value = 10)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Prediction ", plotOutput("distPlot")),
        tabPanel("Word Cloud ", verbatimTextOutput("summary")),
        tabPanel("Summary", tableOutput("table"))
      )
    )
  )
))

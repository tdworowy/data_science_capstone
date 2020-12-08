library(shiny)

shinyUI(fluidPage(

    titlePanel("Next word predictor"),

    sidebarLayout(
        sidebarPanel(
            textInput("word","word"),
       
            
        ),

        mainPanel(
            h3("Next Words proposal:"),
            textOutput("next_word"),
       
        )
    )
))

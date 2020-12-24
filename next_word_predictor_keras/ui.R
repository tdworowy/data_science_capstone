library(shiny)

shinyUI(fluidPage(

    titlePanel("Next word predictor"),

    sidebarLayout(
        sidebarPanel(
            h3("Enter phraze:"),
            textInput("phraze","phraze"),
       
            
        ),

        mainPanel(
            h3("Next Words proposal:"),
            textOutput("next_word"),
       
        )
    )
))

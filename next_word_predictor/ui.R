library(shiny)

shinyUI(fluidPage(

    titlePanel("Next word predictor"),

    sidebarLayout(
        sidebarPanel(
            textInput("phraze",label="Enter phraze:"),
            
        ),

        mainPanel(
            h3("Next Words proposal:"),
            textOutput("next_word"),
       
        )
    )
))

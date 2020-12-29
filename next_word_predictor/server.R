
library(shiny)


shinyServer(function(input, output) {
    source("model_creation.R")
    new_word <-reactive({
        next_word <- model(input$phraze)
        print(next_word)
        next_word
    })
    
    output$next_word = new_word
  
})

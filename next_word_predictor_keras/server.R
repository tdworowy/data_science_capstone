library(shiny)

predict_word <- function(model, tokenizer, seq_len=4, input_text){
  pred_word <- ''
  encoded_text <- texts_to_sequences(tokenizer, input_text)
  pad_encoded =  pad_sequences(encoded_text, maxlen=seq_len, truncating='pre')
  pred <- predict(model, pad_encoded)
  if(input_text != '') {
    for(i in 1:3){
      i <- which(pred==max(pred))
      print(pred[i])
      new_word <- tokenizer$index_word[i]
      pred_word <- paste(pred_word, new_word[[1]])
      pred[i] <- 0
    }
  }
  return(pred_word)

}



shinyServer(function(input, output) {
  
    virtualenv_dir = Sys.getenv('VIRTUALENV_NAME')
    python_path = Sys.getenv('PYTHON_PATH')
  
    reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
    reticulate::use_virtualenv(virtualenv_dir, required = T)

    curent_wd <- getwd() #FUCK THIS SHIT 
    print(curent_wd)
    dir.create('keras')
    install.packages('keras', lib=paste(curent_wd,"/keras",sep = ''))
   
    library(keras,lib=paste(curent_wd,"/keras",sep = ''))
    install_keras()

    
    model <- load_model_hdf5('word_prediction_model.hdf5')
    tokenizer <- load_text_tokenizer('tokenizer.pickle')
    new_word <-reactive({
        next_word <- predict_word(model=model, tokenizer=tokenizer, input_text=input$phraze)
        print(next_word)
        next_word
    })
    
    output$next_word = new_word
  
})

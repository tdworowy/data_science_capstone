library(shiny)
library(reticulate)

virtualenv_dir = Sys.getenv('word_predictor')
python_path = Sys.getenv('PYTHON_PATH')

PYTHON_DEPENDENCIES = c('keras')

reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES, ignore_installed=TRUE)
reticulate::use_virtualenv(virtualenv_dir, required = T)


#install.packages("keras")
#require(tensorflow)
#install_tensorflow()
#require(keras)
keras <- import("keras")

predict_word <- function(model, tokenizer, seq_len=4, input_text){
  pred_word <- ''
  encoded_text <- keras$texts_to_sequences(tokenizer, input_text)
  pad_encoded = keras$pad_sequences(encoded_text, maxlen=seq_len, truncating='pre')
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
    model <- keras$load_model_hdf5('word_prediction_model.hdf5')
    tokenizer <- keras$load_text_tokenizer('tokenizer.pickle')
    new_word <-reactive({
        next_word <- predict_word(model=model, tokenizer=tokenizer, input_text=input$phraze)
        print(next_word)
        next_word
    })
    
    output$next_word = new_word
  
})

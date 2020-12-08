install.packages('keras')
library(keras)

nltk <<- reticulate::import("nltk", delay_load = TRUE, convert = FALSE)
texts <- read_text()

tokenizer <- text_tokenizer(char_level = F)
tokenizer %>% fit_text_tokenizer(texts)
save_text_tokenizer(tokenizer, "tokenizer")

generate_seq <- function(text_data, train_len=4){
   
   tokens = nltk$word_tokenize(text_data)
   text_sequences = list()
   for(i in train_len: length(tokens)){
      seq = tokens[i - train_len:i]
      text_sequences.append(seq)
   }
   
   return(tokens, text_sequences)
}

# TODO 
vocabulary_size <- length(tokenizer$word_counts)

train_encoded <- unlist(tokenizer$texts_to_sequences(texts))

train_targets <- to_categorical(train_encoded, num_classes=vocabulary_size) # something is wrong here

seq_len <- length(train_encoded)


model <- keras_model_sequential() 
model %>% 
 layer_embedding(units=vocabulary_size, seq_len, input_length=seq_len) %>% 
 layer_lstm(units=250,return_sequences=True) %>%
 layer_lstm(units=250) %>%
 layer_dense(units=250, activation='relu') 
 layer_dense(units=vocabulary_size, activation='softmax')
 
 model %>% compile(
   loss = 'categorical_crossentropy',
   optimizer = optimizer_adam(),
   metrics = c('accuracy')
 )
 
 history <- model %>% fit(
   x_train, y_train, 
   epochs = 400, 
   validation_split = 0.2,
   verbose=1
 )
 
 
 # testing
 
 model <- load_model_hdf5('word_prediction_model.hdf5')
 tokenizer <- load_text_tokenizer('tokenizer.pickle')
 
 encoded_text <- texts_to_sequences(tokenizer, "job")
 pad_encoded = pad_sequences(encoded_text, maxlen=3, truncating='pre')
 pred <- predict(model, pad_encoded)
 i <- which(pred==max(pred))
 tokenizer$index_word[i]
 
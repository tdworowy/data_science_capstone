import pickle

from keras.preprocessing.text import Tokenizer
from keras.regularizers import l2
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
import numpy as np
import re
from keras.utils import to_categorical
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Embedding

train_len = 15 #10


def generate_seq(text_data: str, train_len=train_len) -> tuple:
    cleaned = re.sub(r'\W+', ' ', text_data).lower()
    stopset = set(stopwords.words('english'))
    tokens = word_tokenize(cleaned)
    tokens = [token.lower() for token in tokens if token.lower() not in stopset and len(token) > 2]

    text_sequences = []
    for i in range(train_len, len(tokens)):
        seq = tokens[i - train_len:i]
        text_sequences.append(seq)

    return tokens, text_sequences


def generate_n_seq(tokens: list, text_sequences: list, train_len=train_len) -> tuple:
    sequences = {}
    count = 1

    for i in range(len(tokens)):
        if tokens[i] not in sequences:
            sequences[tokens[i]] = count
            count += 1

    tokenizer = Tokenizer()
    tokenizer.fit_on_texts(text_sequences)
    sequences = tokenizer.texts_to_sequences(text_sequences)
    vocabulary_size = len(tokenizer.word_counts) + 1

    n_sequences = np.empty([len(sequences), train_len], dtype='int32')
    for i in range(len(sequences)):
        n_sequences[i] = sequences[i]

    return tokenizer, n_sequences, vocabulary_size


if __name__ == "__main__":
    data_dir = "data/final/en_US"
    with open(f"{data_dir}/en_US.blogs.txt", encoding="utf8") as blog_file, \
            open(f"{data_dir}/en_US.news.txt", encoding="utf8") as news_file, \
            open(f"{data_dir}/en_US.twitter.txt", encoding="utf8") as twitter_file:
        data = blog_file.read() + news_file.read() + twitter_file.read()
        tokens, text_sequences = generate_seq(data)

    tokenizer, n_sequences, vocabulary_size = generate_n_seq(tokens, text_sequences)

    train_inputs = n_sequences[:, :-1]
    train_targets = n_sequences[:, -1]

    train_targets = to_categorical(train_targets, num_classes=vocabulary_size)
    seq_len = train_inputs.shape[1]

    model = Sequential()
    neurons = 500#250
    model.add(Embedding(vocabulary_size, seq_len, input_length=seq_len))
    model.add(LSTM(neurons, return_sequences=True))
    model.add(LSTM(neurons, recurrent_regularizer=l2(0.01), bias_regularizer=l2(0.01)))
    model.add(Dense(neurons, activation='relu', bias_regularizer=l2(0.01)))
    model.add(Dense(vocabulary_size, activation='softmax'))

    with open('tokenizer.pickle', 'wb') as handle:
        pickle.dump(tokenizer, handle, protocol=pickle.HIGHEST_PROTOCOL)

    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    model.fit(train_inputs, train_targets, epochs=150, verbose=1)

    model.save("word_prediction_model.hdf5")



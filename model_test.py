import pickle

from keras import Sequential
from keras.engine.saving import load_model
from keras_preprocessing.sequence import pad_sequences
from keras_preprocessing.text import Tokenizer
from pandas import np


def predict(model: Sequential, tokenizer: Tokenizer, word: str, seq_len: int = 4):
    encoded_text = tokenizer.texts_to_sequences([word])[0]
    pad_encoded = pad_sequences([encoded_text], maxlen=seq_len, truncating='pre')
    print(encoded_text, pad_encoded)
    pred = model.predict(pad_encoded)[0]
    for _ in range(0, 3):
        index = np.argmax(pred, axis=0)
        pred_word = tokenizer.index_word[index]
        print("Next word suggestion:", pred_word)
        pred = np.delete(pred, index)


if __name__ == "__main__":
    model = load_model('word_prediction_model.hdf5')
    with open('tokenizer.pickle', 'rb') as handle:
        tokenizer = pickle.load(handle)

    predict(model, tokenizer, 'man')

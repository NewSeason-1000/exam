import math
import nltk
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import textdistance
from collections import Counter
from textblob import TextBlob

# Download necessary NLTK resources
nltk.download('punkt')
nltk.download('stopwords')

# Sample text corpus
corpus = ['This is the first document.',
          'This document is the second document.',
          'And this is the third one.',
          'Is this the first document?']

# Term Document Matrix (TDM)
vectorizer = CountVectorizer()
X_tdm = vectorizer.fit_transform(corpus)
print("Term Document Matrix (TDM):\n", X_tdm.toarray())

# Inverted Index
inverted_index = {}
for i, doc in enumerate(corpus):
    for word in doc.split():
        if word not in inverted_index:
            inverted_index[word] = [i]
        else:
            inverted_index[word].append(i)
print("Inverted Index:\n", inverted_index)

# Term Frequency (TF) for a sample document
doc = "This is a sample document."
words = doc.split()
word_count = Counter(words)
total_words = len(words)
tf = {word: count / total_words for word, count in word_count.items()}
print("Term Frequency (TF):\n", tf)

# Inverse Document Frequency (IDF)
word_docs = {'word1': 3, 'word2': 2, 'word3': 4}
total_docs = 10
idf = {word: math.log(total_docs / doc_freq) for word, doc_freq in word_docs.items()}
print("Inverse Document Frequency (IDF):\n", idf)

# Term Weights (TF-IDF)
tfidf_vectorizer = TfidfVectorizer()
X_tfidf = tfidf_vectorizer.fit_transform(corpus)
print("Term Weights (TF-IDF):\n", X_tfidf.toarray())

# Bag of Words (BoW)
vectorizer_bow = CountVectorizer()
X_bow = vectorizer_bow.fit_transform(corpus)
print("Bag of Words (BoW):\n", vectorizer_bow.get_feature_names_out())

# Cosine similarity between documents
cos_sim = cosine_similarity(X_tfidf)
print("Cosine Similarity:\n", cos_sim)

# Sentence tokenization
text = "In history, Norsemen dressed more extravagantly and possibly notably more sexually provocatively than portrayed in the show. They dressed in bright colors, bathed weekly and used primitive hair-dyes and even came off as vain to some Christians."
sentences = sent_tokenize(text)
print("Sentence Tokenization:\n", sentences)

# Word tokenization, remove stopwords, and print original text without stopwords
tokens = word_tokenize(text)
stop_words = set(stopwords.words('english'))
filtered_text = [word for word in tokens if word.lower() not in stop_words]
print("Original Text without Stopwords:\n", ' '.join(filtered_text))

# Levenshtein distance for word correction
word1 = "apple"
word2 = "aple"
distance = textdistance.levenshtein.normalized_distance(word1, word2)
print("Levenshtein Distance for Word Correction:\n", distance)

# Sentiment analysis
text_sentiment = "This is a great movie!"
blob = TextBlob(text_sentiment)
sentiment = blob.sentiment
print("Sentiment Analysis:\n", sentiment)

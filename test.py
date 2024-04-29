import nltk
from nltk.corpus import stopwords
from textblob import TextBlob

# Download NLTK stopwords if not already downloaded
nltk.download('stopwords')

# Sample text for tokenization
text = "I love this product It's amazeng."


# Tokenize the text using split()
tokens = text.split()
print("tokens ",tokens)

# Get the list of stopwords from NLTK
default_stop_words = set(stopwords.words('english'))

custom_stop_words = {"English", "Algorithm", "product"}

# Combine default and custom stopwords
all_stop_words = default_stop_words.union(custom_stop_words)


# Remove stopwords from the list of tokens
filtered_tokens = [word for word in tokens if word.lower() not in all_stop_words]

# Writing Sentence without stopwords
clean_text=' '.join(filtered_tokens)

# Print the clean text
print("clean text ",clean_text)
# Print the filtered tokens
print("filtered_tokens ",filtered_tokens)

# Create a TextBlob object
blob = TextBlob(clean_text)

# Correct the text
corrected_text = str(blob.correct())

# Print the corrected text
print("Corrected text:", corrected_text)

# Find misspelled words and their corrections
corrections = {str(word): str(word.correct()) for word in blob.words if word.correct() != word}

# Print misspelled words and their corrections // this is also known as -Levenshtein distance for word correction

print("Misspelled words and their corrections (Levenshtein distance):")
for misspelled, corrected in corrections.items():
    print(f"Correction: {corrected}, Misspelled: {misspelled}")



import math
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.metrics.pairwise import cosine_similarity

# Sample documents
documents = [
    "Sentiment analysis is an NLP strategy that can determine whether the meaning behind data is positive, negative, or neutral.",
    "Sentiment Analysis is also widely used on Social Listening processes.",
]

# Tokenize and count terms
vectorizer = CountVectorizer()
X = vectorizer.fit_transform(documents)

# Convert to DataFrame for better readability (optional)
import pandas as pd
term_document_matrix = pd.DataFrame(X.toarray(), columns=vectorizer.get_feature_names_out())

# Print Term Document Matrix
print("Term Document Matrix:")
print(term_document_matrix)

# Compute TF-IDF
tfidf_transformer = TfidfTransformer()
tfidf_matrix = tfidf_transformer.fit_transform(X)

# Print TF-IDF Matrix
print("\nTF-IDF Matrix:")
print(tfidf_matrix.toarray())

# Compute Cosine Similarity
cos_sim = cosine_similarity(tfidf_matrix)
print("\nCosine Similarity between D1 and D2:")
print(cos_sim[0, 1])

# Term Frequency (TF), Inverse Document Frequency (IDF), and Term Weight (TW)
terms = vectorizer.get_feature_names_out()
doc_freq = X.sum(axis=0)

term_weights = {}
for i, term in enumerate(terms):
    tf = term_document_matrix[term].sum() / term_document_matrix.sum().sum()  # Term frequency
    idf = math.log(len(documents) / doc_freq[0, i])  # Inverse Document Frequency
    tw = tf * idf  # Term Weight
    term_weights[term] = tw

# Print Term Weights
print("\nTerm Weights:")
for term, weight in term_weights.items():
    print(f"{term}: {weight}")



#Sentiment analysis
from textblob import TextBlob

# Sample text for sentiment analysis
text = "I love this product! It's amazing."

# Create a TextBlob object
blob = TextBlob(text)

# Perform sentiment analysis
sentiment_score = blob.sentiment.polarity

# Interpret the sentiment score
if sentiment_score > 0:
    sentiment_label = "Positive"
elif sentiment_score < 0:
    sentiment_label = "Negative"
else:
    sentiment_label = "Neutral"

# Print the sentiment analysis results
print("Text:", text)
print("Sentiment Score:", sentiment_score)
print("Sentiment Label:", sentiment_label)

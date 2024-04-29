import nltk
from nltk.corpus import stopwords
from textblob import TextBlob

# Download NLTK stopwords if not already downloaded
nltk.download('stopwords')

# Sample text for tokenization
text = '''Remote processing refers to the practice of handling tasks and operations from a distant location, 
often through the use of technology such as computers or mobile devices. This allows individuals or 
organizations to perform various functions without being physically present at the location where the 
tasks are being carried out. Remote processing is commonly used in fields such as telecommuting, 
cloud computing, and remote monitoring, providing convenience and flexibility in accessing and 
managing data and resources. It enables efficient collaboration and communication among individuals 
or teams spread across different geographical locations. Additionally, remote processing enhances 
productivity and reduces the need for extensive travel, contributing to cost savings and environmental 
sustainability'''

# Tokenize the text using split()
tokens = text.split()
print("tokens ",tokens)

# Get the list of stopwords from NLTK
stop_words = set(stopwords.words('english'))

# Remove stopwords from the list of tokens
filtered_tokens = [word for word in tokens if word.lower() not in stop_words]

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

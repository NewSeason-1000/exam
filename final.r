# 1. Data Manipulation and Analysis
# Creating data frame
sample_data <- data.frame(
  ID = 1:100,
  Gender = sample(c("Male", "Female"), 100, replace = TRUE),
  Age = sample(18:60, 100, replace = TRUE),
  Height_cm = rnorm(100, mean = 170, sd = 10),
  Weight_kg = rnorm(100, mean = 70, sd = 8)
)

# Printing first few rows
print(head(sample_data))

# Accessing column names
print(names(sample_data))

# Number of columns
print(ncol(sample_data))

# Number of rows
print(nrow(sample_data))

# Creating bins for Age
sample_data$Age_bins <- cut(sample_data$Age, breaks = c(18, 30, 40, 50, 60))

# Computing quantiles for Height
print(quantile(sample_data$Height_cm))

# Generating frequency table for Gender
print(table(sample_data$Gender))

# Examining object structure
print(str(sample_data))

# Summary statistics
print(summary(sample_data))

# Writing data to CSV
write.csv(sample_data, "sample_data.csv", row.names = FALSE)

# Reading data from CSV
read_sample_data <- read.csv("sample_data.csv")

# Displaying first few rows
print(head(read_sample_data))

# 2. Statistical Analysis
# Calculating mean, median, mode, range, variance, standard deviation
mean_age <- mean(sample_data$Age)
median_height <- median(sample_data$Height_cm)
var_weight <- var(sample_data$Weight_kg)
sd_age <- sd(sample_data$Age)
# Summarizing data
summary_data <- summary(sample_data)

# 3. Cross Tabulation
cross_tab <- table(sample_data$Gender, sample_data$Age_bins)

# 4. Data Visualization
library(ggplot2)
# Boxplot for Height
ggplot(sample_data, aes(x = "", y = Height_cm, fill = Gender)) +
  geom_boxplot() +
  theme_minimal()

# Scatter plot for Height vs. Weight
ggplot(sample_data, aes(x = Height_cm, y = Weight_kg, color = Gender)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()

# Histogram for Age distribution
ggplot(sample_data, aes(x = Age)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(x = "Age", y = "Frequency", title = "Age Distribution") +
  theme_minimal()

# 5. Data Transformation
# Calculate BMI (Body Mass Index) from Height and Weight
sample_data$BMI <- sample_data$Weight_kg / ((sample_data$Height_cm / 100) ^ 2)

# 6. Smoothing Methods
# Create age groups to smooth out Age variable
sample_data$Smoothed_Age <- cut(sample_data$Age, breaks = c(18, 30, 40, 50, 60), labels = c("18-30", "31-40", "41-50", "51-60"))

# 7. Text Mining
library(tm)
# Sample text data
text <- c("This is the first document.",
          "This document is the second document.",
          "And this is the third one.",
          "Is this the first document?")

# Create a corpus
corpus <- Corpus(VectorSource(text))

# Preprocess the text
corpus <- tm_map(corpus, content_transformer(tolower))  # Convert to lowercase
corpus <- tm_map(corpus, removePunctuation)             # Remove punctuation
corpus <- tm_map(corpus, removeNumbers)                 # Remove numbers
corpus <- tm_map(corpus, removeWords, stopwords("english"))  # Remove stopwords

# Create a term-document matrix
tdm <- TermDocumentMatrix(corpus)
matrix <- as.matrix(tdm)

# 8. One-Hot Encoding
# Perform one-hot encoding for the 'Gender' variable
encoded_gender <- model.matrix(~ Gender - 1, data = sample_data)

# 9. Loading Packages
# Already loaded at the beginning




# Load necessary libraries
library(rvest)
library(tidyverse)

### Task 1: Develop a structured sitemap to retrieve web data from Wikipedia ###

# Define the Wikipedia page URLs to scrape
page_urls <- c(
  "https://en.wikipedia.org/wiki/Rama",
  "https://en.wikipedia.org/wiki/Ramayana"
)

# Define CSS selectors or XPath expressions to extract data from each page
css_selectors <- list(
  title = "h1.firstHeading",  # Selector for page title
  paragraphs = "div#mw-content-text p"  # Selector for paragraphs
)

### Task 2: Perform web scraping across multiple web pages using the generated sitemap ###

# Initialize an empty list to store scraped data
scraped_data <- list()

# Iterate over each page URL and scrape data
for (i in seq_along(page_urls)) {
  # Read HTML content from the current page
  html_content <- read_html(page_urls[i])
  
  # Extract page title
  page_title <- html_content %>% html_node(css_selectors$title) %>% html_text()
  
  # Extract paragraphs
  paragraphs <- html_content %>% html_nodes(css_selectors$paragraphs) %>% html_text()
  
  # Store scraped data in the list
  scraped_data[[i]] <- list(title = page_title, paragraphs = paragraphs)
}

# Combine scraped data into a data frame
final_data <- bind_rows(scraped_data)

### Task 3: Outline the essential steps comprehensively to accomplish tasks 1 and 2 ###
# Already outlined above

### Task 4: Assess whether the obtained scraped data contains any missing values ###

# Check for missing values
missing_values <- sum(is.na(final_data))

### Task 5: Showcase the total count of missing values present in the scraped dataset ###
print(paste("Total count of missing values:", missing_values))

### Task 6: Compute the percentage of missing values in the acquired web data ###
total_observations <- nrow(final_data)
percentage_missing <- (missing_values / total_observations) * 100

print(paste("Percentage of missing values:", percentage_missing, "%"))

### Task 7: Eliminate observations that include missing values from the dataset ###
final_data_clean <- na.omit(final_data)

### Task 8: Remove variables that exhibit missing values from the dataset ###

# Identify variables with missing values
vars_with_missing <- names(final_data)[apply(final_data, 2, function(x) any(is.na(x)))]

# Remove variables with missing values
final_data_clean <- final_data %>% select(-vars_with_missing)

### Task 9: Populate missing values in quantitative variables with a constant value of 1000 ###

# Replace missing values in quantitative variables with 1000
final_data_imputed <- final_data
quantitative_vars <- names(final_data) %>% keep(~ is.numeric(final_data[[.]]))
final_data_imputed[quantitative_vars][is.na(final_data_imputed[quantitative_vars])] <- 1000

### Task 10: Apply imputation techniques to introduce at least three values for missing data 
### in all available categorical variables ###

# Impute missing values in categorical variables with mode
impute_mode <- function(x) {
  if (is.numeric(x)) {
    x
  } else {
    mode(x)
  }
}

final_data_imputed <- final_data %>% 
  mutate(across(where(is.character), ~ifelse(is.na(.), impute_mode(.), .)))

# Display the cleaned and imputed dataset
print("Cleaned Dataset:")
print(final_data_clean)

print("Imputed Dataset:")
print(final_data_imputed)

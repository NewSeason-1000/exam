
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("ggplot2")

library(dplyr)
library(tidyr)
library(ggplot2)

# Creating TV data
tv_data <- data.frame(
  Brand = c("Samsung", "Sony", "LG", "Toshiba", "Panasonic", "Vu", "Mi"),
  Model = c("QLED Q90R", "X950G", "OLED C9", "VW 80cm", "VIERA OLED GZ2000", "OLS 72cm", "Mi TV 4 100 cm"),
  Price = c(35000, 32000, 54000, 41000, 50000, 36000, 490),
  Rate = c(4, 5, 4, 3, 2, 1, 1)
)

# Smoothing TV Price attribute
equal_freq_bins <- cut(tv_data$Price, breaks = 2)
bin_means <- tapply(tv_data$Price, equal_freq_bins, mean)
bin_boundaries <- levels(equal_freq_bins)
outliers <- boxplot.stats(tv_data$Price)$out

# Generalizing the rating attribute
tv_data$Rating_Category <- cut(tv_data$Rate, breaks = c(0, 2, 4, 5), labels = c("Low", "Average", "High"))

# Normalizing the price attribute
min_price <- min(tv_data$Price)
max_price <- max(tv_data$Price)
tv_data$Normalized_Price <- (tv_data$Price - min_price) / (max_price - min_price)

# Identifying noise
noise <- which(tv_data$Normalized_Price <= 0.1 | tv_data$Normalized_Price >= 0.9)

# Printing results
cat("Equal Frequency Bins:\n")
print(data.frame(Bin = as.character(bin_boundaries), Mean = bin_means))
cat("Outliers:\n")
print(outliers)
cat("Generalized Rating Categories:\n")
print(tv_data$Rating_Category)
cat("Normalized Prices:\n")
print(tv_data$Normalized_Price)
cat("Noise:\n")
print(tv_data[noise, ])

# Creating student data
student_data <- data.frame(
  Gender = c("Female", "Female", "Female", "Male", "Male", "Female", "Female", "Male", "Male", "Female"),
  Race_Ethnicity = c("Group B", "Group C", "Group B", "Group A", "Group C", "Group B", "Group B", "Group B", "Group D", "Group B"),
  Parental_Level_of_Education = c("Bachelor's Degree", "Some College", "Master's Degree", "Associate's Degree", "Some College", "Associate's Degree", "Some College", "Some College", "High School", "High School"),
  Lunch = c("Standard", "Standard", "Standard", "Free/Reduced", "Standard", "Standard", "Standard", "Free/Reduced", "Free/Reduced", "Free/Reduced"),
  Test_Preparation_Course = c("None", "Completed", "None", "None", "None", "None", "Completed", "None", "Completed", "None"),
  Math_Score = c(72, 69, 90, 47, 76, 71, 88, 40, 64, 38),
  Reading_Score = c(72, 90, 95, 57, 78, 83, 95, 43, 64, 60),
  Writing_Score = c(74, 88, 93, 44, 75, 78, 92, 39, 67, 50)
)

# Pivot table creation
pivot_data <- student_data %>%
  pivot_longer(cols = -c(Gender, Race_Ethnicity, Parental_Level_of_Education, Lunch, Test_Preparation_Course),
               names_to = "Subject",
               values_to = "Score") %>%
  pivot_wider(names_from = Gender, values_from = Score, names_prefix = "Gender_")

# One-hot encoding
one_hot_encoded_data <- pivot_data %>%
  mutate_if(is.character, as.factor) %>%
  mutate_at(vars(-starts_with("Gender")), ~as.numeric(!is.na(.)))

# Printing encoded data
print(one_hot_encoded_data)

# Variance calculation
math_var_original <- var(student_data$Math_Score)
student_data$Math_Score <- student_data$Math_Score * 2
math_var_modified <- var(student_data$Math_Score)
cat("Original Variance of Math Scores:", math_var_original, "\n")
cat("Modified Variance of Math Scores after multiplication by 2:", math_var_modified, "\n")
cat("The variance increases by a factor of 4 due to the multiplication by 2.\n")

# Statistical analysis of responses
responses <- c(1, 1, 0, 1, 2, 2, 0, 0, 0, 3, 3, 0, 3, 3, 0, 2, 2, 2, 1, 1, 4, 1, 1, 0, 3, 0, 0, 0, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1,
               4, 4, 4, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 3, 3, 0, 3, 3, 1, 1, 1, 1, 0, 0, 1,
               1, 1, 1, 3, 3, 3, 2, 3, 3, 1, 1, 1, 2, 2, 2, 4, 5, 5, 4, 4, 1, 1, 1, 4, 1, 1, 1, 3, 3, 5, 3, 3, 3, 2, 3, 3, 0,
               0, 0, 0, 3, 3, 3, 3, 3, 3, 0, 2, 2, 2, 2, 1, 1, 1, 3, 1, 0, 0, 0, 1, 1, 3, 1, 1, 1, 2, 2, 2, 4, 2, 2, 2, 1, 1,
               1, 1, 0, 0, 2, 2, 3, 3, 2, 2, 3, 2, 0, 0, 1, 1, 3, 3, 3, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 0, 1, 1, 1, 3,
               1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 1, 1, 1, 3, 3, 5, 3, 3, 1, 1, 1, 3, 3, 3, 3, 1, 1, 1, 4, 1, 1, 4, 4, 4, 4, 4, 4,
               1, 1, 1, 2, 2, 5, 5, 2, 3, 3, 4, 4, 3, 2, 2, 2, 1, 5, 1, 2, 2, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 0, 1, 1, 1, 3, 3, 3,
               3, 3)
mean_response <- mean(responses)
cat("Mean:", mean_response, "\n")
median_response <- median(responses)
cat("Median:", median_response, "\n")
mode_response <- names(sort(table(responses), decreasing = TRUE))[1]
cat("Mode:", mode_response, "\n")

# Magazine pages data
pages <- c(156, 120, 172, 180, 205, 215, 217, 218, 232, 234, 240, 255, 270, 275, 290, 301, 303,
           315, 317, 318, 326, 333, 343, 349, 360, 369, 377, 388, 391, 392, 398, 400, 402, 405, 408,
           422, 429, 450, 475, 512, 121, 132, 151, 122, 120, 111, 111, 112, 115, 119)
summary_stats <- summary(pages)
print(summary_stats)

Q1 <- quantile(pages, 0.25)
Q3 <- quantile(pages, 0.75)
IQR <- Q3 - Q1

boxplot(pages, main="Number of Pages in Magazines", ylab="Number of Pages")
boxplot(pages, main="Number of Pages in Magazines", ylab="Number of Pages", outline=TRUE)

# Creating example data for demonstration
student_data <- data.frame(
  Reading_Score = c(72, 90, 95, 57, 78, 83, 95, 43, 64, 60),
  Writing_Score = c(74, 88, 93, 44, 75, 78, 92, 39, 67, 50)
)

# Printing the created dataset
print(student_data)

# Generating scatter plot
ggplot(student_data, aes(x = Reading_Score, y = Writing_Score)) +
  geom_point() +
  labs(x = "Reading Score", y = "Writing Score", title = "Scatter Plot of Reading vs Writing Score")


# Write tv_data to data.csv file
write.csv(tv_data, file = "data.csv", row.names = FALSE)
cat("Data has been written to data.csv file.\n")

# Read data.csv file
read_tv_data <- read.csv("data.csv")

# Print the contents of the read dataframe
print(read_tv_data)

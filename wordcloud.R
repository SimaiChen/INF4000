library(quanteda)
library(ggplot2)
library(RColorBrewer)
library(quanteda.textstats)
library(quanteda.textplots)

# read data
news_data <- read.csv("MN-DS-news-classification.csv", stringsAsFactors = FALSE)

# Extract the ‘content’ column and remove the NA value
text_data <- news_data$content
text_data <- na.omit(text_data)  

# Creating a corpus
corpus <- corpus(text_data)

# clean data
tokens <- tokens(corpus, 
                 remove_punct = TRUE,   
                 remove_numbers = TRUE, 
                 remove_symbols = TRUE) 
tokens <- tokens_tolower(tokens)

# customize stop words
custom_stopwords <- c("said", "people", "one", "also", "can", "new", "us", 
                      "time", "years", "like", "now", "just", "two", "even", 
                      "last", "year", "many", "first", "says", "may", "it’s", 
                      "according", "get", "told", "including", "make", "since", 
                      "day", "way", "take", "much", "made", "$", "well", 
                      "health", "will", "per", "still", "three","back","around","see","say","want",
                      "public","world","going","news","best","place","office","long","end","go",
                      "think","help","another","come","every","good","set","mr","used","less")

# remove stop words
tokens <- tokens_remove(tokens, pattern = c(stopwords("en"), custom_stopwords))

# creat DFM
dfm_mat <- dfm(tokens)

# count frequency
word_freq <- textstat_frequency(dfm_mat)

# creat word cloud
textplot_wordcloud(dfm_mat, 
                   max_words = 200, 
                   color = brewer.pal(8, "Dark2"))


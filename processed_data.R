library(tidyverse)
library(lubridate)

# read dataset
data <- read.csv("MN-DS-news-classification.csv")

# Convert date to date format
data$date <- as.Date(data$date, format = "%Y-%m-%d")

# Add month field for time analysis
data <- data %>%
  mutate(month = floor_date(date, "month"))

# Save processed data to RDS file
saveRDS(data, file = "processed_data.rds")
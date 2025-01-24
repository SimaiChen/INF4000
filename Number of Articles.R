library(ggplot2)
library(dplyr)
library(readr)

# read data
df <- read_csv("MN-DS-news-classification.csv")

# Count and sort the number of articles in each level of classification
category_counts <- df %>%
  count(category_level_1) %>%
  arrange(n)

# Plotting horizontal bar charts
ggplot(category_counts, aes(
  x = reorder(category_level_1, n),
  y = n,
  fill = n
)) +
  geom_bar(stat = "identity") +  
  coord_flip() +  
  scale_fill_gradient(low = "darkblue", high = "yellowgreen") +  
  geom_text(
    aes(label = n),
    hjust = -0.2,
    size = 4,
    color = "black"
  ) +  
  labs(title = "Number of Articles per Primary Category", x = "Number of Articles", y = "Primary Category") +
  theme_minimal() +  
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text.y = element_text(size = 12),
    axis.text.x = element_text(size = 10),
    axis.title.y = element_text(size = 14),
    axis.title.x = element_text(size = 14),
    panel.grid.major.x = element_line(color = "grey80", linetype = "dashed"),
    panel.grid.major.y = element_blank(),
    legend.position = "none"  
  )
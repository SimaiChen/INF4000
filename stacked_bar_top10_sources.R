library(ggplot2)
library(dplyr)
library(readr)
library(RColorBrewer)

# read data
df <- read_csv("MN-DS-news-classification.csv")

# Count the number of articles per news source and filter the top 10 sources
top_sources <- df %>%
  group_by(source) %>%
  summarise(total_articles = n()) %>%
  arrange(desc(total_articles)) %>%
  top_n(10, total_articles) %>%
  pull(source)

# Only data from the top 10 sources are retained
filtered_data <- df %>%
  filter(source %in% top_sources)

# Number of articles by source and first level of classification
source_category_counts <- filtered_data %>%
  group_by(source, category_level_1) %>%
  summarise(article_count = n(), .groups = 'drop')

# Generate gradient tones
num_categories <- length(unique(source_category_counts$category_level_1))
gradient_colors <- colorRampPalette(brewer.pal(9, "Spectral"))(num_categories)

# Plotting stacked bar charts
ggplot(source_category_counts, aes(x = reorder(source, -article_count), 
                                   y = article_count, 
                                   fill = category_level_1)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = gradient_colors) +  
  labs(title = "Stacked Bar Chart of Top 10 News Sources",
       subtitle = "Based on 2019 news data",
       x = "News Sources",
       y = "Number of Articles",
       fill = "News Categories") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold"),
    legend.position = "top"
  ) +
  guides(fill = guide_legend(nrow = 2))

# Save the chart
ggsave("stacked_bar_top10_sources.png", width = 12, height = 6)

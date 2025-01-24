library(tidyverse)
library(lubridate)
library(viridis)

# read data
data <- readRDS("processed_data.rds")

# Count the number of articles per news source and filter the top 10 sources
top_categories <- data %>%
  group_by(category_level_1) %>%
  summarise(total_articles = n()) %>%
  arrange(desc(total_articles)) %>%
  top_n(10, total_articles) %>%
  pull(category_level_1)

# Only data from the top 10 sources are retained
filtered_data <- data %>%
  filter(category_level_1 %in% top_categories)

# Number of articles in the top 10 categories by month
category_trends <- filtered_data %>%
  group_by(month, category_level_1) %>%
  summarise(article_count = n(), .groups = 'drop')

# Generate gradient tones
gradient_colors <- viridis_pal(option = "D")(length(unique(category_trends$category_level_1)))

# Plotting trends in the top 10 news categories over time
ggplot(category_trends, aes(x = month, y = article_count, color = category_level_1, group = category_level_1)) +
  geom_line(linewidth = 1.2) +  
  geom_point(size = 2) +   
  labs(title = "Time trend analysis of the top 10 news categories",
       subtitle = "Based on 2019 news data",
       x = "Date",
       y = "Number of articles",
       color = "Category") +
  scale_x_date(date_breaks = "2 months", date_labels = "%b %Y") +  
  scale_color_manual(values = gradient_colors) +  
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major = element_line(color = "gray90", linewidth = 0.5),  
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )

# save the chart
ggsave("top10_category_trends.png", width = 12, height = 6)


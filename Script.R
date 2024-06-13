#### Wikipedia

# https://wikimedia.org/api/rest_v1/#/Pageviews%20data

library(here)
library(httr)
library(jsonlite)
library(tidyverse)
library(scales)
library(grid)
library(ggpubr)
options(scipen = 999)
italian <- GET('https://wikimedia.org/api/rest_v1/metrics/pageviews/aggregate/it.wikipedia/all-access/all-agents/monthly/2013072700/2024061200')
json_result <- content(italian, "text", encoding="UTF-8")
italian_wiki <-jsonlite::fromJSON(txt = json_result, flatten = TRUE)
str(italian_wiki$items)
italian_wiki <- as.data.frame(italian_wiki$items)


class(italian_wiki$views)
class(italian_wiki$timestamp)
as.integer(italian_wiki$timestamp[1])
options(scipen = 999)

italian_wiki$testing <- gsub("00$", "", italian_wiki$timestamp)
italian_wiki$testing  <- gsub("(\\d{4})(\\d{2})", "\\1-\\2-", italian_wiki$testing )
italian_wiki$testing <- as.Date(italian_wiki$testing)



ggplot(italian_wiki, aes(x = testing, y = views)) +
  geom_line(color="darkgreen") +
  scale_x_date(date_breaks = "3 months",
               date_labels = "%y-%m")+
  xlab("Year-Month")+
  ylab("Views")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
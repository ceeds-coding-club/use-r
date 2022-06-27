library(tidyverse)
theme_set(theme_bw())

## gdp example
# https://towardsdatascience.com/create-animated-bar-charts-using-r-31d09e5841da
gdp_tidy<-read.csv('extending_ggplot/gdp_tidy.csv') 

gdp <- gdp_tidy %>%
  group_by(year) %>%
  mutate(rank = rank(-value),
         Value_rel = value/value[rank==1],
         Value_lbl = paste0(" ",round(value/1e9))) %>%
  group_by(country_name) %>% 
  filter(rank <=20) %>%
  ungroup() %>% filter(year > 2000) %>% mutate(year = as.factor(year))

## flip and wrap, flip and wrap
g1<-ggplot(gdp, aes(country_name, value, fill=year)) + geom_bar(stat='identity')
g1
g1 + coord_flip() 
g1 + coord_flip() + facet_wrap(~year)

## save figures to pdf
pdf(file = 'extending_ggplot/gdp_figure.pdf', height=7 , width=7)
g1 + coord_flip() + facet_wrap(~year)
dev.off()
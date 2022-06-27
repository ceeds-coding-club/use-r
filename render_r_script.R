#' ---
#' title: "Render This R Script"
#' author: "James"
#' date: "May 5, 2021"
#' output: github_document
#' ---

#+ r setup, include = FALSE
library(palmerpenguins)
library(tidyverse)

#'Penguins penguins penguins  
#'This is just another R script  
#+ r summary, echo = FALSE
print(paste('There are ', n_distinct(penguins$species), 'penguin species:'))
print(levels(penguins$species))

#+ figure1, warning = FALSE, message = FALSE
ggplot(penguins, aes(bill_length_mm, bill_depth_mm, col=species)) +
  geom_point() +
  stat_smooth(method='lm')

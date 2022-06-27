# demo my pairs2 function

library(tidyverse)
library(palmerpenguins) ## load example dataset on penguin stuff
source('pairs_function/pairs2.R') ## load functions, adapted from https://gist.github.com/jfroeschke/a7a900b41c7348b3c0b30a36766223e5

data(penguins)
## extract all numeric variables
penguin_nums<-penguins %>% select_if(is.numeric) %>% na.omit()

## show base R pairs
pairs(penguin_nums)
?pairs

## now the pairs2 function, shows correlations and smoother, coloured for strong associations
pairs2(penguin_nums, lower.panel = panel.smooth2, upper.panel = panel.cor)

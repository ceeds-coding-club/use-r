
## Functions demo
## James Robinson
## 3rd Feb 2021 - LEC use-r group


## You can save functions in their own R script, then load into your workspace (use relative file paths and Rproject files!)


## Function 1 = standard error   ##

source('standard_error_func.R')  ## load the se function (also below)

# 
# se<-function(x){
#   sd(x)/sqrt(length(x)) ## estimate the sd of the input 'x', divided by the square root of N (= length(x))
# }

## generate 100 random numbers
numbers<-rnorm(100, mean = 10, sd = 5)

## estimate the standard error of the numbers object
se(x=numbers)

##  Function 2 = plotting   ##

plotter<-function(x,  point){
    y <- x ^ 1.5  ## create y values ( = x to power 1.5)
    plot(x, y, col='red', pch = point) ## plot x and y, colour things red, pch is defined in plotter as 'point;
}

## run plotter on the 'numbers' vector. set point = 3, giving pch = 3
plotter(x = numbers, point = 3)


## 3. how to apply your function to data subsets
library(tidyverse) ## for dplyr functions
library(palmerpenguins) ## load example dataset on penguin stuff
head(penguins)

## estimate the mean and standard error of the bill length of each penguin species
penguins %>% 
      na.omit() %>%  ## drop NAs from the dataset
      group_by(species) %>%  ## split dataset into each species
      summarise(se_bill = se(bill_length_mm), mean_bill = mean(bill_length_mm)) ## calculate summary statistics per species


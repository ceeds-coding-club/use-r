
## Loops demo
## James Robinson
## 17th Feb 2021 - LEC use-r group

## 1. basic loop

## loops increase an object (usually i) over a set range of numbers, repeating the code inside the loop
for(i in 1:10){
	print(i)
}

for(i in 1:10){
	print(letters[i])
}

## another iterating option is 'repeat', which just keeps going until you it meets a condition to stop ('break')
i=1
repeat{
	i<-i + 1
	print(letters[i])
	if(i == 26) {break}
}

## Good info and examples on the syntax and purpose of using loops: https://r4ds.had.co.nz/iteration.html

## 2. looping plots
library(tidyverse)
library(palmerpenguins) ## load example dataset on penguin stuff
head(penguins)

# you might want to loop over a dataset, producing the same plot each time.
## let's plot length - weight relationships for each species
species<-unique(penguins$species) ## 

pdf(file = 'intro-to-loops/penguins_looped.pdf')
for(i in 1:length(species)){
	print(paste('Plotting for', species[i]))
	subdat<-penguins[penguins$species == species[i],]
	plot(subdat$bill_length_mm, subdat$body_mass_g, col=subdat$sex)
}
dev.off()

## ggplot has options to do this kind of thing already
ggplot(penguins, aes(bill_length_mm, body_mass_g, col=sex)) +
		geom_point() +
		facet_wrap(~species)



## the purrr package is an alternative to looping in the tidyverse
# https://purrr.tidyverse.org/

library(purrr)

## split penguins by species, fit a linear model, extract r-squared
penguins %>%
  split(.$species) %>% # from base R
  map(~ lm(bill_length_mm ~ body_mass_g, data = .)) %>%
  map(summary) %>%
  map_dbl("r.squared")

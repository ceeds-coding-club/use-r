#Demo Linear mixed-effect models
#LEC Coding Group - November 17
#Eva Maire - e.maire@lancaster.ac.uk
########################################

#Load libraries
library(tidyverse)
library(lme4)

# install.packages("remotes")
#remotes::install_github("allisonhorst/palmerpenguins")
library(palmerpenguins)

#Load data and take a look 
data(penguins)
penguins<-na.omit(penguins)
summary(penguins) #dataset contains data for 344 penguins. 
#There are 3 different species of penguins in this dataset, collected from 3 islands in the Palmer Archipelago, Antarctica.

#Relationship between body mass and flipper length
#hypotheses: linear growth? Better propulsion allows better feeding and body condition? 
ggplot(penguins, aes(flipper_length_mm,body_mass_g)) +
  geom_point() +
  geom_smooth(method = "lm")

lm1 <- lm(body_mass_g ~ flipper_length_mm, data = penguins)
summary(lm1)

plot(lm1)  
# clearly not perfect
# the red line should be nearly flat
# some extreme points, but that's often the case
# but not too bad

boxplot(body_mass_g ~ island, data = penguins)  # Something is going on here

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, colour = island)) +
  geom_point(size = 2) +
  theme_classic() #it looks like the island ranges vary both in the penguins flipper length AND in their body mass

#Split plots with the facet_wrap
ggplot(aes(flipper_length_mm, body_mass_g), data = penguins) + 
  geom_point() + 
  facet_wrap(~ island) + # create a facet for each island range
  xlab("Flipper length") + 
  ylab("Body mass")

island.lm <- lm(body_mass_g ~ flipper_length_mm + island , data = penguins)
summary(island.lm)

island.lm.2 <- lm(body_mass_g ~ flipper_length_mm + island -1, data = penguins) #see Sam's previous demo
summary(island.lm.2)
#BUT we are not interested in quantifying the body mass for each specific island
#We want to know if flipper length affects the body mass while controlling for the variation coming from islands => USE MIXED EFFECT MODELS

#############################################################
#Mixed effect models
#Fixed vs random effects
#It is important to note that this difference has little to do with the variables themselves, and a lot to do with your research question
#In many cases, the same variable could be considered either a random or a fixed effect so always think about your questions, hypotheses and the theory to construct your models

#Fixed effects are variables that are expected to have an effect on the response/dependent variable in a standard linear regression => explanatory variables
#In our case, we want to make conclusions about how flipper length (fixed effect) affects the penguins' body mass (response/dependent variable)

#Random effects are usually grouping factors for which we are trying to control. They are ALWAYS categorical!
#Often, we are not specifically interested in their impact on the response variable, but we know that they might be influencing the patterns we see.

mixed.lmer <- lmer(body_mass_g ~ flipper_length_mm + (1|island), data = penguins)
summary(mixed.lmer)

#the 'random effects' part tells you how much variance is explained by the grouping factor + the residual variance
#the 'fixed effects' part is similar to the linear model output: intercept, error, slope estimate and error

17804/(17804 + 145196)  # ~11 % (the variance for the island divided by the total variance)
#the variance for island = 17804
#Islands are somehow important

plot(mixed.lmer)  # looks alright, no patterns evident
qqnorm(resid(mixed.lmer))
qqline(resid(mixed.lmer))  # points fall quite nicely onto the line - acceptable

#Other/better options?
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, colour = species)) +
  geom_point() +
  theme_classic() #species also seems important

mixed.lmer.sp <- lmer(body_mass_g ~ flipper_length_mm + (1|species), data = penguins)
summary(mixed.lmer.sp)
qqnorm(resid(mixed.lmer.sp))
qqline(resid(mixed.lmer.sp))

55749/(55749 + 139351)  # ~29 %

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, colour = species)) +
  facet_wrap(~species, nrow=2) +   # a panel for each island range
  geom_point(alpha = 0.5) +
  theme_classic() +
  geom_line(data = cbind(penguins, pred = predict(mixed.lmer.sp)), aes(y = pred), size = 1) +  # adding predicted line from mixed model 
  theme(legend.position = "none",
        panel.spacing = unit(2, "lines"))
        
#All the lines (linear relationships) are parallel - Because we have only fitted random-intercept models
#A random-intercept model allows the intercept to vary for each level of the random effects,but keeps the slope constant among them. 

#Using this model means that we expect penguins in all islands to exhibit the same relationship between body length and flipper length (fixed slope), 
# although we acknowledge that some populations, depending on the islands, may have slightly better or worse body condition to start with (random intercept)

#BUT in the real life, we maybe assume that not all populations would show the exact same relationship and 
# we want to fit a random-slope and random-intercept model: example: (1 + flipper_length_mm|species)

#Additional comments:
#Nested random effects can be useful: leafLength ~ treatment + (1|tree/leaf)

#Excellent viz: https://mfviz.com/hierarchical-models/

#It is good practice to standardise your explanatory variables before proceeding so that they have a mean of zero (“centering”) and standard deviation of one (“scaling”)
#It ensures that the estimated coefficients are all on the same scale, making it easier to compare effect sizes. Use scale().

#Note there is no golden rule BUT you generally want your random effect to have at least five levels, because estimating variance on few points is very imprecise!
#For example, sex (a two level factor: male or female) as a fixed, not random effect.

#Keep in mind that the name 'random' doesn’t mean mathematical randomness (Yes, it’s confusing)
#See random effects as the grouping variables which allow for more representative models and better estimates

#Thank you!





## load penguin dataset from palmerpenguins
# https://www.r-bloggers.com/2020/06/penguins-dataset-overview-iris-alternative-in-r/
library(palmerpenguins)


## Figure 1 = penguin correlations
pdf(file = 'markdown-demo/Figure_S1.pdf', height=7, width=9)
plot(penguins)
dev.off()

## Figure 2 = penguin sizes
library(tidyverse)
gg2<-ggplot(data = penguins,
       aes(x = flipper_length_mm,
           y = body_mass_g)) +
  geom_point(aes(color = species,
                 shape = species),
             size = 3,
             alpha = 0.8) +
  scale_color_manual(values = c("darkorange","purple","cyan4")) +
  labs(title = "Penguin size, Palmer Station LTER",
       subtitle = "Flipper length and body mass for Adelie, Chinstrap and Gentoo Penguins",
       x = "Flipper length (mm)",
       y = "Body mass (g)",
       color = "Penguin species",
       shape = "Penguin species") +
  theme_minimal()


pdf(file = 'markdown-demo/Figure_S2.pdf', height=7, width=9)
gg2
dev.off()



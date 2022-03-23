
## Extending ggplot - James Robinson, LEC-R, 14th Apr 2021


## package + data load
library(tidyverse)
library(palmerpenguins) ## load example dataset on penguin stuff
data(penguins)
penguins<-na.omit(penguins)

## default plot
g1<-ggplot(penguins, aes(bill_length_mm, bill_depth_mm, col=species)) +
      geom_point() +
      stat_smooth(method='lm')
g1

## 1. pick your colours wisely

## use **complementary** & **colourblind-friendly** palettes
library(RColorBrewer) # https://colorbrewer2.org/
g1 + scale_colour_brewer(palette= 'Set2')

## create a named vector for your colours
# https://paletton.com/
mycols<-c('Adelie' = '#1f78b4', 'Chinstrap' = '#33a02c', 'Gentoo' = '#ff7f00')
g1 + scale_colour_manual(values = mycols)

## 2. a publication quality ggplot should dig into the theme() elements

## pre-loaded themes
library(ggthemes)
g1 + theme_minimal()
g1 + theme_bw()
g1 + theme_economist()
g1 + theme_fivethirtyeight()

## what's in a theme?
theme_bw()

## set theme elements manually
g1 + theme(axis.text = element_text(colour='grey10', size=12),
           axis.title = element_text(colour='grey10', size=14))

g1 + theme(panel.background = element_rect(fill=NA),
           axis.line = element_line(colour='black'))

## save a theme object, source it, and apply to all of your manuscript figures
th<-theme_bw() + theme(axis.text = element_text(colour='grey10', size=12),
                       axis.title = element_text(colour='grey10', size=14))
g1 + th

source('my_ggplot_theme.R')
g1 + theme_sleek()


## 3. Annotate, if possible
my_label<-data.frame(species = unique(penguins$species),
                     bill_length_mm = c(35, 53, 57),
                     bill_depth_mm = c(15.2, 14, 21.5))
g1 + theme_sleek() + 
    geom_text(data = my_label, aes(label = species), hjust=0.5, vjust=0.5, size=5, fontface='bold') +
    theme(legend.position = 'none')

## use ggrepel::geom_text_repel() for overlapping labels
# https://cran.r-project.org/web/packages/ggrepel/vignettes/ggrepel.html


## 4. cowplot or patchwork for multipanel figures
library(cowplot)

g2<-g1 + theme_sleek() + 
  geom_text(data = my_label, aes(label = species), hjust=0.5, vjust=0.5, size=5, fontface='bold') +
  theme(legend.position = 'none')

plot_grid(g1, g2, labels = c('A', "B"), nrow=1)

library(patchwork)
g1 + g2 + plot_annotation(tag_levels = 'I')
g1 / g2 + plot_annotation(tag_levels = 'I')


## ggplot themes - James Robinson, CEEDS use-R, 23 Feb 2022

## package + data load
library(tidyverse)


# for a publication quality ggplot you need to dig into the theme() elements

## our plot
data(msleep)
g1<-ggplot(msleep, aes(sleep_total, log10(bodywt), col=conservation, label=name)) + 
        geom_text() +
        labs(title='Sleep and body size of mammals')

## pre-loaded themes
library(ggthemes)
g1 + theme_minimal()
g1 + theme_bw()
g1 + theme_tufte(base_size=20) ## Data-Ink maximization: No border, no axis lines, no grids

## pub quality recommended by Claus Wilke
# https://wilkelab.org/cowplot/articles/themes.html
library(cowplot)
g1 + theme_half_open(18)
g1 + theme_half_open() + background_grid()

## Also check out the cowplot documentation for:
# 1. Mixing base and ggplot in multipanel plots
# 2. Inset plots and multipanel plots
# 3. Advanced annotations


## Themes have different arguments that let you set font, family, and other tricks
?theme_half_open
?theme_tufte


## so what's in a theme?
theme_bw()


## set theme elements manually
g1 + theme(axis.text = element_text(colour='grey10', size=12),
           axis.title = element_text(colour='grey10', size=18),
           axis.ticks=element_blank())

g1 + theme(panel.background = element_rect(fill=NA),
           axis.line = element_line(colour='black'))

## save a theme object, source it, and apply to all of your manuscript figures
th<-theme_bw() + theme(axis.text = element_text(colour='grey10', size=12),
                       axis.title = element_text(colour='grey10', size=14), 
                       legend.position = 'top')
g1 + th


## OR change the default theme for your whole session
theme_set(theme_half_open())
g1

## my theme, credit to https://github.com/seananderson/ggsidekick
source('my_ggplot_theme.R')
g1 + theme_sleek()


## There's more!
library(ggdark) ## dark versions of default ggplot themes
g1 + dark_theme_bw()
library(tidyverse)

## initial_tidy wrangles homoeolog triad data from the wheat expression browser 
## into a usable layout.
## it filters out roots, grain and any samples deriving from stress samples.
## x = df
## y = The gene name of the homoeolog triad

initial_tidy <- function(x, y='GeneName') {x %>%
    filter(FALSE == str_detect(High.level.tissue, 'roots')) %>%
    filter(FALSE == str_detect(High.level.tissue, 'grain')) %>% 
    filter(str_detect(Stress.disease, 'none'))  %>%
    pivot_wider(names_from = High.level.tissue, 
                values_from = 13:15) %>%
    mutate(Gene = y) %>%
    rename(A_leaves = 12) %>%
    rename(A_spike = 13) %>%
    rename(B_leaves = 14) %>%
    rename(B_spike = 15) %>%
    rename(D_leaves = 16)%>%
    rename(D_spike = 17) %>%
    select("Gene", "A_leaves", "A_spike", "B_leaves",
           "B_spike", "D_leaves", "D_spike")
}
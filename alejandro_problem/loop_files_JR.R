library(readxl)
library(tidyverse)
library(janitor)

## identify dataset location and count number of sheets to read
filename<-'alejandro_problem/exp_3_Quantified.xlsx'
sheets<-excel_sheets(filename) ## 23 sheets, 1st is a key

# set up empty objects for storing results
standard<-numeric()
sample<-numeric()

## loop through each sheet, clean, extract and save (ignore sheet = 1)
for(i in 2:length(sheets)){
  # i=2 ## debugger
  dat<-read_excel(filename, sheet = i) %>% ## read sheet i (2-23)
        clean_names() %>%  ## clean column headers to lower case (janitor package)
        mutate(protein = rep(c('protein1','protein2'), each = 14),
               sample_type = rep(c(rep('standard',5), rep('sample', 9)), times = 2),
               file = sheets[i]) ## add identifiers for proteins, sample types and file sheet
  
  # split standard and sample and bind with previous results
  standard<-rbind(standard, dat %>% filter(sample_type =='standard'))
  sample<-rbind(sample, dat %>% filter(sample_type =='sample'))
}

dim(standard) ## 230 = 5*2*22
dim(sample) ## 396 = 9*2*22
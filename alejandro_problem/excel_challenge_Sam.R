
#process JAP spreadsheet
##############################
#Instructions
# 1. Dataset is exp_3_Quantified.xlsx
# 2. Read in the first Image sheet (ie ignore Labels).
#    Each Image sheet has a header and 28 rows of data.
#    28 rows represent two proteins
#    (protein 1 = rows 1-14 and protein 2 = 15-28).
#    Each protein has five standard values followed by nine sample values.
# 3. Label each protein (1 and 2) with a new variable
# 4. Save the standards and samples as separate datasets.
# 5. Repeat for each Image sheet, and bind everything together.

library(readxl)
library(here)
library(tidyverse)

excel_sheets(here("exp_3_Quantified.xlsx"))

pull_protein <- function(sheet, book){
  s1 <- read_xlsx(book, sheet)
  
  s1 %>%
    mutate(protein = c(rep("p1", 14), rep("p2", 14)),
           sample_standard = rep(c(rep("standard", 5), rep("sample", 9)), 2),
           id = paste0(sub(" ", "_", sheet), s1$protein, s1$sample_standard)
    )
  
}

sn <- excel_sheets(here("exp_3_Quantified.xlsx"))
use_sn <- sn[grep("Image", sn)]

JAP_list <- lapply(use_sn,
                   pull_protein,
                   book = here("exp_3_Quantified.xlsx")
)

JAP_tble <- do.call(rbind, JAP_list)                 

################################################################
#extended version
#codes from "Labels" are incorporated
################################################################

JAP_label <- read_xlsx(here("exp_3_Quantified.xlsx"), "Labels")
head(JAP_label)
JAP_curve <- select(JAP_label, Image:...7)
JAP_samples <- select(JAP_label, Image, Samples:...16)

pull_protein2 <- function(sheet, book, curves, samples){
  ds <- read_xlsx(book, sheet)
  
  crv <- curves %>%
    filter(Image == str_match(sheet, "\\s([0-9]+)_")[ , 2]) %>%
    select(!Image)
  
  smp <- samples %>%
    filter(Image == str_match(sheet, "\\s([0-9]+)_")[ , 2]) %>%
    select(!Image)
  
  ds %>%
    mutate(protein = c(rep("p1", 14), rep("p2", 14)),
           'Conc. Std.' = rep(c(rep(TRUE, 5), rep(FALSE, 9)), 2),
           Concentration = as.numeric(rep(c(crv, rep(NA, 9)), 2)),
           sample = rep(c(rep(NA, 5), as.character(smp)), 2),
           id = paste(str_replace(sheet, " ", "_"),
                      protein,
                      'Conc. Std.',
                      Concentration,
                      sep ="_"
           )
    ) %>%
    rename(Image_Name = 'Image Name',
           Conc_Std = 'Conc. Std.'
    )
}

JAP_list_label <- lapply(use_sn,
                         pull_protein2,
                         book = here("exp_3_Quantified.xlsx"),
                         curves = JAP_curve,
                         samples = JAP_samples
)

JAP_tble_label <- do.call(rbind, JAP_list_label)

JAP_tble_label %>%
  ggplot(aes(Concentration, Signal, colour = protein)) +
  geom_point() +
  facet_wrap(~ Image_Name)
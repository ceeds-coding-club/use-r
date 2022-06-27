###########################################################

standards1 <- c()

samples1 <- c()

 

for(i in 2:length(excel_sheets("./exp_3_Quantified.xlsx"))){

  exercise <- read_excel(".//exp_3_Quantified.xlsx",sheet=i,n_max=28,col_names=T)

 

    exercise %>%

      mutate(protein = c(rep(1,14),rep(2,14)))

    standards <- exercise %>%

        slice(1:5,15:19)

          standards1 <- bind_rows(standards1,standards)

 

    samples <- exercise %>%

      slice(6:14,20:28)

          samples1 <- bind_rows(samples1,samples)

  }

 

standards1 ; samples1

 

#############################################################
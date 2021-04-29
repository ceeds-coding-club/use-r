#' ---
#' title: "Markdown in .R"
#' author: "LBE"  
#' date: "`r format(Sys.time(), '%d %B, %Y')`"
#' output: github_document
#' ---
#' 
#' *Using markdown language in .R files instead of Markdown/notebooks*
#' 
#' ## Why Markdown? 
#' - git
#' - reproducability / transparency
#' - legacy
#'
#' ## Why .R instead of .rmd?
#' 
#' *If you’re in analysis mode and want a report as a side effect, write an R script. If you’re writing a report with a lot of R code in it, write Rmd.*  
#' - .R code is top level, prose is second  
#' - .rmd prose is top level, code is second
#' 
#' ## How does it work?
#' Major difference: the roxygen comment `#'` 

# this reads as a normal commented text in a code chunk
#' this reads as text 
#' 
#' Code chunks can still be controlled using `#+`, so ````{r setup, include = FALSE}` becomes `#+ r setup, include = FALSE`
#' 
#' ### Formatting  
#' All the normal Markdown formatting works:    
#' - *italics*  
#' - **bold**  
#' 
#' # heading1
#' ## heading 2  
#' ### heading 3
#' 
 

#+ echo=F
# Rendering code  ----
#' ## Rendering code

#+ dotchart, echo=T 
summary(VADeaths)
dotchart(VADeaths, main = "Death Rates in Virginia - 1940")

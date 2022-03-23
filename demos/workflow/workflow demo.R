#' ---
#' title: Workflow demo - CEEDS useR group
#' author: LBE  
#' date: "Wed 19 Jan '22"
#' output: github_document
#' ---  


#+ message=FALSE, echo=F
# ***PLEASE NOTE:*** This `.R`-document is written using RMarkdown syntax, and reads best if it is knitted first. Press the notebook symbol above (Compile Report) to read as HTML instead of code (in a popup window).
library(tidyverse)

#' ### 1. Working with Projects
#' - Use self-contained Projects for each project
#' - Save all code in `.R` scripts, not in sessions/console
#' - Organise files following the structure: input, code, output
#+ echo=FALSE, out.width="30%", fig.cap="Structure of a typical R Project"
knitr::include_graphics("https://i1.wp.com/raw.githubusercontent.com/martinctc/blog/master/images/RPROJECT_2000dpi.png?w=578&ssl=1")

#' - Avoid the use of `setdw()` and `rm(list = ls())` at the start of scripts, as it builds in dependencies you might not be aware of 
#' - Project wd's should be set at the creation of a new project, restart RStudio often.
#' - Avoid the use of absolute file paths like the **plague!!**  
#' 
#' **Example:**
#+ message=FALSE, results=F, eval=F
absolute_data <- read_csv("/Users/bostrome/Documents/Work/R-Scripts/sandbox/activities.csv") #will only every work for you, on your current computer
relative_data <- read_csv("activities.csv") #will work for everyone you share data with (assuming you've shared the root folder with them)

#' 
#' #### Data analysis  *vs* modeling 
#' My **data analysis** projects tends to follow a similar format, and therefore the same structure:  
#' - Data wrangling/exploration (load packages > load data > clean data)  
#' - Plotting  
#' - Statistical analyses  
#' 
#' These can all fit in the same `.R` file without problem, and any outputs be saved to the WD.  
#'   
#' For more complex **modeling projects** I'm moving towards a modular approach that breaks apart the script into separate objects:  
#' - Parameters  
#' - Separate functions  
#' - Simulations (calls all other scripts within)
#'  
#' ### 2. Use templates  
#' - Ensures consistent style in code and scripts
#' - Reminds me to write clean code, well annotated
#' - Makes it easier to go back to old code if it contains the same sections
#' - Markdown session next week with Louis  
#' 
#' ### 3. Have a version control system in place  
#' - GitHub most common - James 3rd Feb
#' 
#' ### 4. Improve!
#' Instead of getting overwhelmed with style guides, markdown syntax, file organisation etc., I like to start with good *intentions* at the start of each new project (and Project), and assume that I will progressively improve, rather than expecting perfection from the start. 
#'  
#' For example, this year I'm aiming to learn how to use `.RData` files. They are data bundles that can contain multiple objects (like a folder), and are a great way to share data with others. 
#' 
#' **Resources:**  
#' - [Workflows in Rstudio](https://r4ds.had.co.nz/workflow-projects.html)  
#' - [Working dirs and file organsiation](https://www.r-bloggers.com/2020/01/rstudio-projects-and-working-directories-a-beginners-guide/)  
#' - [Structuring R projects](https://www.r-bloggers.com/2018/08/structuring-r-projects/)  
#' - [Why is using setdw() bad?](https://rstats.wtf/project-oriented-workflow.html)  
#' - [Tidyverse style guide](https://style.tidyverse.org)  
#' - [Always start RStudio with a blank slate](https://rstats.wtf/save-source.html#always-start-r-with-a-blank-slate)
#' - [Working with .RData files](https://bookdown.org/ndphillips/YaRrr/rdata-files.html)
#' 


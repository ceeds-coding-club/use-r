
library(rvest)
library(RSelenium)

url <- "https://www.timeanddate.com/astronomy/uk/kendal"
ht <- read_html(url)


driver <- rsDriver(browser=c("chrome"))
remote_driver <- driver[["client"]]
remote_driver$open()

remote_driver$navigate("https://www.timeanddate.com/sun/uk/kendal")

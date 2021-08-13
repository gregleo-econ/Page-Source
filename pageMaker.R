directory="c://webpage"
setwd(directory)
source("background.R")

style = paste(c(directory,"//style/style.css"),collapse="")
makePage(directory,style,"Greg Leo")


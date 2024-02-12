rm(list = ls())
library(XML)
library(RCurl)
link <- 'http://www.playoffstatus.com/ncaabasketball/ncaabasketballtournperformprob.html'
html <- getURL(link) #from RCurl
probs <- readHTMLTable(html)[[1]] #from XML
probs <- probs[2:nrow(probs),]
colnames(probs) <- c("Team","W","L",paste0("rd",7:1,"_win"))
datetime <- gsub('.*<div class=\"datetime\">\n\t\t','',html)
datetime <- gsub('\n\t</div>.*','',datetime)
datetime <- gsub('&#160;',' ',datetime)
probs$datetime <- datetime
probs$datetime_jb <- as.POSIXct(probs$datetime, format = "%a %b %e %I:%M %p")
datetime_char <- gsub(" ","_",probs$datetime_jb[1])
datetime_char <- gsub(":","_",datetime_char,fixed=T)
datetime_char <- gsub("-","_",datetime_char,fixed=T)
datetime_char <- paste0(datetime_char,".rds")
saveRDS(probs, file = datetime_char)

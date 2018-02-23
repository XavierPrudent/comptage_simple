#!/usr/bin/env Rscript

## Simple counts for line and stops
## Consider only a portion of Jan/Feb 2017 and average it to 1day

source("/Users/lavieestuntoucan/Civilia/tech/general/load_R_pkg.R")

##Input data
chipCards.sto <- "data/TransactionBusjuin2016Plus.CSV"
##
##Read chip cards
chipCards.sto <- fread(user.data$chipCards.sto)
##
## To data.table
setDT(chipCards.sto)
##
## Set to date
chipCards.sto$DateService <- as.Date(chipCards.sto$DateService)
##
## Filter date period
date1 <- as.Date("2017-01-09")
date2 <- as.Date("2017-02-26")
chipCards.sto <- chipCards.sto[ DateService >= date1 & 
                                  DateService <= date2 ]
##
## Filter week days
chipCards.sto$wdays <- weekdays(chipCards.sto$DateService)
chipCards.sto <- chipCards.sto[wdays %in% c("Tuesday","Wednesday","Thursday")]
##
## Create hours
chipCards.sto <- chipCards.sto %>% mutate(heure = as.numeric(str_sub(HeureTransaction,-6,-5)))


##Count
res<-count.boardings(chipCards.sto,user.data)

write.table(res$mat.n,"/Users/lavieestuntoucan/civ-sto/tech/comptage_simple/out/montees_n.csv",
row.names=T,col.names=NA,quote=F,sep=",")
write.table(res$mat.f,"/Users/lavieestuntoucan/civ-sto/tech/comptage_simple/out/montees_f.csv",
row.names=T,col.names=NA,quote=F,sep=",")

##Globalcount
n.days <- length(unique(chipCards.sto$DateService))

stops<-c(5014,5016,5025,5022,5024,5026,5030,5032,5034,5040,5042,5048,5050)
routes<-c(22,25,26,29,40,41,44,45,46,47,48,11,17,27,85,88,93,94,95,98,87,20,31,32,33,23,24,34,35,36,37,38,55,59,67,200,400,300)
chipCards.sto[NumArret %in% stops & NumLigne %in% routes ] %>% nrow() / n.days

routes<-c(11,17,22,23,24,25,26,27,29,31,32,33,34,35,36,37,38,40,41,44,45,46,47,55,59,67,87,85,82,94,98,93,95,300,400,200,20)
stops <- c(5048,5040,5032,5024,5025,5026,5030,5034,5042,5050,5014,5022,5030,5034,5042,5050)
chipCards.sto[NumArret %in% stops & NumLigne %in% routes ] %>% nrow() / n.days

chipCards.sto[NumArret == 5030 & NumLigne == 400 ] %>% nrow() / n.days



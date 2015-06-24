## Dette scriptet tråler gjennom Twitter og henter ut tweets fra utvalgte politi-konti.
library(ggplot2)
library(jsonlite)

setwd ('/Users/chrilur/Documents/R/twpoliti/repo/')

source('getTwitter.R')
source('cleanFrame.R')

alle <- read.table('data/totalt.csv', sep=",", header=TRUE, stringsAsFactors=FALSE)
alle$created <- as.POSIXct(alle$created)
alle$id <- as.character(alle$id)

konti <- c('Hordalandpoliti', 'oslopolitiops', 'Rogalandops', 'polititroms', 'politietsognfj', 'HaugSunnOps')
droppes <- c("favorited", "truncated", "replyToSID", "statusSource", "retweeted", "longitude", "latitude", "replyToUID", "retweetCount", "favoriteCount","replyToSN", "isRetweet")

print("Henter data fra Twitter...")

tw.df <- data.frame()
  for (i in 1:length(konti)) {
        cat("Konto:", konti[i],"\n")
        tw <- userTimeline(konti[i], n=50)
        tw <- twListToDF(tw)
        tw <- tw[,!(names(tw) %in% droppes)]
        tw$text <- gsub("\"", "", tw$text)
        tw <- tw[c("created", "screenName", "text", "id")]
        tw.df <- rbind(tw.df,tw)
        }

alle <- merge(alle, tw.df, all=TRUE)

#Kvitte seg med multiple rader
#Loopen går gjennom hver rad og sjekker om teksten finnes i en tidligere rad.
#I så fall slettes den.

alle <- cleanFrame(alle,4)

#Lagre data
write.table(alle, 'data/totalt.csv', col.names=TRUE, row.names=FALSE, sep=",", fileEncoding="UTF-8")

## d <- date()
## fil <- paste0('data/tweets', '_', d, '.csv')
##write.table(tw.df, fil, col.names=TRUE, row.names=FALSE, sep="," fileEncoding = 'UTF-8')


## allesortert <- alle[with(alle, order(alle[1])), ]
twnr <- nrow(alle)
siste50 <- alle[((twnr-49):twnr),]
print(siste50)
cat("Siste 50 tweets")

tot <- subset(alle, alle$created > '2015-06-08 00:00:00')
hord <- subset(tot, tot$screenName == 'Hordalandpoliti')

sistehord <- subset(siste50, siste50$screenName == "Hordalandpoliti")
dplot <- ggplot(alle, aes(x=created, y=screenName)) + geom_point()
splot <- ggplot(siste50, aes(x=created, y=screenName)) + geom_point()
hplot <- ggplot(sistehord, aes(x=created, y=screenName)) + geom_point()
tplot <- ggplot(tot, aes(x=created, y=screenName)) + geom_point()
hordplot <- ggplot(hord, aes(x=created, y=screenName)) + geom_point()

##JSON-data
jsonalle <- toJSON(alle)
write(allejson, file = 'data/twdata.JSON', ncolumns=1, sep="")
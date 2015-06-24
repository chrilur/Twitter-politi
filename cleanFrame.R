#Kvitte seg med multiple rader
#Loopen går gjennom hver rad og sjekker om teksten finnes i en tidligere rad.
#I så fall slettes den.

cleanFrame <- function(df,c) {
            r <- df[1,]
            for (i in 2:length(df[,c])) {
                k <- df[i,c]
                k <- ifelse (k %in% r[,c], NA, k)
                r <- rbind(r,df[i,])
                r[i,c] <- k
                        }
            r <- na.omit(r)
            df <- r           
            }           
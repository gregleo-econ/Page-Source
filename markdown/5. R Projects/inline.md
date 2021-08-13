+2

# Inline Skate Times

I participate in inline speed skating. To keep track of my progress, I follow how my 5-mile personal best time has improved. It is plotted below in brilliant ASCII made possible by the *txtplot* package in R. 

```{r setup, include=FALSE}
library(txtplot)
setwd("c://webpage")
data <- read.csv(file = 'skating.csv') 
```

## ASCII 5 Mile Skate Times

Here are my best times over 5 miles. Of course, the x-axis is the number of seconds since *1970-01-01*. What else would it be?

```{r output, echo=FALSE}
txtplot(as.numeric(as.POSIXct(data$dates, origin = "1970-01-01")),as.numeric(data$bestTimes),width=75)
```

## Code to Extract Best X Mile Times

Below is the code I use to extrat my best 5 mile times from CSV files of my GPS data. It is pretty slow but works reliably. 

```{r,splitExtract,eval=FALSE, echo=TRUE}
library(dplyr)
library(magrittr)
setwd("C://workouts//all")

distanceForSplit <- 5

temp = list.files(pattern="*data.csv")
dates <- c()
bestTimes <- c()
efforts <- list()
j <- 1
for(file in temp){
  data <- read.csv(file)
  data %<>% filter(record.distance.m. > 0)
  data %<>% mutate(record.distance.m. = record.distance.m. *0.000621371)
  distance <- data %>% pull(record.distance.m.) %>% max
  if(distance > distanceForSplit){
    splitIndex <- c()
    splitTime <- c()
    for(i in 1:dim(data)[1]){
      distances <- data %>% pull(record.distance.m.)
      times <- data %>% pull(record.timestamp.s.)
      startTime <- times[i]
      startDist <- distances[i] 
      splitIndex[i] <- min(which((distances - startDist)>distanceForSplit))
      if(!is.infinite(splitIndex[i])){
        splitTime[i] <- times[splitIndex[i]]-startTime
      }else{splitTime[i]<-1000000000}
    }
   time<- data[1,]%>%pull(file_id.time_created)
   time <- time + 631065600 
   dates[j]  <- as.POSIXct(time, origin = "1970-01-01")
   bestTimes[j] <- min(splitTime)/60
   bestIndexStart <- which(splitTime == min(splitTime))[1]
   bestIndexEnd <- splitIndex[bestIndexStart]
   efforts[[j]] <- distances[bestIndexStart:bestIndexEnd]-distances[bestIndexStart]
   print(bestTimes[j])
   print(as.POSIXct(dates[j],origin = "1970-01-01"))
   j <- j+1
  }
}
bestTimes <- bestTimes[order(dates)]
dates <- dates[order(dates)]
bestTimesNew <- bestTimes
j<-2
while(j < length(bestTimesNew)){
  
    if(bestTimesNew[j]>bestTimesNew[j-1]){
      bestTimesNew<-bestTimesNew[-j]
      dates<-dates[-j]
      efforts <- efforts[-j]
      j<-j-1
    }
  j<-j+1
}  
data <- data.frame(dates=as.POSIXct(dates, origin = "1970-01-01"),bestTimes = bestTimesNew)
```
###Bootstrapping EU mean and 95% CI based on TF age-adjusted cluster prevalence
###Brian Chu February 13, 2015; Updated by Beck Willis June 29, 2015

##TI bootstrapping

#Load, transform data

# Based on your entry for "newOnly", this code may remove extra EUs to speed-up analysis
# If "newOnly" set to FALSE, clean table will be unaffected
ifelse(newOnly == TRUE, 
       tiprev_cluster2 <- tiprev_cluster %>% anti_join(doNotRun, by = "eu"), 
       tiprev_cluster2 <- tiprev_cluster)

# IF statement removes the dataset if already generated for another bootstrapping exercise
# Next it creates the dataset, which will be composed only of EUs where there is 1+ cases of TI
if(exists("dataset")) {
  rm(dataset)
  dataset <- subset(tiprev_cluster2, tiprev_cluster2$eu %in% tiEU)
} else {
  dataset <- subset(tiprev_cluster2, tiprev_cluster2$eu %in% tiEU)
}

dataset$eu <- as.factor(dataset$eu)
dataset$cluster <- as.factor(dataset$cluster)
dataset$cluster_prev <- dataset$ti_adj


#Boot statistic function = mean of XX random clusters
clustermean <- function(df, i) {
  #num_clusters <- 100 #CHANGE NUMBER AS APPROPRIATE FOR DATASET!!
  num_clusters <- nrow(df)
  r <- round(runif(num_clusters, 1, nrow(df))) #nrow(df) allows the analysis to divide by the correct # clusters
  df2 <- numeric()
  for (i in 1:num_clusters) {
    df2[i] <- df[r[i],]$cluster_prev
  }
  return(mean(df2))  
}

#create empty data frame for results
bootResult_ti <- data.frame(eu=character(), bootmean=numeric(), se=numeric(), ti_95_low=numeric(), ti_95_upp=numeric(), stringsAsFactors=FALSE)

#Bootstrap function, looped over each EU
library(boot)
num_reps <- 10000 #Should be at least 1000 but preferably 10000, higher reps the more precise
for (i in 1:nlevels(dataset$eu)) {
  data2 <- subset(dataset, eu==levels(eu)[i])
  b <- boot(data2, clustermean, num_reps)
  m <- mean(b$t)
  se <- sd(b$t)
  
  #calculate 2.5/97.5 percentiles as Confidence Interval
  q <- quantile(b$t, c(0.025, 0.975))
  ci_lower <- q[1]
  ci_upper <- q[2]
  
  #alternate confidence interval methods
  #bci <- boot.ci(b, conf=0.95)  
  #ci_lowerSE <- m - (1.96*se)
  #ci_upperSE <- m + (1.96*se)
  
  #write result to data frame
  eu_temp <- as.character(data2$eu[1])
  bootResult_ti[i,] <- c(eu_temp, m, se, ci_lower, ci_upper)
  
  #histogram of mean bootstrap results with CI
  hist(b$t, breaks=50, main=paste("EU",eu_temp, "- Histogram of mean bootstrap results, n=", num_reps))
  abline(v=ci_lower, lty="dashed", col="black" )
  abline(v=ci_upper, lty="dashed", col="black" )
  #abline(v=ci_lowerSE, lty="dashed", col="blue" )
  #abline(v=ci_upperSE, lty="dashed", col="blue" )      
}

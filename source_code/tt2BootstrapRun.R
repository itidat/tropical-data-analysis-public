## Tropical Data standard analyses - Bootstrapping EU mean and 95% CI based on adjusted TT v2/v3 cluster prevalence
## v2/v3 methodology: TT is upper lid trichiasis

## TT
ttprev_cluster2 <- ttprev_cluster

# remove the 'dataset' object if already generated for another bootstrapping exercise
# create the 'dataset' object which will only include EUs with > 0 TT cases
if(exists("dataset")) {
  rm(dataset)
  dataset <- subset(ttprev_cluster2, ttprev_cluster2$eu %in% tt2EU)
} else {
  dataset <- subset(ttprev_cluster2, ttprev_cluster2$eu %in% tt2EU)
}

dataset$eu <- as.factor(dataset$eu)
dataset$cluster <- as.factor(dataset$cluster)
dataset$cluster_prev <- dataset$tt2


# boot statistic function = mean of XX random clusters
clustermean <- function(df, i) {
  num_clusters <- nrow(df)
  r <- round(runif(num_clusters, 1, nrow(df))) 
  df2 <- numeric()
  for (i in 1:num_clusters) {
    df2[i] <- df[r[i],]$cluster_prev
  }
  return(mean(df2))  
}

# create empty data frame for results
bootResult_tt2 <- data.frame(eu=character(), bootmean=numeric(), se=numeric(), tt2_95_low=numeric(), tt2_95_upp=numeric(), stringsAsFactors=FALSE)

# bootstrap function, looped over each EU
library(boot)
num_reps <- 10000 # should be at least 1000 but preferably 10000 - the higher the reps, the more precise
for (i in 1:nlevels(dataset$eu)) {
  data2 <- subset(dataset, eu==levels(eu)[i])
  b <- boot(data2, clustermean, num_reps)
  m <- mean(b$t)
  se <- sd(b$t)
  
# calculate 2.5/97.5 percentiles as Confidence Interval
  q <- quantile(b$t, c(0.025, 0.975))
  ci_lower <- q[1]
  ci_upper <- q[2]
  
# write result to data frame
  eu_temp <- as.character(data2$eu[1])
  bootResult_tt2[i,] <- c(eu_temp, m, se, ci_lower, ci_upper)
  
# histogram of mean bootstrap results with CI - histograms for each EU will appear in the plots tab
  hist(b$t, breaks=50, main=paste("EU",eu_temp, "- Histogram of mean bootstrap results, n=", num_reps))
  abline(v=ci_lower, lty="dashed", col="black" )
  abline(v=ci_upper, lty="dashed", col="black" )     
}

# remove temporary tables
rm(dataset, data2, ttprev_cluster2)

## Unmanaged TT 
ttprev_cluster2 <- ttprev_cluster

# remove the 'dataset' object if already generated for another bootstrapping exercise
# create the 'dataset' object which will only include EUs with > 0 unmanaged TT cases
if(exists("dataset")) {
  rm(dataset)
  dataset <- subset(ttprev_cluster2, ttprev_cluster2$eu %in% tt2_unmanagedEU)
} else {
  dataset <- subset(ttprev_cluster2, ttprev_cluster2$eu %in% tt2_unmanagedEU)
}

dataset$eu <- as.factor(dataset$eu)
dataset$cluster <- as.factor(dataset$cluster)
dataset$cluster_prev <- dataset$tt2_unmanaged


# boot statistic function = mean of XX random clusters
clustermean <- function(df, i) {
  num_clusters <- nrow(df)
  r <- round(runif(num_clusters, 1, nrow(df))) 
  df2 <- numeric()
  for (i in 1:num_clusters) {
    df2[i] <- df[r[i],]$cluster_prev
  }
  return(mean(df2))  
}

# create empty data frame for results
bootResult_tt2_unman <- data.frame(eu=character(), bootmean=numeric(), se=numeric(), tt2_unmanaged_95_low=numeric(), 
                                     tt2_unmanaged_95_upp=numeric(), stringsAsFactors=FALSE)

#if there are zero unmanaged cases, this code will simply return the 'clean' object
if(length(tt2_unmanagedEU) > 0) {

# bootstrap function, looped over each EU
library(boot)
num_reps <- 10000 # should be at least 1000 but preferably 10000 - the higher the reps, the more precise
for (i in 1:nlevels(dataset$eu)) {
  data2 <- subset(dataset, eu==levels(eu)[i])
  b <- boot(data2, clustermean, num_reps)
  m <- mean(b$t)
  se <- sd(b$t)
  
# calculate 2.5/97.5 percentiles as Confidence Interval
  q <- quantile(b$t, c(0.025, 0.975))
  ci_lower <- q[1]
  ci_upper <- q[2]
  
# write result to data frame
  eu_temp <- as.character(data2$eu[1])
  bootResult_tt2_unman[i,] <- c(eu_temp, m, se, ci_lower, ci_upper)
  
# histogram of mean bootstrap results with CI - histograms for each EU will appear in the plots tab
  hist(b$t, breaks=50, main=paste("EU",eu_temp, "- Histogram of mean bootstrap results, n=", num_reps))
  abline(v=ci_lower, lty="dashed", col="black" )
  abline(v=ci_upper, lty="dashed", col="black" )
}

} else {
  clean <- clean 
}

# remove temporary tables
rm(dataset, data2, ttprev_cluster2)

### END ###

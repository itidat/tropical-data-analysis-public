###Generate and Export file with all results by EU, including bootstrap results
###Beck Willis, Updated JMay 15, 2018


# Write queries to offline library, to use when connected
write.csv(gps_cluster, paste("td_results/gps_cluster/", nameProject, "_cluster_gps_",currentDate,".csv",sep=""))
write.csv(gps_cluster, paste("td_results/eu_analysis_expanded/", nameProject, "_full_analysis_",currentDate,".csv",sep=""))


# Prepare update query for completing previously analyzed records
# This should have an if else for newOnly
source("source_code/updateQuery.R")

### END ###
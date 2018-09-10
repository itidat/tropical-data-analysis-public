### This code will output some quick results so you can check them before running bootstrap code
## NOTE: it also prepares the dataframe to be used for QC in next step
# Beck Willis - May 15, 2018

if (ttOnly == TRUE) {
results_quick <- ttprev_eu %>% 
  left_join(tt_unadj_eu, by="eu")
} else {
  results_quick <- tfprev_eu %>% 
    left_join(ttprev_eu, by = "eu")
  results_quick <- results_quick %>% 
    left_join(tf_unadj_eu, by = "eu")
  results_quick <- results_quick %>% 
    left_join(tt_unadj_eu, by="eu")
}


if (ttOnly == TRUE) {
  results_quick <- results_quick[,c("eu", "trich_unadj", "trich_adj",
                                    "trich_unmanaged_unadj", "trich_unmanaged_adj",
                                    "tt_unadj", "tt_adj", "tt_unmanaged_unadj", "tt_unmanaged_adj")]
  } else {
  results_quick <- results_quick[,c("eu", "tf_unadj", "tf_adj", "trich_unadj", "trich_adj",
                                    "trich_unmanaged_unadj", "trich_unmanaged_adj",
                                    "tt_unadj", "tt_adj", "tt_unmanaged_unadj", "tt_unmanaged_adj")]}

# write eu level results to csv file before bootstrap runs- for quick QC
write.csv(results_quick, paste("Box Sync/R_WD/R_WD_TD/td_results/td_results_quick/", nameProject, "_quick_results_",currentDate,".csv",sep="")) 

# create data frame for cluster-level prevalence results (for future QC only!!)
if (ttOnly == TRUE) {
  prev_cluster <- ttprev_cluster
} else {
prev_cluster <- tfprev_cluster %>% 
  left_join(ttprev_cluster, by = c("eu", "cluster"))
}

# write cluster-level results to csv, for later QC, if needed
# please note that the survey methodology does not allow for adequately powered analysis at the cluster level
# therefore, the below results should be interpreted with caution
write.csv(prev_cluster, paste("td_results/cluster_results/", nameProject, "_cluster_results_",currentDate,".csv",sep="")) 

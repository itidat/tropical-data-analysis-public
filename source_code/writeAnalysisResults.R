###Generate and Export file with all results by EU, including bootstrap results
###Beck Willis, Updated JMay 15, 2018


# Create huge table of all of results
analysis_insert <- clean_counts %>% 
  left_join(select(bootResult_trich_all, eu, trich_unadj, trich_adj, trich_95_low, trich_95_upp, 
                   trich_unmanaged_unadj, trich_unmanaged_adj, trich_unmanaged_95_low, 
                   trich_unmanaged_95_upp), by = "eu")

analysis_insert <- analysis_insert %>% 
  left_join(select(bootResult_tt_all, eu, tt_unadj, tt_adj, tt_95_low, tt_95_upp,
                   tt_unmanaged_unadj, tt_unmanaged_adj, tt_unmanaged_95_low, 
                   tt_unmanaged_95_upp), by = "eu")

if(ttOnly == TRUE) {
  analysis_insert <- analysis_insert # does nothing
} else {
  
  analysis_insert <- analysis_insert %>% 
    left_join(select(bootResult_tf_all, eu, tf_unadj, tf_adj, tf_95_low, tf_95_upp), by = "eu")
  
  analysis_insert <- analysis_insert %>% 
    left_join(select(bootResult_ti_all, eu, ti_unadj, ti_adj, ti_95_low, ti_95_upp), by = "eu")
  
  analysis_insert <- analysis_insert %>% 
  left_join(select(wash, eu, drink_imp_30, drink_imp, drink_near, drink_imp_yard, hw, latrine_imp,
                   wash_imp_30, wash_imp, wash_near, wash_imp_yard, percent_drink_imp, 
                   percent_drink_near, percent_latrine_imp), by = "eu")
}

analysis_insert["projectID"] <- projectID
analysis_insert["analysisName"] <- analysisName

write.csv(analysis_insert, paste("td_results/analysis_insert_results/", nameProject, "_analysis_insert_",currentDate,".csv",sep=""))

# Create list of fields that we are going to populate in the dB table
insertFields <- as.data.frame(ifelse(ttOnly == TRUE,
                                     read.table("offline_library/eu_analysis_expanded_fields_tt.txt", sep = ";"),
                                     read.table("offline_library/eu_analysis_expanded_fields.txt", sep = ";")))

# Create a list of all of the EUs that were 
eu_check2 <- as.data.frame(eu_check)
colnames(eu_check2)[1] <- "eu"

# Set up the currentDate object for exports
currentDateTime <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

# Keep only the rows for EUs that were not flagged during the QC
analysis_insert2 <- analysis_insert %>% anti_join(eu_check2)

## END ##

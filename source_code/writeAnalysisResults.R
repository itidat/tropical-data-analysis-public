## Tropical Data standard analyses - generate and export file with analysis results by EU
## exported results will match the District Report output downloadable here : https://www.tropicaldata.org/downloads
## v. 14/08/20 

# remove temporary objects 
rm(tfprev_cluster, ttprev_cluster)


# rename tt1 and tt2 result columns to match field names in District Report output 
tt1_results <- tt1_eu_CIs %>% 
  rename_with(~ tolower(gsub("tt1", "trichts", .x, fixed = TRUE)))

tt2_results <- tt2_eu_CIs %>% 
  rename_with(~ tolower(gsub("tt2", "tt", .x, fixed = TRUE)))


# merge all results into one dataframe  
analysis_result <- eu_cross %>% 
  select(admin0_name,	admin1_name, admin2_name,	admin3_name, eu, project_id, survey_type) %>% 
  right_join(eu_list) %>% 
  left_join(select(counts_eu, eu, date_completed, cluster_ct, hh_ct, child_enum, child_ex), by = "eu") %>% 
  left_join(select(tfprev_eu_CIs, eu, tf_adj, tf_95_low, tf_95_upp), by = "eu") %>% 
  left_join(select(counts_eu, eu, adult_enum, adult_ex), by = "eu") %>% 
  left_join(tt2_results) %>% 
  left_join(trich_eu_CIs) %>% 
  left_join(tt1_results) %>% 
  left_join(wash_eu) %>% 
  arrange(eu)

# get country name for file name 
# NOTE: if your project is at the region level, change line 32 to -> country <- as.character(eu_cross[1,2])
country <- as.character(eu_cross[1,1])

# write results to file in your working directory 
# the results in this file can be pasted into the District Report template downloadable here : https://www.tropicaldata.org/downloads
# the District Report template includes a data dictionary with definitions for each variable of the results output 
write.csv(analysis_result, paste("analysis_result_",country,"_",currentDate,".csv", sep=""), na = "", row.names = FALSE)

### END ###
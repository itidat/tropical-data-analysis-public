### This code is used to compare historical results and flag any differences before moving ahead with the time-consuming bootstrapping
# Beck Willis - May 15, 2018


if(exists("eu_analysis_compare")) {
  rm(eu_analysis_compare)
} else {
  clean <- clean # does nothing
}

# Create table of non-CI results to do a QC
eu_analysis_compare <- eu_analysis_exists[,c("eu", "tf_unadj", "tf_adj", "trich_unadj", "trich_adj", "tt_unadj", "tt_adj")]
colnames(eu_analysis_compare)    <- paste(colnames(eu_analysis_compare), "comp", sep = "_")
colnames(eu_analysis_compare)[1] <- "eu"

# Pair results_quick with historical EU results to make sure that all is A-OK
results_qc <- merge(results_quick, eu_analysis_compare, by = "eu", all = TRUE)

if (ttOnly == TRUE) {
  results_qc <- results_qc %>%
    filter(!is.na(tt_adj)) %>%
    mutate(trich_unadj_diff = trich_unadj_comp - trich_unadj,
           trich_adj_diff   = trich_adj_comp - trich_adj,
           tt_unadj_diff    = tt_unadj_comp - tt_unadj,
           tt_adj_diff      = tt_adj_comp - tt_adj)
  
  results_qc["qc_alert"] <- ifelse(((abs(results_qc$trich_unadj_diff) > 0.00001 & !is.na(results_qc$trich_unadj_diff)) | 
                                      (abs(results_qc$trich_adj_diff) > 0.00001 & !is.na(results_qc$trich_adj_diff)) | 
                                      (abs(results_qc$tt_unadj_diff) > 0.00001 & !is.na(results_qc$tt_unadj_diff)) |
                                      (abs(results_qc$tt_adj_diff) > 0.00001) & !is.na(results_qc$tt_adj_diff)),
                                   TRUE,
                                   FALSE)
} else {
results_qc <- results_qc %>%
  filter(!is.na(tt_adj)) %>%
  mutate(tf_unadj_diff    = tf_unadj_comp - tf_unadj,
         tf_adj_diff      = tf_adj_comp - tf_adj,
         trich_unadj_diff = trich_unadj_comp - trich_unadj,
         trich_adj_diff   = trich_adj_comp - trich_adj,
         tt_unadj_diff    = tt_unadj_comp - tt_unadj,
         tt_adj_diff      = tt_adj_comp - tt_adj)

results_qc["qc_alert"] <- ifelse(((abs(results_qc$tf_unadj_diff) > 0.0001 & !is.na(results_qc$tf_unadj_diff)) |
                                    (abs(results_qc$tf_adj_diff) > 0.0001 & !is.na(results_qc$tf_adj_diff)) | 
                                    (abs(results_qc$trich_unadj_diff) > 0.00001 & !is.na(results_qc$trich_unadj_diff)) | 
                                    (abs(results_qc$trich_adj_diff) > 0.00001 & !is.na(results_qc$trich_adj_diff)) | 
                                    (abs(results_qc$tt_unadj_diff) > 0.00001 & !is.na(results_qc$tt_unadj_diff)) |
                                    (abs(results_qc$tt_adj_diff) > 0.00001) & !is.na(results_qc$tt_adj_diff)),
                                 TRUE,
                                 FALSE)
}

qc_alert <- subset(results_qc, results_qc$qc_alert == TRUE)
eu_check <- qc_alert[,c("eu")]

if(as.numeric(nrow(qc_alert)) > 0) {
  write.csv(qc_alert, paste("td_results/analysis_alerts/", nameProject, "_qc_alert_",currentDate,".csv",sep=""))
  print("MUST CHECK QC FOLDER!!!")
} else {
       print("All gravy baby!")
}


### END ###
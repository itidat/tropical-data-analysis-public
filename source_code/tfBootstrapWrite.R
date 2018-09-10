###Bootstrapping EU mean and 95% CI based on TF age-adjusted cluster prevalence
###Brian Chu February 13, 2015; Updated by Beck Willis June 29, 2015

if(length(tfEU) == 0) {
  bootResult_tf_new <- data.frame(eu=character(), tf_unadj=numeric(), tf_adj=numeric(), tf_95_low=numeric(), tf_95_upp=numeric(), stringsAsFactors=FALSE)
  bootResult_tf_new <- bind_rows(bootResult_tf_new, euBoot)
  bootResult_tf_new$tf_unadj <- 0
  bootResult_tf_new$tf_adj <- 0
} else {


bootResult_tf <- bootResult_tf %>% 
  mutate(tf_95_low = as.numeric(tf_95_low),
         tf_95_upp = as.numeric(tf_95_upp))

bootResult_tf_new <- bootResult_tf %>% 
  right_join(select(tf_unadj_eu, eu, tf_unadj), by = "eu")

bootResult_tf_new <- bootResult_tf_new %>% 
  left_join(select(tfprev_eu, eu, tf_adj), by = "eu")

bootResult_tf_new <- bootResult_tf_new[,c("eu", "tf_unadj", "tf_adj", "tf_95_low", "tf_95_upp")]
}

bootResult_tf_past <- eu_analysis_old[,c("eu", "tf_unadj", "tf_adj", "tf_95_low", "tf_95_upp")]

# Get list of EUs that already have results in the eu_analysis table in the dB
tf_past_eu <- as.data.frame(bootResult_tf_past[,c("eu")])
colnames(tf_past_eu)[1] <- "eu"

# Keep only the rows that are new
bootResult_tf_new2 <- bootResult_tf_new %>% anti_join(tf_past_eu, by = "eu")

# Join the old and the new results (you don't want to replace the CIs because they can differ slightly each time)
bootResult_tf_all <- bootResult_tf_new2 %>% bind_rows(bootResult_tf_past)

bootResult_tf_all$tf_95_low[(is.na(bootResult_tf_all$tf_adj) | bootResult_tf_all$tf_adj == 0) & !(bootResult_tf_all$eu %in% tfEU)] <- 0
bootResult_tf_all$tf_95_upp[(is.na(bootResult_tf_all$tf_adj) | bootResult_tf_all$tf_adj == 0) & !(bootResult_tf_all$eu %in% tfEU)] <- 0


# Export bootstrap results just in case analysis gets hung-up or you only want to run this analysis
write.csv(bootResult_tf_all, 
          paste("td_results/bootstrap_save/", nameProject, "_results_tf_",currentDate,".csv",sep=""))

# Remove temporary tables
rm(bootResult_tf_past, bootResult_tf_new, bootResult_tf_new2)

### END ###


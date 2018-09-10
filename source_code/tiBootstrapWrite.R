###Bootstrapping EU mean and 95% CI based on TF age-adjusted cluster prevalence
###Brian Chu February 13, 2015; Updated by Beck Willis June 29, 2015

if(length(tiEU) == 0) {
  bootResult_ti_new <- data.frame(eu=character(), ti_unadj=numeric(), ti_adj=numeric(), ti_95_low=numeric(), ti_95_upp=numeric(), stringsAsFactors=FALSE)
  bootResult_ti_new <- bind_rows(bootResult_ti_new, euBoot)
  bootResult_ti_new$ti_unadj <- 0
  bootResult_ti_new$ti_adj <- 0
} else {

bootResult_ti <- bootResult_ti %>% 
  mutate(ti_95_low = as.numeric(ti_95_low),
         ti_95_upp = as.numeric(ti_95_upp))

if(newOnly == TRUE) {
  ti_unadj_eu2 <- eu_new %>% 
  left_join(ti_unadj_eu, by = "eu")
} else {
  ti_unadj_eu2 <- ti_unadj_eu #includes all EUs, not just new
}

bootResult_ti_new <- bootResult_ti %>% 
  right_join(select(ti_unadj_eu2, eu, ti_unadj), by = "eu")

if(newOnly == TRUE) {
  tiprev_eu2 <- eu_new %>%
    left_join(tiprev_eu, by = "eu")
} else {
  tiprev_eu2 <- tiprev_eu #includes all EUs, not just new
}

bootResult_ti_new <- bootResult_ti_new %>% 
  left_join(select(tiprev_eu2, eu, ti_adj), by = "eu")

bootResult_ti_new <- bootResult_ti_new[,c("eu", "ti_unadj", "ti_adj", "ti_95_low", "ti_95_upp")]
}

bootResult_ti_past <- eu_analysis_old[,c("eu", "ti_unadj", "ti_adj", "ti_95_low", "ti_95_upp")]
bootResult_ti_past <- subset(bootResult_ti_past, !is.na(ti_adj))

# Get list of EUs that already have results in the eu_analysis table in the dB
ti_past_eu <- as.data.frame(bootResult_ti_past[,c("eu")])
colnames(ti_past_eu)[1] <- "eu"

# Keep only the rows that are new
bootResult_ti_new2 <- bootResult_ti_new %>% anti_join(ti_past_eu, by = "eu")

# Join the old and the new results (you don't want to replace the CIs because they can differ slightly each time)
bootResult_ti_all <- bootResult_ti_new2 %>% bind_rows(bootResult_ti_past)

bootResult_ti_all$ti_95_low[(is.na(bootResult_ti_all$ti_adj) | bootResult_ti_all$ti_adj == 0) & !(bootResult_ti_all$eu %in% tiEU)] <- 0
bootResult_ti_all$ti_95_upp[(is.na(bootResult_ti_all$ti_adj) | bootResult_ti_all$ti_adj == 0) & !(bootResult_ti_all$eu %in% tiEU)] <- 0



#write TI results to folder
write.csv(bootResult_ti_all, paste("td_results/ti_results/", nameProject, "_ti_results_",currentDate,".csv",sep=""))

### END ###

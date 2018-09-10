###Bootstrapping EU mean and 95% CI based on TT age-adjusted cluster prevalence
###Brian Chu February 13, 2015; Updated by Beck Willis May 16, 2018

## Account for when there are zero trichiasis cases
if(length(trichEU) == 0) {
  bootResult_trich <- data.frame(eu=character(), trich_unadj=numeric(), trich_adj=numeric(), 
                                           trich_95_low=numeric(), trich_95_upp=numeric(), stringsAsFactors=FALSE)
  bootResult_trich2 <- bind_rows(bootResult_trich, euBoot)
  bootResult_trich2$trich_unadj <- 0
  bootResult_trich2$trich_adj <- 0
} else {

  bootResult_trich <- bootResult_trich %>% 
  mutate(trich_95_low = as.numeric(trich_95_low),
         trich_95_upp = as.numeric(trich_95_upp))

bootResult_trich2 <- bootResult_trich %>% 
  right_join(select(tt_unadj_eu, eu, trich_unadj), by = "eu")

bootResult_trich2 <- bootResult_trich2 %>% 
  left_join(select(ttprev_eu, eu, trich_adj), by = "eu")

bootResult_trich2 <- bootResult_trich2[,c("eu", "trich_unadj", "trich_adj", "trich_95_low", "trich_95_upp")]
}

## Account for when there are zero unmanaged trichiasis cases
if(length(trich_unmanagedEU) == 0) {
  bootResult_trich_unman <- data.frame(eu=character(), trich_unmanaged_unadj=numeric(), trich_unmanaged_adj=numeric(), 
                                 trich_unmanaged_95_low=numeric(), trich_unmanaged_95_upp=numeric(), stringsAsFactors=FALSE)
  bootResult_trich_unman2 <- bind_rows(bootResult_trich_unman, euBoot)
  bootResult_trich_unman2$trich_unmanaged_unadj <- 0
  bootResult_trich_unman2$trich_unmanaged_adj <- 0
} else {
  

  bootResult_trich_unman <- bootResult_trich_unman %>% 
    mutate(trich_unmanaged_95_low = as.numeric(trich_unmanaged_95_low),
           trich_unmanaged_95_upp = as.numeric(trich_unmanaged_95_upp))
  
  bootResult_trich_unman2 <- bootResult_trich_unman %>% 
    right_join(select(tt_unadj_eu, eu, trich_unmanaged_unadj), by = "eu")
  
  bootResult_trich_unman2 <- bootResult_trich_unman2 %>% 
    left_join(select(ttprev_eu, eu, trich_unmanaged_adj), by = "eu")
  
  bootResult_trich_unman2 <- bootResult_trich_unman2[,c("eu", "trich_unmanaged_unadj", "trich_unmanaged_adj", 
                                                        "trich_unmanaged_95_low", "trich_unmanaged_95_upp")]
}

bootResult_trich_new <- bootResult_trich2 %>% 
  left_join(bootResult_trich_unman2, by = "eu")

bootResult_trich_past <- eu_analysis_old[,c("eu", "trich_unadj", "trich_adj", "trich_95_low", "trich_95_upp", 
                                           "trich_unmanaged_unadj", "trich_unmanaged_adj", 
                                           "trich_unmanaged_95_low", "trich_unmanaged_95_upp")]

bootResult_trich_past <- subset(bootResult_trich_past, !is.na(bootResult_trich_past$trich_unmanaged_adj))

trich_past_eu <- as.data.frame(bootResult_trich_past[,c("eu")])
colnames(trich_past_eu)[1] <- "eu"

bootResult_trich_new2 <- bootResult_trich_new %>% anti_join(trich_past_eu, by = "eu")

bootResult_trich_all <- bootResult_trich_new2 %>%
  bind_rows(bootResult_trich_past)

bootResult_trich_all$trich_95_low[(is.na(bootResult_trich_all$trich_adj) | bootResult_trich_all$trich_adj == 0) & !(bootResult_trich_all$eu %in% trichEU)] <- 0
bootResult_trich_all$trich_95_upp[(is.na(bootResult_trich_all$trich_adj)| bootResult_trich_all$trich_adj == 0) & !(bootResult_trich_all$eu %in% trichEU)] <- 0
bootResult_trich_all$trich_unmanaged_95_low[(is.na(bootResult_trich_all$trich_unmanaged_adj) | bootResult_trich_all$trich_unmanaged_adj == 0) 
                                            & !(bootResult_trich_all$eu %in% trich_unmanagedEU)] <- 0
bootResult_trich_all$trich_unmanaged_95_upp[(is.na(bootResult_trich_all$trich_unmanaged_adj) | bootResult_trich_all$trich_unmanaged_adj == 0)
                                            & !(bootResult_trich_all$eu %in% trich_unmanagedEU)] <- 0

# Export bootstrap results just in case analysis gets hung-up 
# or you only want to run this specific analysis
write.csv(bootResult_trich_all, paste("td_results/bootstrap_save/", nameProject, "_results_trich_",currentDate,".csv",sep=""))


#rm(bootResult_trich_new, bootResult_trich_new2, bootResult_trich_past)

### END ###
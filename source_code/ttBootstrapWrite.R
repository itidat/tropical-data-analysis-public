###Bootstrapping EU mean and 95% CI based on TT age-adjusted cluster prevalence
###Brian Chu February 13, 2015; Updated by Beck Willis May 16, 2018

## Account for when there are zero trichiasis + TS cases
if(length(ttEU) == 0) {
  bootResult_tt <- data.frame(eu=character(), tt_unadj=numeric(), tt_adj=numeric(), 
                                 tt_95_low=numeric(), tt_95_upp=numeric(), stringsAsFactors=FALSE)
  bootResult_tt2 <- bind_rows(bootResult_tt, euBoot)
  bootResult_tt2$tt_unadj <- 0
  bootResult_tt2$tt_adj <- 0
} else {
  
  bootResult_tt <- bootResult_tt %>% 
    mutate(tt_95_low = as.numeric(tt_95_low),
           tt_95_upp = as.numeric(tt_95_upp))
  
  bootResult_tt2 <- bootResult_tt %>% 
    right_join(select(tt_unadj_eu, eu, tt_unadj), by = "eu")
  
  bootResult_tt2 <- bootResult_tt2 %>% 
    left_join(select(ttprev_eu, eu, tt_adj), by = "eu")
  
  bootResult_tt2 <- bootResult_tt2[,c("eu", "tt_unadj", "tt_adj", "tt_95_low", "tt_95_upp")]
}

## Account for when there are zero unmanaged trichiasis + TS cases
if(length(tt_unmanagedEU) == 0) {
  bootResult_tt_unman <- data.frame(eu=character(), tt_unmanaged_unadj=numeric(), tt_unmanaged_adj=numeric(), 
                                       tt_unmanaged_95_low=numeric(), tt_unmanaged_95_upp=numeric(), stringsAsFactors=FALSE)
  bootResult_tt_unman2 <- bind_rows(bootResult_tt_unman, euBoot)
  bootResult_tt_unman2$tt_unmanaged_unadj <- 0
  bootResult_tt_unman2$tt_unmanaged_adj <- 0
} else {
  
  bootResult_tt_unman <- bootResult_tt_unman %>% 
    mutate(tt_unmanaged_95_low = as.numeric(tt_unmanaged_95_low),
           tt_unmanaged_95_upp = as.numeric(tt_unmanaged_95_upp))
  
  bootResult_tt_unman2 <- bootResult_tt_unman %>% 
    right_join(select(tt_unadj_eu, eu, tt_unmanaged_unadj), by = "eu")
  
  bootResult_tt_unman2 <- bootResult_tt_unman2 %>% 
    left_join(select(ttprev_eu, eu, tt_unmanaged_adj), by = "eu")
  
  bootResult_tt_unman2 <- bootResult_tt_unman2[,c("eu", "tt_unmanaged_unadj", "tt_unmanaged_adj", 
                                                        "tt_unmanaged_95_low", "tt_unmanaged_95_upp")]
}

bootResult_tt_new <- bootResult_tt2 %>% 
  left_join(bootResult_tt_unman2, by = "eu")

bootResult_tt_past <- eu_analysis_old[,c("eu", "tt_unadj", "tt_adj", "tt_95_low", "tt_95_upp", 
                                            "tt_unmanaged_unadj", "tt_unmanaged_adj", 
                                            "tt_unmanaged_95_low", "tt_unmanaged_95_upp")]
bootResult_tt_past <- subset(bootResult_tt_past, !is.na(bootResult_tt_past$tt_unmanaged_unadj))

tt_past_eu <- as.data.frame(bootResult_tt_past[,c("eu")])
colnames(tt_past_eu)[1] <- "eu"

bootResult_tt_new2 <- bootResult_tt_new %>% anti_join(tt_past_eu, by = "eu")

bootResult_tt_all <- bootResult_tt_new2 %>%
  bind_rows(bootResult_tt_past)

bootResult_tt_all$tt_95_low[(is.na(bootResult_tt_all$tt_adj) | bootResult_tt_all$tt_adj == 0) & !(bootResult_tt_all$eu %in% ttEU)] <- 0
bootResult_tt_all$tt_95_upp[(is.na(bootResult_tt_all$tt_adj) | bootResult_tt_all$tt_adj == 0) & !(bootResult_tt_all$eu %in% ttEU)] <- 0
bootResult_tt_all$tt_unmanaged_95_low[(is.na(bootResult_tt_all$tt_unmanaged_adj) | bootResult_tt_all$tt_unmanaged_adj == 0) 
                                            & !(bootResult_tt_all$eu %in% tt_unmanagedEU)] <- 0
bootResult_tt_all$tt_unmanaged_95_upp[(is.na(bootResult_tt_all$tt_unmanaged_adj) | bootResult_tt_all$tt_unmanaged_adj == 0)
                                            & !(bootResult_tt_all$eu %in% tt_unmanagedEU)] <- 0

# Export bootstrap results just in case analysis gets hung-up or you only want to run this analysis
write.csv(bootResult_tt_all, paste("td_results/bootstrap_save/", nameProject, "_results_tt_",currentDate,".csv",sep=""))

#rm(bootResult_tt_new, bootResult_tt_new2, bootResult_tt_past, tt_past_eu)

### END ###
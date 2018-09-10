###Calculating GTMP unadjusted and adjusted TT prevalence from exported file
###Beck Willis, Updated June 29, 2015

##PART 1: Calculating "old" TT prevalence (not taking TS into account)

pop_adult_male <- population[, c("age_group", "percent_age_male")]
colnames(pop_adult_male)[2] <- "age_weight"

pop_adult_fem               <- population[, c("age_group", "percent_age_female")]
colnames(pop_adult_fem)[2]  <- "age_weight"

mydb_tt_male <- subset(mydb_tt, sex == 1)
mydb_tt_fem  <- subset(mydb_tt, sex == 2)

ttprev_male <- mydb_tt_male %>% 
  left_join(pop_adult_male, by = "age_group")

ttprev_female <- mydb_tt_fem %>% 
  left_join(pop_adult_fem, by = "age_group")

ttprev_male   <- merge(mydb_tt_male, pop_adult_male, by = "age_group", all.x = TRUE)
ttprev_female <- merge(mydb_tt_fem, pop_adult_fem, by = "age_group", all.x = TRUE)

ttprev <- as.data.frame(rbind(ttprev_male, ttprev_female)) # Append the dataframes

colnames(ttprev)[6:9] <- c("tt_old_ct", "tt_old_unmanaged_ct", "tt_true_ct", "tt_unmanaged_ct") 

## get unadj results
tt_unadj_cluster <- ttprev %>%
  group_by(eu, cluster) %>%
  summarize(residents           = sum(residents),
            tt_old_ct           = sum(tt_old_ct),
            tt_old_unmanaged_ct = sum(tt_old_unmanaged_ct),
            tt_true_ct          = sum(tt_true_ct),
            tt_unmanaged_ct     = sum(tt_unmanaged_ct)) %>%
  mutate(trich_unadj              = tt_old_ct / residents,
            trich_unmanaged_unadj = tt_old_unmanaged_ct / residents,
            tt_unadj              = tt_true_ct / residents,
            tt_unmanaged_unadj    = tt_unmanaged_ct /residents)

tt_unadj_eu <- tt_unadj_cluster %>%
  group_by(eu) %>%
  summarize(trich_unadj           = mean(trich_unadj),
            trich_unmanaged_unadj = mean(trich_unmanaged_unadj),
            tt_unadj              = mean(tt_unadj),
            tt_unmanaged_unadj    = mean(tt_unmanaged_unadj))

# assign age-gender weights
ttprev2 <- ttprev %>%
  group_by(eu, cluster, age_group, sex) %>%
  mutate(tt_old           = (tt_old_ct/residents) * age_weight,
         tt_old_unmanaged = (tt_old_unmanaged_ct/residents) * age_weight,
         tt_true          = (tt_true_ct/residents) * age_weight,
         tt_unmanaged     = (tt_unmanaged_ct/residents) * age_weight)

# aggregate to cluster level
ttprev_cluster <- ttprev2 %>%
  group_by(eu, cluster) %>%
  summarize(tt_old           = sum(tt_old),
            tt_old_unmanaged = sum(tt_old_unmanaged),
            tt_true          = sum(tt_true),
            tt_unmanaged     = sum(tt_unmanaged))

# aggregate to EU level
ttprev_eu <- ttprev_cluster %>%
  group_by(eu) %>%
  summarize(trich_adj           = mean(tt_old),
            trich_unmanaged_adj = mean(tt_old_unmanaged),
            tt_adj              = mean(tt_true),
            tt_unmanaged_adj    = mean(tt_unmanaged))


#rm(ttprev2, ttprev, tt_unadj_cluster, mydb_tt, mydb_tt_fem, mydb_tt_male, pop_adult_fem, pop_adult_male, ttprev_female, ttprev_male)

### END ###


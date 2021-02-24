## Tropical Data standard analyses - write TT v1 bootstrapping results

# for zero cases, this will create an empty dataframe 
if(length(tt1EU) == 0) {
  bootResult_tt1 <- data.frame(eu=numeric(), tt1_adj=numeric(), tt1_95_low=numeric(), tt1_95_upp=numeric(), stringsAsFactors=FALSE) %>% 
    bind_rows(eu_list) %>% 
    replace(., is.na(.), 0)
} else {
  bootResult_tt1 <- bootResult_tt1 %>% 
    mutate(tt1_95_low = as.numeric(tt1_95_low),
           tt1_95_upp = as.numeric(tt1_95_upp), 
           eu = as.numeric(eu)) %>% 
  left_join(select(ttprev_eu, eu, tt1_adj), by = "eu") %>% 
  right_join(eu_list) %>% 
  select(eu, tt1_adj, tt1_95_low, tt1_95_upp) %>% 
  replace(., is.na(.), 0)
}

# for zero cases, this will create an empty dataframe
if(length(tt1_unmanagedEU) == 0) {
  bootResult_tt1_unman <- data.frame(eu=numeric(), tt1_unmanaged_adj=numeric(), tt1_unmanaged_95_low=numeric(), tt1_unmanaged_95_upp=numeric(), stringsAsFactors=FALSE) %>% 
    bind_rows(eu_list) %>% 
    replace(., is.na(.), 0)
} else {
  bootResult_tt1_unman <- bootResult_tt1_unman %>% 
  mutate(tt1_unmanaged_95_low = as.numeric(tt1_unmanaged_95_low),
         tt1_unmanaged_95_upp = as.numeric(tt1_unmanaged_95_upp), 
         eu = as.numeric(eu)) %>% 
  left_join(select(ttprev_eu, eu, tt1_unmanaged_adj), by = "eu") %>% 
  right_join(eu_list) %>% 
  select(eu, tt1_unmanaged_adj, tt1_unmanaged_95_low, tt1_unmanaged_95_upp) %>% 
  replace(., is.na(.), 0)
}

# merge two tables together and replace zeros with NAs based on methodology version 
tt1_eu_CIs <- bootResult_tt1 %>% 
  left_join(bootResult_tt1_unman, by = "eu") %>% 
  left_join(select(eu_cross, eu, survey_type), by = "eu") %>% 
  mutate(tt1_adj = ifelse(survey_type >= 10, NA, tt1_adj)) %>% 
  mutate(tt1_95_low = ifelse(survey_type >= 10, NA, tt1_95_low)) %>% 
  mutate(tt1_95_upp = ifelse(survey_type >= 10, NA, tt1_95_upp)) %>% 
  mutate(tt1_unmanaged_adj = ifelse(survey_type >= 10, NA, tt1_unmanaged_adj)) %>% 
  mutate(tt1_unmanaged_95_low = ifelse(survey_type >= 10, NA, tt1_unmanaged_95_low)) %>% 
  mutate(tt1_unmanaged_95_upp = ifelse(survey_type >= 10, NA, tt1_unmanaged_95_upp)) %>%
  select(-survey_type)

# remove temporary tables
rm(bootResult_tt1, bootResult_tt1_unman)

### END ###
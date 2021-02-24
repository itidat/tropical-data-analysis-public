## Tropical Data standard analyses - write trichiasis bootstrapping results

# for zero cases, this will create an empty dataframe  
if(length(trichEU) == 0) {
  bootResult_trich <- data.frame(eu=numeric(), trich_adj=numeric(), trich_95_low=numeric(), trich_95_upp=numeric(), stringsAsFactors=FALSE) %>% 
    bind_rows(eu_list) %>% 
    replace(., is.na(.), 0)
} else {
  bootResult_trich <- bootResult_trich %>% 
  mutate(trich_95_low = as.numeric(trich_95_low),
         trich_95_upp = as.numeric(trich_95_upp),
         eu = as.numeric(eu)) %>% 
  left_join(select(ttprev_eu, eu, trich_adj), by = "eu") %>% 
  right_join(eu_list) %>% 
  select(eu, trich_adj, trich_95_low, trich_95_upp) %>% 
  replace(., is.na(.), 0)
}

# for zero cases, this will create an empty dataframe 
if(length(trich_unmanagedEU) == 0) {
  bootResult_trich_unman <- data.frame(eu=numeric(), trich_unmanaged_adj=numeric(), trich_unmanaged_95_low=numeric(), trich_unmanaged_95_upp=numeric(), stringsAsFactors=FALSE) %>% 
    bind_rows(eu_list) %>% 
    replace(., is.na(.), 0)
} else {
  bootResult_trich_unman <- bootResult_trich_unman %>% 
  mutate(trich_unmanaged_95_low = as.numeric(trich_unmanaged_95_low),
         trich_unmanaged_95_upp = as.numeric(trich_unmanaged_95_upp), 
         eu = as.numeric(eu)) %>% 
  left_join(select(ttprev_eu, eu, trich_unmanaged_adj), by = "eu") %>%
  right_join(eu_list) %>% 
  select(eu, trich_unmanaged_adj, trich_unmanaged_95_low, trich_unmanaged_95_upp) %>% 
  replace(., is.na(.), 0)
}

# merge two tables together and replace zeros with NAs based on methodology version 
trich_eu_CIs <- bootResult_trich %>% 
  left_join(bootResult_trich_unman, by = "eu") %>% 
  left_join(select(eu_cross, eu, survey_type), by = "eu") %>% 
  mutate(trich_adj = ifelse(survey_type >= 10, NA, trich_adj)) %>% 
  mutate(trich_95_low = ifelse(survey_type >= 10, NA, trich_95_low)) %>% 
  mutate(trich_95_upp = ifelse(survey_type >= 10, NA, trich_95_upp)) %>% 
  mutate(trich_unmanaged_adj = ifelse(survey_type >= 10, NA, trich_unmanaged_adj)) %>% 
  mutate(trich_unmanaged_95_low = ifelse(survey_type >= 10, NA, trich_unmanaged_95_low)) %>% 
  mutate(trich_unmanaged_95_upp = ifelse(survey_type >= 10, NA, trich_unmanaged_95_upp)) %>%
  select(-survey_type)

# remove temporary tables
rm(bootResult_trich, bootResult_trich_unman)

### END ###
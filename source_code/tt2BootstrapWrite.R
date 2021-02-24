## Tropical Data standard analyses - write TT v2 bootstrapping results

# for zero cases, this will create an empty dataframe 
if(length(tt2EU) == 0) {
  bootResult_tt2 <- data.frame(eu=numeric(), tt2_adj=numeric(), tt2_95_low=numeric(), tt2_95_upp=numeric(), stringsAsFactors=FALSE) %>% 
    bind_rows(eu_list) %>% 
    replace(., is.na(.), 0)
} else {
  bootResult_tt2 <- bootResult_tt2 %>% 
    mutate(tt2_95_low = as.numeric(tt2_95_low),
           tt2_95_upp = as.numeric(tt2_95_upp), 
           eu = as.numeric(eu)) %>% 
  left_join(select(ttprev_eu, eu, tt2_adj), by = "eu") %>% 
  right_join(eu_list) %>% 
  select(eu, tt2_adj, tt2_95_low, tt2_95_upp) %>% 
  replace(., is.na(.), 0)
}

# for zero cases, this will create an empty dataframe 
if(length(tt2_unmanagedEU) == 0) {
  bootResult_tt2_unman <- data.frame(eu=numeric(), tt2_unmanaged_adj=numeric(), tt2_unmanaged_95_low=numeric(), tt2_unmanaged_95_upp=numeric(), stringsAsFactors=FALSE) %>% 
    bind_rows(eu_list) %>% 
    replace(., is.na(.), 0)
} else {
  bootResult_tt2_unman <- bootResult_tt2_unman %>% 
  mutate(tt2_unmanaged_95_low = as.numeric(tt2_unmanaged_95_low),
         tt2_unmanaged_95_upp = as.numeric(tt2_unmanaged_95_upp), 
         eu = as.numeric(eu)) %>% 
  left_join(select(ttprev_eu, eu, tt2_unmanaged_adj), by = "eu") %>% 
  right_join(eu_list) %>% 
  select(eu, tt2_unmanaged_adj, tt2_unmanaged_95_low, tt2_unmanaged_95_upp) %>% 
  replace(., is.na(.), 0)
}

# merge two tables together and replace zeros with NAs based on methodology version 
tt2_eu_CIs <- bootResult_tt2 %>% 
  left_join(bootResult_tt2_unman, by = "eu") %>% 
  left_join(select(eu_cross, eu, survey_type), by = "eu") %>% 
  mutate(tt2_adj = ifelse(survey_type < 10, NA, tt2_adj)) %>% 
  mutate(tt2_95_low = ifelse(survey_type < 10, NA, tt2_95_low)) %>% 
  mutate(tt2_95_upp = ifelse(survey_type < 10, NA, tt2_95_upp)) %>% 
  mutate(tt2_unmanaged_adj = ifelse(survey_type < 10, NA, tt2_unmanaged_adj)) %>% 
  mutate(tt2_unmanaged_95_low = ifelse(survey_type < 10, NA, tt2_unmanaged_95_low)) %>% 
  mutate(tt2_unmanaged_95_upp = ifelse(survey_type < 10, NA, tt2_unmanaged_95_upp)) %>%
  select(-survey_type)


# remove temporary tables
rm(bootResult_tt2, bootResult_tt2_unman)

### END ###
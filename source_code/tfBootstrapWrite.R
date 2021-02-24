## Tropical Data standard analyses - write TF bootstrapping results

# for zero cases, this will create an empty dataframe and CIs will default to zero
if(length(tfEU) == 0) {
  tfprev_eu_CIs <- data.frame(eu=numeric(), tf_adj=numeric(), tf_95_low=numeric(), tf_95_upp=numeric(), stringsAsFactors=FALSE) %>% 
    bind_rows(eu_list) %>% 
    replace(., is.na(.), 0)
} else {
  tfprev_eu_CIs <- bootResult_tf %>% 
    mutate(tf_95_low = as.numeric(tf_95_low),
           tf_95_upp = as.numeric(tf_95_upp),
           eu = as.numeric(eu)) %>% 
    left_join(select(tfprev_eu, eu, tf_adj), by = "eu") %>% 
    right_join(eu_list) %>% 
    select(eu, tf_adj, tf_95_low, tf_95_upp) %>% 
    replace(., is.na(.), 0)
}

# remove temporary tables
rm(bootResult_tf)

### END ###
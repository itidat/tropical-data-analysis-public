## Tropical Data standard analyses - EU-level counts
## v. 17/02/21 

# detach plyr package
if("plyr" %in% (.packages())){
  detach("package:plyr", unload=TRUE) 
}

# generate counts for each EU (see lines 21-27 for variable descriptions)
counts_eu <- clean %>% 
  group_by(eu) %>% 
  summarize(hh_ct                       = n_distinct(instance_id_house),
            date_completed              = max(start_time),
            cluster_ct                  = count_unique(cluster),
            child_enum                  = count_unique(instance_id_res[age < 10]),
            child_ex                    = count_unique(instance_id_res[examined ==1 & age < 10]),
            adult_enum                  = count_unique(instance_id_res[age > 14]),
            adult_ex                    = count_unique(instance_id_res[examined ==1 & age > 14]))


# hh_ct: count of households 
# date_completed: the date of the last day on which field work was undertaken in the EU, based on the date settings in the smartphone
# cluster_ct: count of clusters 
# child_enum: number of 1-9 year olds enumerated 
# child_ex: number of 1-9 year olds examined
# adult_enum: number of 15+ year olds enumerated 
# adult_ex: number of 15+ year olds examined 

# generate counts of TF and TT cases by EU
# only EUs with > 0 cases will be included in bootstrapping to calculate confidence intervals (CIs)
if (ttOnly == TRUE) {
  tf_ct <- data.frame(eu=numeric(), child_tf=numeric(), stringsAsFactors=FALSE) %>% 
    bind_rows(eu_list)  
} else {
  tf_ct <- clean %>% 
    group_by(eu) %>% 
    summarize(child_tf = count_unique(instance_id_res[age < 10 & (left_eye_tf == 1 | right_eye_tf == 1)]))
}

tt_ct <- clean %>% 
  group_by(eu) %>% 
  summarize(adult_trich = count_unique(instance_id_res[age > 14 & trich == 1]),
            adult_trich_unmanaged = count_unique(instance_id_res[age > 14 & trich_unmanaged == 1]),
            adult_tt1 = count_unique(instance_id_res[age > 14 & tt1 == 1]),
            adult_tt1_unmanaged = count_unique(instance_id_res[age > 14 & tt1_unmanaged == 1]),
            adult_tt2 = count_unique(instance_id_res[age > 14 & tt2 == 1]),
            adult_tt2_unmanaged = count_unique(instance_id_res[age > 14 & tt2_unmanaged == 1]))

# create vectors of EUs with > 0 cases 
if(ttOnly == TRUE) {
  trichEU            <- subset(tt_ct$eu, tt_ct$adult_trich > 0) 
  trich_unmanagedEU  <- subset(tt_ct$eu, tt_ct$adult_trich_unmanaged > 0)
  tt1EU              <- subset(tt_ct$eu, tt_ct$adult_tt1 > 0)
  tt1_unmanagedEU    <- subset(tt_ct$eu, tt_ct$adult_tt1_unmanaged > 0)
  tt2EU              <- subset(tt_ct$eu, tt_ct$adult_tt2 > 0)
  tt2_unmanagedEU    <- subset(tt_ct$eu, tt_ct$adult_tt2_unmanaged > 0)
  
} else {
  tfEU               <- subset(tf_ct$eu, tf_ct$child_tf > 0)
  trichEU            <- subset(tt_ct$eu, tt_ct$adult_trich > 0) 
  trich_unmanagedEU  <- subset(tt_ct$eu, tt_ct$adult_trich_unmanaged > 0)
  tt1EU              <- subset(tt_ct$eu, tt_ct$adult_tt1 > 0)
  tt1_unmanagedEU    <- subset(tt_ct$eu, tt_ct$adult_tt1_unmanaged > 0)
  tt2EU              <- subset(tt_ct$eu, tt_ct$adult_tt2 > 0)
  tt2_unmanagedEU    <- subset(tt_ct$eu, tt_ct$adult_tt2_unmanaged > 0)
}

# remove temporary objects
rm(tf_ct, tt_ct)

### END ###
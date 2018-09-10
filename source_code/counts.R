if("plyr" %in% (.packages())){
  detach("package:plyr", unload=TRUE) 
}


# keep only clusters with completed data collection
clean <- subset(clean, as.integer(clean$cluster_complete) > 0)

ifelse(newOnly == TRUE, 
       clean_temp <- clean %>% anti_join(doNotRun), 
       clean_temp <- clean)

# get counts of residents of various age groups in terms of "examined" status
clean_res_ct <- clean_temp %>% 
  group_by(eu) %>% 
  summarize(
                      hh_ct                       = n_distinct(instance_id_house),
                      maxDate                     = max(start_time),
                      cluster_ct                  = count_unique(cluster),
                      child_enum                  = count_unique(instance_id_res[age < 10]),
                      child_female_enum           = count_unique(instance_id_res[age < 10 & sex ==2]),
                      child_ex                    = count_unique(instance_id_res[examined ==1 & age < 10]),
                      child_female_ex             = count_unique(instance_id_res[examined ==1 & age < 10 & sex == 2]),
                      child_abs                   = count_unique(instance_id_res[examined ==2 & age < 10]),
                      child_female_abs            = count_unique(instance_id_res[examined ==2 & age < 10 & sex == 2]),
                      child_refu                  = count_unique(instance_id_res[examined ==3 & age < 10]),
                      child_female_refu           = count_unique(instance_id_res[examined ==3 & age < 10 & sex == 2]),
                      child_oth                   = count_unique(instance_id_res[examined ==4 & age < 10]),
                      child_female_oth            = count_unique(instance_id_res[examined ==4 & age < 10 & sex == 2]),
                      adult_enum                  = count_unique(instance_id_res[age > 14]),
                      adult_female_enum           = count_unique(instance_id_res[age > 14 & sex == 2]),
                      adult_ex                    = count_unique(instance_id_res[examined ==1 & age > 14]),
                      adult_female_ex             = count_unique(instance_id_res[examined ==1 & age > 14 & sex == 2]),
                      adult_trich                 = count_unique(instance_id_res[examined ==1 & age > 14 & (tt_old_left == 1 | tt_old_right == 1)]),
                      adult_female_trich          = count_unique(instance_id_res[examined ==1 & age > 14 & sex == 2 & (tt_old_left == 1 | tt_old_right == 1)]),
                      adult_trich_unmanaged       = count_unique(instance_id_res[examined ==1 & age > 14 & tt_old_unmanaged == 1]),
                      adult_female_trich_unmanaged = count_unique(instance_id_res[examined ==1 & age > 14 & sex == 2 & tt_old_unmanaged == 1]),
                      adult_tt                    = count_unique(instance_id_res[age > 14 & tt_true == 1]),
                      adult_female_tt             = count_unique(instance_id_res[age > 14 & sex == 2 & tt_true == 1]),
                      adult_tt_unmanaged          = count_unique(instance_id_res[age > 14 & tt_unmanaged == 1]),
                      adult_female_tt_unmanaged   = count_unique(instance_id_res[age > 14 & sex == 2 & tt_unmanaged == 1]),
                      adult_trich_bilat           = count_unique(instance_id_res[age > 14 & trich_bilat == 1]),
                      adult_female_trich_bilat    = count_unique(instance_id_res[age > 14 & sex == 2 & trich_bilat == 1]),
                      adult_tt_bilat              = count_unique(instance_id_res[age > 14 & tt_bilat == 1]),
                      adult_female_tt_bilat       = count_unique(instance_id_res[age > 14 & sex == 2 & tt_bilat == 1]),
                      adult_trich_postop_eyes     = sum(trich_postop_eyes[age > 14]),
                      adult_female_trich_postop_eyes = sum(trich_postop_eyes[age > 14 & sex == 2]),
                      adult_tt_postop_eyes        = sum(tt_postop_eyes[age > 14]),
                      adult_female_tt_postop_eyes = sum(tt_postop_eyes[age > 14 & sex == 2]),
                      adult_trich_postop_bilat    = count_unique(instance_id_res[age > 14 & (trich_postop_left == 1 & trich_postop_right == 1)]),
                      adult_female_trich_postop_bilat = count_unique(instance_id_res[age > 14 & sex == 2 & (trich_postop_left == 1 & trich_postop_right == 1)]),
                      adult_tt_postop_bilat       = count_unique(instance_id_res[age > 14 & (tt_postop_left == 1 & tt_postop_right == 1)]),
                      adult_female_tt_postop_bilat = count_unique(instance_id_res[age > 14 & sex ==2 & (tt_postop_left == 1 & tt_postop_right == 1)]),
                      adult_trich_unmanaged_bilat = count_unique(instance_id_res[age > 14 & (tt_old_unmanaged_right == 1 & tt_old_unmanaged_left == 1)]),
                      adult_female_trich_unmanaged_bilat = count_unique(instance_id_res[age > 14 & sex == 2 & (tt_old_unmanaged_right == 1 & tt_old_unmanaged_left == 1)]), 
                      adult_tt_unmanaged_bilat    = count_unique(instance_id_res[age > 14 & (tt_unmanaged_right ==1 & tt_unmanaged_left == 1)]),
                      adult_female_tt_unmanaged_bilat    = count_unique(instance_id_res[age > 14 & sex == 2 & (tt_unmanaged_right ==1 & tt_unmanaged_left == 1)]),
                      adult_trich_postop_unmanaged      = count_unique(instance_id_res[age > 14 & trich_postop_unmanaged == 1]),
                      adult_female_trich_postop_unmanaged      = count_unique(instance_id_res[age > 14 & sex == 2 & trich_postop_unmanaged == 1]),
                      adult_tt_postop_unmanaged         = count_unique(instance_id_res[age > 14 & tt_postop_unmanaged == 1]),
                      adult_female_tt_postop_unmanaged         = count_unique(instance_id_res[age > 14 & sex == 2 & tt_postop_unmanaged == 1]),
                      adult_abs                   = count_unique(instance_id_res[examined ==2 & age > 14]),
                      adult_female_abs            = count_unique(instance_id_res[examined ==2 & age > 14 & sex == 2]),
                      adult_refu                  = count_unique(instance_id_res[examined ==3 & age > 14]),
                      adult_female_refu           = count_unique(instance_id_res[examined ==3 & age > 14 & sex == 2]),
                      adult_oth                   = count_unique(instance_id_res[examined ==4 & age > 14]),
                      adult_female_oth            = count_unique(instance_id_res[examined ==4 & age > 14 & sex == 2]),
                      mid_enum                    = count_unique(instance_id_res[age > 9 & age < 15]),
                      mid_female_enum             = count_unique(instance_id_res[age > 9 & age < 15 & sex == 2]),
                      mid_ex                      = count_unique(instance_id_res[examined ==1 & age > 9 & age < 15]),
                      mid_female_ex               = count_unique(instance_id_res[examined ==1 & age > 9 & age < 15 & sex == 2]),
                      mid_abs                     = count_unique(instance_id_res[examined ==2 & age > 9 & age < 15]),
                      mid_female_abs              = count_unique(instance_id_res[examined ==2 & age > 9 & age < 15 & sex == 2]),
                      mid_refu                    = count_unique(instance_id_res[examined ==3 & age > 9 & age < 15]),
                      mid_female_refu             = count_unique(instance_id_res[examined ==3 & age > 9 & age < 15 & sex == 2]),
                      mid_oth                     = count_unique(instance_id_res[examined ==4 & age > 9 & age < 15]),
                      mid_female_oth              = count_unique(instance_id_res[examined ==4 & age > 9 & age < 15 & sex == 2]))


if (ttOnly == TRUE) {
  clean_res_ct2 <- clean_temp %>% 
    group_by(eu) %>% 
    summarize(adult_trich_lowerOnly        = count_unique(instance_id_res[examined == 1 & ((left_eye_lower_tt == 1 & left_eye_upper_tt != 1) |
                                                                                       (right_eye_lower_tt == 1 & right_eye_upper_tt != 1))]),
              adult_female_trich_lowerOnly = count_unique(instance_id_res[examined == 1 &  sex == 2 & ((left_eye_lower_tt == 1 & left_eye_upper_tt != 1) |
                                                                                                         (right_eye_lower_tt == 1 & right_eye_upper_tt != 1))]))
  } else {
    clean_res_ct2 <- clean_temp %>% 
      group_by(eu) %>% 
      summarize(child_tf        = count_unique(instance_id_res[age < 10 & (left_eye_tf == 1 | right_eye_tf == 1)]),
                child_female_tf = count_unique(instance_id_res[age < 10 &  sex == 2 & (left_eye_tf ==1 | right_eye_tf ==1)]),
                child_ti        = count_unique(instance_id_res[age < 10 & (left_eye_ti == 1 | right_eye_ti == 1)]),
                child_female_ti = count_unique(instance_id_res[age < 10 &  sex == 2 & (left_eye_ti ==1 | right_eye_ti ==1)]))
  }

clean_res_ct <- clean_res_ct %>%
  left_join(clean_res_ct2, by = "eu")


# merge tables together
clean_counts <- clean_res_ct %>% 
  left_join(select(survey_type, eu, survey_type), by = "eu")

clean_counts <- clean_counts %>% 
  left_join(eu_status, by = "eu")

## Calculate "data items"

# for standard prev surveys
clean_counts <- clean_counts %>%
  mutate(
    dataItems = case_when(
      survey_type == 3 & (as.numeric(eu) > 49999 | as.numeric(eu) < 40000) 
      ~
        (clean_counts$cluster_ct * 3) + (hh_ct * 5) + 
        ((adult_ex + mid_ex + child_ex)*21) +
        ((adult_enum - adult_ex + child_enum - child_ex + mid_enum - mid_ex) * 17),
      as.numeric(eu) < 50000 & as.numeric(eu) > 30000 
      ~
        (clean_counts$cluster_ct * 3) + (hh_ct * 21) + 
        ((adult_ex + mid_ex + child_ex)*26) +
        ((adult_enum - adult_ex + child_enum - child_ex + mid_enum - mid_ex) * 17),
      TRUE 
      ~ 
        (clean_counts$cluster_ct * 3) + (hh_ct * 21) + 
        ((adult_ex + mid_ex + child_ex)*23) +
        ((adult_enum - adult_ex + child_enum - child_ex + mid_enum - mid_ex) * 17)))

euList <- clean_counts[,1]

if(ttOnly == TRUE) {
  trichEU           <- subset(clean_counts$eu, clean_counts$adult_trich > 0) 
  trich_unmanagedEU <- subset(clean_counts$eu, clean_counts$adult_trich_unmanaged > 0)
  ttEU              <- subset(clean_counts$eu, clean_counts$adult_tt > 0)
  tt_unmanagedEU    <- subset(clean_counts$eu, clean_counts$adult_tt_unmanaged > 0)
} else {
tiEU              <- subset(clean_counts$eu, clean_counts$child_ti > 0)
tfEU              <- subset(clean_counts$eu, clean_counts$child_tf > 0)
trichEU           <- subset(clean_counts$eu, clean_counts$adult_trich > 0) 
trich_unmanagedEU <- subset(clean_counts$eu, clean_counts$adult_trich_unmanaged > 0)
ttEU              <- subset(clean_counts$eu, clean_counts$adult_tt > 0)
tt_unmanagedEU    <- subset(clean_counts$eu, clean_counts$adult_tt_unmanaged > 0)
}
#rm(clean_res_ct, survey_type, eu_status, clean_temp)

### END ###
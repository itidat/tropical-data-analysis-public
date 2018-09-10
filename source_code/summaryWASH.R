
# keep only clusters with completed data collection
clean$cluster_complete <- as.integer(clean$cluster_complete)
clean <- subset(clean, clean$cluster_complete > 0)
# clean <- subset(clean, eu==10044)

# remove all duplicated entries
clean_hh<- subset(clean, !duplicated(clean["instance_id_house"]))

#library(plyr)

# function to count unique, non-missing observations
count_unique <- function(x){length(which(!is.na(unique(x))))}

in_nums <- c(1,2,3,4,5,7,9)

clean_hh <- clean_hh %>% 
  mutate(drink_imp_yard = case_when(((clean_hh$w1_drink_source %in% c(1,2) & clean_hh$w2_get_drink_water == 0) |
                                      (clean_hh$w1_drink_source %in% in_nums & clean_hh$w2_get_drink_water == 1)) ~ 1, TRUE ~ 0),
         wash_imp_yard = case_when(((clean_hh$w3_wash_water %in% c(1,2) & clean_hh$w4_get_wash_water == 0) |
                                      (clean_hh$w3_wash_water %in% in_nums & clean_hh$w4_get_wash_water == 1)) ~ 1, TRUE ~ 0),
         drink_imp_30 = case_when(((clean_hh$w1_drink_source %in% c(1,2) & clean_hh$w2_get_drink_water == 0) | 
                                     (clean_hh$w1_drink_source %in% in_nums & clean_hh$w2_get_drink_water %in% c(1,2))) ~ 1, TRUE ~ 0),
         wash_imp_30 = case_when(((clean_hh$w3_wash_water %in% c(1,2) & clean_hh$w4_get_wash_water == 0) |
                                    (clean_hh$w3_wash_water %in% in_nums & clean_hh$w4_get_wash_water %in% c(1,2))) ~ 1, TRUE ~ 0))
wash <- clean_hh %>%   
  group_by(eu) %>% 
  summarize(hh_ct          = count_unique(instance_id_house),
            drink_imp      = count_unique(instance_id_house[w1_drink_source %in% in_nums]),
            wash_imp       = count_unique(instance_id_house[w3_wash_water %in% in_nums]),
            drink_near     = count_unique(instance_id_house[w2_get_drink_water %in% c(1,2)]),
            wash_near      = count_unique(instance_id_house[w4_get_wash_water %in% c(0,1,2)]),
            latrine_imp    = count_unique(instance_id_house[s2_see_latrine %in% c(in_nums, 6)]),
            hw             = count_unique(instance_id_house[h1_distance == 1]),
            drink_yard     = count_unique(instance_id_house[drink_imp_yard == 1]),
            wash_yard      = count_unique(instance_id_house[wash_imp_yard == 1]),
            drink_imp_yard = count_unique(instance_id_house[drink_imp_yard == 1]),
            wash_imp_yard  = count_unique(instance_id_house[wash_imp_yard == 1]),
            drink_imp_30   = count_unique(instance_id_house[drink_imp_30 == 1]),
            wash_imp_30    = count_unique(instance_id_house[wash_imp_30 == 1]))

# get summary columns

wash <- wash %>% 
  mutate(percent_drink_imp   = wash$drink_imp/wash$hh_ct,
         percent_wash_imp    = wash$wash_imp/wash$hh_ct,
         percent_drink_near  = wash$drink_near/wash$hh_ct,
         percent_wash_near   = wash$wash_near/wash$hh_ct,
         percent_latrine_imp = wash$latrine_imp/wash$hh_ct,
         percent_hw          = wash$hw/wash$hh_ct,
         percent_wash_yard   = wash$wash_imp_yard/wash$hh_ct,
         percent_wash_30     = wash$wash_imp_30/wash$hh_ct)

### END ###
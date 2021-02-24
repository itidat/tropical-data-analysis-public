## Tropical Data standard analyses - WASH calculations
## v. 22/02/21 

# create an object with one row per unique household ID 
clean_hh <- subset(clean, !duplicated(clean[c("eu", "instance_id_house")]))

# create a function to count unique observations
count_unique <- function(x){length(which(!is.na(unique(x))))}

# generate WASH counts for each EU (see lines 28-31 for variable definitions)  
# w2_get_drink_minutes is only included in clean tables that have used v2 methodology - the ifelse handles this exception
if("w2_get_drink_minutes" %in% colnames(clean_hh)) {
  wash <- clean_hh %>%   
    group_by(eu) %>% 
    summarize(hh_ct          = count_unique(instance_id_house),
              drink_imp      = count_unique(instance_id_house[w1_drink_source %in% c(1,2,3,4,5,7,9,10,12,13,14)]), 
              drink_near     = count_unique(instance_id_house[as.integer(w2_get_drink_minutes) < 30 | w2_get_drink_water %in% c(1,2)]), 
              latrine_imp    = count_unique(instance_id_house[s2_see_latrine %in% c(1,2,3,5,6,7,9,13)])) 
} else {
  wash <- clean_hh %>%   
    group_by(eu) %>% 
    summarize(hh_ct          = count_unique(instance_id_house),
              drink_imp      = count_unique(instance_id_house[w1_drink_source %in% c(1,2,3,4,5,7,9,10,12,13,14)]), 
              drink_near     = count_unique(instance_id_house[w2_get_drink_water %in% c(1,2)]), 
              latrine_imp    = count_unique(instance_id_house[s2_see_latrine %in% c(1,2,3,5,6,7,9,13)])) 
}

# hh_ct: count of households
# drink_imp: count of households with an 'improved' drinking water source
# drink_near: count of households with a drinking water source where collection time is < 30 min 
# latrine_imp: count of households with an 'improved' latrine 


# generate WASH proportions for each EU (see lines 41-43 for variable definitions)  
wash_eu <- wash %>% 
  mutate(w1_drink_agg        = wash$drink_imp/wash$hh_ct, 
         w2_get_drink_agg    = wash$drink_near/wash$hh_ct, 
         s2_latrine_agg      = wash$latrine_imp/wash$hh_ct) %>% 
  select(eu, w1_drink_agg, w2_get_drink_agg, s2_latrine_agg)

# w1_drink_agg: proportion of households with an 'improved' drinking water source   
# w2_get_drink_agg: proportion of households with a drinking water source where collection time is < 30 min 
# s2_latrine_agg: proportion of households with an 'improved' latrine 

#############################################################
################ WASH CLASSIFICATION CHANGES ################
#############################################################

# v1 surveys used the original GTMP/Tropical Data methodology and v2 surveys used the 2019 updated Tropical Data methodology
# w1_drink_agg: water source type 10 - 'Delivered water (water vendor)' counted as unimproved prior to the 2019 methodology update 
# due to the change described above, if you are analysing v1 EUs, w1_drink_agg might be higher than the final/approved analysis result
# the magnitude of the difference will depend on the number of households in the EU with that water source type

# s2_latrine_agg: latrine type 4 'Flush/pour flush to open drains' counted as improved prior to the 2019 methodology update
# due to the change described above, if you are analysing v1 EUs, s2_latrine_agg may be lower than the final/approved analysis result
# the magnitude of the difference will depend on the number of households in the EU with that latrine type 

# remove temporary objects 
rm(clean_hh, wash)

### END ###
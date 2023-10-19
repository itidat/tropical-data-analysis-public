## Tropical Data standard analyses - TT prevalence calculation 
## v. 22/02/21 

#step 1: set-up 

# create a function to count unique observations
count_unique <- function(x){length(which(!is.na(unique(x))))}

# determine max age group from the population file 
age_max <- population[nrow(population)-9,]
age_max2 <- as.character(age_max[,1])

# add adult age bands to clean table 
clean <- clean %>%
  mutate(
    age_group = case_when(
      clean$age > 14 & clean$age < 20 ~ "15_19",
      clean$age > 19 & clean$age < 25 ~ "20_24",
      clean$age > 24 & clean$age < 30 ~ "25_29",
      clean$age > 29 & clean$age < 35 ~ "30_34",
      clean$age > 34 & clean$age < 40 ~ "35_39",
      clean$age > 39 & clean$age < 45 ~ "40_44",
      clean$age > 44 & clean$age < 50 ~ "45_49",
      clean$age > 49 & clean$age < 55 ~ "50_54",
      clean$age > 54 & clean$age < 60 ~ "55_59",
      clean$age > 59 & clean$age < 65 ~ "60_64",
      clean$age > 64 & clean$age < 70 & age_max2 != "65+" ~ "65_69",
      clean$age > 64 & age_max2 == "65+" ~ "65+",
      clean$age > 69 & clean$age < 75 & age_max2 != "70+" ~ "70_74",
      clean$age > 69 & age_max2 == "70+" ~ "70+",
      clean$age > 74 & clean$age < 80 & age_max2 != "75+" ~ "75_79",
      clean$age > 74 & age_max2 == "75+" ~ "75+",
      clean$age > 79 & clean$age < 85 & age_max2 != "80+" ~ "80_84",
      clean$age > 79 & age_max2 == "80+" ~ "80+",
      clean$age > 84 & clean$age < 90 & age_max2 != "85+" ~ "85_89",
      clean$age > 84 & age_max2 == "85+" ~ "85+",
      clean$age > 89 & clean$age < 95 & age_max2 != "90+" ~ "90_94",
      clean$age > 89 & age_max2 == "90+" ~ "90+",
      clean$age > 94 & age_max2 == "95+" ~ "95+",
      TRUE ~ as.character(clean$age)))

#step 2: create and define variables for TT cases based on methodology version  
clean <- clean %>% 
  left_join(select(eu_cross, eu, survey_type), by = "eu")

# define TT variables for v2/v3 methodology surveys
if("offered_surgery_left_eye_upper" %in% colnames(clean)) {
clean <- clean %>% 
  mutate(tt2 = case_when(clean$survey_type >= 10 & (clean$left_eye_upper_tt == 1 | clean$right_eye_upper_tt == 1) ~ 1, TRUE ~ 0),
         tt2_unmanaged_left = case_when(((clean$offered_surgery_left_eye_upper == "0" | clean$offered_surgery_left_eye_upper == "8") & 
                                           (clean$offered_epi_left_eye_upper == "0" | clean$offered_epi_left_eye_upper == "8")) ~ 1, TRUE ~ 0), 
         tt2_unmanaged_right = case_when(((clean$offered_surgery_right_eye_upper == "0" | clean$offered_surgery_right_eye_upper == "8") & 
                                            (clean$offered_epi_right_eye_upper == "0" | clean$offered_epi_right_eye_upper == "8")) ~ 1, TRUE ~ 0))

clean <- clean %>% 
  mutate(tt2_unmanaged = case_when((clean$tt2_unmanaged_left == 1 | clean$tt2_unmanaged_right == 1) ~ 1, TRUE ~ 0))
} else {
  clean <- clean %>% 
    mutate(tt2 = NA,
           tt2_unmanaged_left = NA, 
           tt2_unmanaged_right = NA, 
           tt2_unmanaged = NA)
}

# define TT variables for v1 methodology surveys
clean["trich_left"] <- 0
clean["trich_right"] <- 0

ifelse(ttOnly == TRUE,
       (clean$trich_left[clean$survey_type < 10 & (clean$left_eye_upper_tt == 1 | clean$left_eye_lower_tt == 1)] <- 1),
       (clean$trich_left[clean$survey_type < 10 & clean$left_eye_tt == 1] <- 1))

ifelse(ttOnly == TRUE,
       (clean$trich_right[clean$survey_type < 10 & (clean$right_eye_upper_tt == 1 | clean$right_eye_lower_tt == 1)] <- 1),
       (clean$trich_right[clean$survey_type < 10 & clean$right_eye_tt == 1] <- 1))

clean <- clean %>% 
  mutate(trich = case_when((clean$trich_left == 1 | clean$trich_right == 1) ~ 1, TRUE ~ 0),
         unmanaged_left  = case_when(((clean$offered_surgery_left_eye == "0" | clean$offered_surgery_left_eye == "8") & 
                                       (clean$offered_epi_left_eye == "0" | clean$offered_epi_left_eye == "8")) ~ 1, TRUE ~ 0),
         unmanaged_right = case_when(((clean$offered_surgery_right_eye == "0" | clean$offered_surgery_right_eye == "8") & 
                                        (clean$offered_epi_right_eye == "0" | clean$offered_epi_right_eye == "8")) ~ 1, TRUE ~ 0),
         tt1_left  = case_when(clean$trich_left == 1 & (clean$left_eye_ts == 1 | clean$left_eye_ts == 2 | clean$left_eye_ts == 9) ~ 1, TRUE ~ 0),
         tt1_right = case_when(clean$trich_right == 1 & (clean$right_eye_ts == 1 | clean$right_eye_ts == 2 | clean$right_eye_ts == 9) ~ 1, TRUE ~ 0))

clean <- clean %>% 
  mutate(trich_unmanaged = case_when(((clean$trich_left == 1 & clean$unmanaged_left == 1) | (clean$trich_right == 1 & clean$unmanaged_right == 1)) ~ 1, TRUE ~ 0),
         tt1 = case_when((clean$tt1_left == 1 | clean$tt1_right == 1) ~ 1, TRUE ~ 0),
         tt1_unmanaged = case_when(((clean$tt1_left == 1 & clean$unmanaged_left == 1) | (clean$tt1_right == 1 & clean$unmanaged_right == 1)) ~ 1, TRUE ~ 0))

#step 3: calculate TT

# create an object 'mydb_tt' with counts of adults examined and adults with TT grouped by EU, cluster, age group, sex
mydb_tt <- clean %>%
  filter(age > 14, examined == 1) %>%
  group_by(eu, cluster, age_group, sex) %>%
  summarise(
    residents        = count_unique(instance_id_res),
    trich            = count_unique(instance_id_res[trich == 1]), 
    trich_unmanaged  = count_unique(instance_id_res[trich_unmanaged == 1]), 
    tt1              = count_unique(instance_id_res[tt1 == 1]),
    tt1_unmanaged    = count_unique(instance_id_res[tt1_unmanaged == 1]),
    tt2              = count_unique(instance_id_res[tt2 == 1]),
    tt2_unmanaged    = count_unique(instance_id_res[tt2_unmanaged == 1]))


# create the population objects by sex with the age weights from the population file 
pop_adult_male <- population[, c("age_group", "percent_age_male")]
colnames(pop_adult_male)[2] <- "age_weight"

pop_adult_fem <- population[, c("age_group", "percent_age_female")]
colnames(pop_adult_fem)[2] <- "age_weight"

# subset the 'mydb_tt' object by sex
mydb_tt_male <- subset(mydb_tt, sex == 1)
mydb_tt_fem  <- subset(mydb_tt, sex == 2)

# merge mydb_tt objects with population objects 
ttprev_male <- mydb_tt_male %>% 
  left_join(pop_adult_male, by = "age_group")

ttprev_female <- mydb_tt_fem %>% 
  left_join(pop_adult_fem, by = "age_group")

ttprev <- as.data.frame(rbind(ttprev_male, ttprev_female)) # Append the dataframes

# calculate TT by EU by completing the three steps below 

# 1. assign age-gender weights
ttprev2 <- ttprev %>%
  group_by(eu, cluster, age_group, sex) %>%
  mutate(trich            = (trich/residents) * age_weight,
         trich_unmanaged  = (trich_unmanaged/residents) * age_weight,
         tt1              = (tt1/residents) * age_weight,
         tt1_unmanaged    = (tt1_unmanaged/residents) * age_weight, 
         tt2              = (tt2/residents) * age_weight,
         tt2_unmanaged    = (tt2_unmanaged/residents) * age_weight)

# 2. aggregate to cluster level and join in survey_type to add NAs based on methodology version
ttprev_cluster <- ttprev2 %>%
  group_by(eu, cluster) %>%
  summarize(trich            = sum(trich),
            trich_unmanaged  = sum(trich_unmanaged),
            tt1              = sum(tt1),
            tt1_unmanaged    = sum(tt1_unmanaged), 
            tt2              = sum(tt2),
            tt2_unmanaged    = sum(tt2_unmanaged)) %>% 
  left_join(select(eu_cross, eu, survey_type), by = "eu") %>% 
  mutate(trich = ifelse(survey_type >= 10, NA, trich)) %>% 
  mutate(trich_unmanaged = ifelse(survey_type >= 10, NA, trich_unmanaged)) %>% 
  mutate(tt1 = ifelse(survey_type >= 10, NA, tt1)) %>% 
  mutate(tt1_unmanaged = ifelse(survey_type >= 10, NA, tt1_unmanaged)) %>% 
  mutate(tt2 = ifelse(survey_type < 10, NA, tt2)) %>% 
  mutate(tt2_unmanaged = ifelse(survey_type < 10, NA, tt2_unmanaged)) %>% 
  select(-survey_type)

# 3. aggregate to EU level 
ttprev_eu <- ttprev_cluster %>%
  group_by(eu) %>%
  summarize(trich_adj            = mean(trich),
            trich_unmanaged_adj  = mean(trich_unmanaged),
            tt1_adj              = mean(tt1),
            tt1_unmanaged_adj    = mean(tt1_unmanaged),
            tt2_adj              = mean(tt2),
            tt2_unmanaged_adj    = mean(tt2_unmanaged))

# remove temporary objects 
rm(ttprev2, ttprev, mydb_tt, mydb_tt_fem, mydb_tt_male, pop_adult_fem, pop_adult_male, ttprev_female, ttprev_male)

### END ###

### This is the code to set-up the analysis when you have internet connection
## Note that at the end of this code, you export all of the objects to the offline library for future offline use
## Beck Willis - May 15, 2018

# Set up the currentDate object for exports
currentDate <- format(Sys.Date(), "%Y%m%d")

# Set up preferences to prevent numeric value decimal places from being truncated
options(digits=10)

# Create objects to be used throughout code
projectsRow <- subset(projects, projects$name == nameProject)
projectID <- projectsRow[,c("id")]
analysisName <- projectsRow[,c("analysis_project")]
cleanName <- projectsRow[,c("clean_table_name")]

# Make eu column heading equivalent to others
# Allows for successful joining
colnames(eu_cross)[3] <- "eu"

# Get dataframe that is just eu and survey_type
# Will be appended to clean_counts table in counts.R 
survey_type <- as.data.frame(eu_cross[,c("eu", "survey_type")])
survey_type["eu_new"] <- as.character(survey_type$eu) 
survey_type <- survey_type[,c("eu_new", "survey_type")] 
colnames(survey_type)[1] <- "eu"
survey_type <- unique(survey_type)


# Check current data collection and approval phase for each EU
# Will update the dB table in write_dB.R
eu_status <- clean %>%
  group_by(eu) %>% 
  summarize(cluster_complete = max(cluster_complete),
            eu_approved      = max(eu_approved))

# Create simple list of all completed EUs in the dataset
eu_list <- eu_status[,c("eu")]

# Get the date of the pre-approval emails for all EUs already in eu_analysis_expanded
# Will serve as proxy for original analysis date
analysisDate <- eu_list %>% 
  left_join(analysisDate_retroactive)

# Load the existing eu_analysis_expanded results from dB
eu_analysis_exists <- subset(eu_analysis_all, eu_analysis_all$project_id == projectID)
doNotRun <- as.data.frame(eu_analysis_exists[,c("eu")])
colnames(doNotRun)[1] <- "eu"

# Create table of non-CI results to do a QC
eu_analysis_compare <- eu_analysis_exists[,c("eu", "tf_unadj", "tf_adj", "trich_unadj", "trich_adj", "tt_unadj", "tt_adj")]

# Create the list of EUs that are not already in the dB analysis table
# When newOnly == TRUE, only the EUs in this list will undergo bootstrapping
eu_analysis_old <- eu_analysis_exists %>% right_join(doNotRun)

eu_new <- eu_list %>% anti_join(doNotRun)

if(newOnly == TRUE) {
  euBoot <- eu_new
} else {
  euBoot <- eu_list
}

if("plyr" %in% (.packages())){
  detach("package:plyr", unload=TRUE) 
}

clean["tt_old_left"] <- 0
clean["tt_old_right"] <- 0

ifelse(ttOnly == TRUE,
       (clean$tt_old_left[clean$left_eye_upper_tt == 1 | clean$left_eye_lower_tt == 1] <- 1),
       (clean$tt_old_left[clean$left_eye_tt == 1] <- 1))

ifelse(ttOnly == TRUE,
       (clean$tt_old_right[clean$right_eye_upper_tt == 1 | clean$right_eye_lower_tt == 1] <- 1),
       (clean$tt_old_right[clean$right_eye_tt == 1] <- 1))

clean <- clean %>% 
  mutate(tt_old = case_when((clean$tt_old_left == 1 | clean$tt_old_right == 1) ~ 1, TRUE ~ 0),
         trich_bilat = case_when(clean$tt_old_left == 1 & clean$tt_old_right == 1 ~ 1, TRUE ~ 0),
         tt_old_unmanaged_right = case_when(clean$tt_old_right == 1 & (clean$offered_surgery_right_eye == "0" | clean$offered_surgery_right_eye == "8") & 
                                         (clean$offered_epi_right_eye == "0" | clean$offered_epi_right_eye == "8") ~ 1, TRUE ~ 0),
         tt_old_unmanaged_left = case_when(clean$tt_old_left == 1 & (clean$offered_surgery_left_eye == "0" | clean$offered_surgery_left_eye == "8") & 
                                        (clean$offered_epi_left_eye == "0" | clean$offered_epi_left_eye == "8") ~ 1, TRUE ~ 0),
         trich_postop_left = case_when(clean$tt_old_left == 1 & clean$offered_surgery_left_eye == 1 ~ 1, TRUE ~ 0),
         trich_postop_right = case_when(clean$tt_old_right == 1 & clean$offered_surgery_right_eye == 1 ~ 1, TRUE ~ 0),
         tt_true_left = case_when(clean$tt_old_left == 1 & (clean$left_eye_ts == 1 | clean$left_eye_ts == 2 | clean$left_eye_ts == 9) ~ 1, TRUE ~ 0),
         tt_true_right = case_when(clean$tt_old_right == 1 & (clean$right_eye_ts == 1 | clean$right_eye_ts == 2 | clean$right_eye_ts == 9) ~ 1, TRUE ~ 0))

clean <- clean %>% 
  mutate(tt_old_unmanaged = case_when((clean$tt_old_unmanaged_left == 1 | clean$tt_old_unmanaged_right == 1) ~ 1, TRUE ~ 0), 
         tt_old_unmanaged = case_when((clean$tt_old_unmanaged_left == 1 | clean$tt_old_unmanaged_right == 1) ~ 1, TRUE ~ 0),  
         trich_postop_eyes = (trich_postop_left + trich_postop_right),
         trich_postop_unmanaged = case_when((clean$trich_postop_right == 1 & clean$tt_old_unmanaged_left == 1) |
                                              (clean$trich_postop_left == 1 & clean$tt_old_unmanaged_right == 1) ~ 1, TRUE ~ 0),
         tt_true = case_when(clean$tt_true_right == 1 | clean$tt_true_left == 1 ~ 1, TRUE ~ 0),
         tt_bilat = case_when(clean$tt_true_right == 1 & clean$tt_true_left == 1 ~ 1, TRUE ~ 0),
         tt_unmanaged_left = case_when(clean$tt_true_left == 1 & (clean$offered_surgery_left_eye=="0" | clean$offered_surgery_left_eye=="8") & 
                                         (clean$offered_epi_left_eye=="0" | clean$offered_epi_left_eye=="8") ~ 1, TRUE ~ 0),
         tt_unmanaged_right = case_when(clean$tt_true_right == 1 & (clean$offered_surgery_right_eye=="0" | clean$offered_surgery_right_eye=="8") & 
                                          (clean$offered_epi_right_eye=="0" | clean$offered_epi_right_eye=="8") ~ 1, TRUE ~ 0),
         tt_postop_left = case_when(clean$tt_true_left == 1 & clean$offered_surgery_left_eye == "1" ~ 1, TRUE ~ 0),
         tt_postop_right = case_when(clean$tt_true_right == 1 & clean$offered_surgery_right_eye == "1" ~ 1, TRUE ~ 0))

clean <- clean %>% 
    mutate(tt_unmanaged = case_when((clean$tt_unmanaged_left == 1 | clean$tt_unmanaged_right == 1) ~ 1, TRUE ~ 0),
         tt_postop_eyes = (tt_postop_left + tt_postop_right),
         tt_postop_unmanaged = case_when((clean$tt_postop_right == 1 & clean$tt_unmanaged_left == 1) |
                                           (clean$tt_postop_left == 1 & clean$tt_unmanaged_right == 1) ~ 1, TRUE ~ 0))

count_unique <- function(x){length(which(!is.na(unique(x))))}

age_max <- population[nrow(population)-9,]
age_max2 <- as.character(age_max[,1])

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

if(ttOnly == TRUE) {
  clean <- clean # does nothing
} else {
mydb_tf <- clean %>%
filter(age < 10, examined == 1) %>%
group_by(eu, cluster, age) %>%
summarise(residents = count_unique(instance_id_res),
        tf_pos      = count_unique(instance_id_res[(left_eye_tf == "1" | right_eye_tf == "1")]))

colnames(mydb_tf)[3] <- "age_group"
}


if(ttOnly == TRUE) {
  clean <- clean # does nothing
} else {
mydb_ti <- clean %>%
filter(age < 10, examined == 1) %>%
group_by(eu, cluster, age) %>%
summarise(
        residents = count_unique(instance_id_res),
        ti_pos    = count_unique(instance_id_res[(left_eye_ti == "1" | right_eye_ti == "1")]))

colnames(mydb_ti)[3] <- "age_group"
}

mydb_tt <- clean %>%
filter(age > 14, examined == 1) %>%
group_by(eu, cluster, age_group, sex) %>%
summarise(
        residents        = count_unique(instance_id_res),
        tt_old           = count_unique(instance_id_res[tt_old == 1]),
        tt_old_unmanaged = count_unique(instance_id_res[tt_old_unmanaged == 1]),
        tt_true          = count_unique(instance_id_res[tt_true == 1]),
        tt_unmanaged     = count_unique(instance_id_res[tt_unmanaged == 1]))

### END ###
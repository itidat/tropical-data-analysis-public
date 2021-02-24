## Tropical Data standard analyses - TF prevalence calculation 
## v. 17/02/21 

# create an object 'mydb_tf' with counts of children examined and children with TF grouped by EU, cluster, age
mydb_tf <- clean %>%
  filter(age < 10, examined == 1) %>%
  group_by(eu, cluster, age) %>%
  summarise(residents   = count_unique(instance_id_res),
            tf_pos      = count_unique(instance_id_res[(left_eye_tf == "1" | right_eye_tf == "1")])) %>% 
  rename(age_group = age)

# create an object 'pop_child' with the age weights from the population file 
pop_child <- population %>% 
  select(age_group, percent_age_all) %>% 
  rename(age_weight = percent_age_all)

# merge the two objects above into one data frame 
tfprev <- merge(mydb_tf, pop_child, by = "age_group", all.x = TRUE)

# calculate TF by EU by completing the three steps below 

# 1. assign age-gender weights
tfprev_age <- tfprev %>%
  group_by(eu, cluster, age_group) %>%
  mutate(tf_adj = (tf_pos / residents) * age_weight)

# 2. aggregate to cluster level
tfprev_cluster <- tfprev_age %>%
  group_by(eu, cluster) %>%
  summarize(tf_adj  = sum(tf_adj))

# 3. aggregate to EU level 
tfprev_eu <- tfprev_cluster %>%
  group_by(eu) %>%
  summarize(tf_adj  = mean(tf_adj))

# remove temporary objects 
rm(mydb_tf, pop_child, tfprev, tfprev_age)

### END ###


##TF prevalence calculation
pop_child <- population[, c("age_group", "percent_age_all")]
colnames(pop_child)[2] <- "age_weight"

tfprev <- merge(mydb_tf, pop_child, by = "age_group", all.x = TRUE)

#Generate unadjusted EU-level prevalence for comparison purposes
tf_unadj_cluster <- tfprev %>%
  group_by(eu, cluster) %>%
  summarize(residents = sum(residents),
            tf_pos    = sum(tf_pos)) %>%
  mutate(tf_unadj     = tf_pos / residents)

tf_unadj_eu <- tf_unadj_cluster %>%
  group_by(eu) %>%
  summarize(tf_unadj = mean(tf_unadj))

# This creates the new column named "adj_tt" filled with zeros & then does the weighting
tfprev_age <- tfprev %>%
  group_by(eu, cluster, age_group) %>%
  mutate(tf_adj = (tf_pos / residents) * age_weight)

tfprev_cluster <- tfprev_age %>%
  group_by(eu, cluster) %>%
  summarize(tf_adj  = sum(tf_adj))

tfprev_eu <- tfprev_cluster %>%
  group_by(eu) %>%
  summarize(tf_adj  = mean(tf_adj))


rm(mydb_tf, tfprev, tfprev_age, tf_unadj_cluster)


##TI prevalence calculation
tiprev <- merge(mydb_ti, pop_child, by = "age_group", all.x = TRUE)

#Generate unadjusted EU-level prevalence for comparison purposes
ti_unadj_cluster <- tiprev %>%
  group_by(eu, cluster) %>%
  summarize(residents = sum(residents),
            ti_pos    = sum(ti_pos)) %>%
  mutate(ti_unadj     = ti_pos / residents)

ti_unadj_eu <- ti_unadj_cluster %>%
  group_by(eu) %>%
  summarize(ti_unadj = mean(ti_unadj))

# This creates the new column named "adj_tt" filled with zeros & then does the weighting
tiprev_age <- tiprev %>%
  group_by(eu, cluster, age_group) %>%
  mutate(ti_adj = (ti_pos / residents) * age_weight)

tiprev_cluster <- tiprev_age %>%
  group_by(eu, cluster) %>%
  summarise(ti_adj  = sum(ti_adj))

tiprev_eu <- tiprev_cluster %>%
  group_by(eu) %>%
  summarize(ti_adj  = mean(ti_adj))

rm(mydb_ti, tiprev, tiprev_age, pop_child, ti_unadj_cluster)

### END ###
### This code creates a dataframe with the cluster-level average GPS
## Beck Willis - May 17, 2018

gps_cluster <- clean %>% 
  filter(gps_lat != 999) %>% 
  group_by(eu, cluster) %>% 
  summarize(gps_lat_min = min(gps_lat),
            gps_lat_avg = mean(gps_lat),
            gps_lat_max = max(gps_lat),
            gps_lng_min = min(gps_lng),
            gps_lng_avg = mean(gps_lng),
            gps_lng_max = max(gps_lat),
            gps_alt_min = min(gps_alt),
            gps_alt_avg = mean(gps_alt),
            gps_alt_max = max(gps_alt),
            gps_acc_min = min(gps_acc),
            gps_acc_avg = mean(gps_acc),
            gps_acc_max = max(gps_acc))

### END ###
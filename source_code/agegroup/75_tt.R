###Create mydb_tf and mydb_tt by age groups for populations with 80 as highest adult age and single year age groups for children
###Beck Willis, Updated June 29, 2015

library(sqldf)

mydb_tt <- as.data.frame(sqldf('SELECT eu, cluster, (CASE
                 WHEN age BETWEEN 15 AND 19 THEN "15_19" 
                 WHEN age BETWEEN 20 AND 24 THEN "20_24" 
                 WHEN age BETWEEN 25 AND 29 THEN "25_29" 
                 WHEN age BETWEEN 30 AND 34 THEN "30_34" 
                 WHEN age BETWEEN 35 AND 39 THEN "35_39" 
                 WHEN age BETWEEN 40 AND 44 THEN "40_44" 
                 WHEN age BETWEEN 45 AND 49 THEN "45_49" 
                 WHEN age BETWEEN 50 AND 54 THEN "50_54" 
                 WHEN age BETWEEN 55 AND 59 THEN "55_59" 
                 WHEN age BETWEEN 60 AND 64 THEN "60_64" 
                 WHEN age BETWEEN 65 AND 69 THEN "65_69" 
                 WHEN age BETWEEN 70 AND 74 THEN "70_74" 
                 WHEN age >= 75 THEN "75+" 
                 END) AS age_group, sex,
                 COUNT(*) AS residents, 
                 SUM(CASE WHEN tt_old=1 THEN 1 ELSE 0 END) AS tt_old,
                 SUM(CASE WHEN tt_true=1 THEN 1 ELSE 0 END) AS tt_true,
                 SUM(CASE WHEN tt_unmanaged=1 THEN 1 ELSE 0 END) as tt_unmanaged,
                 SUM(CASE WHEN tt_unmanaged_old=1 THEN 1 ELSE 0 END) as tt_unmanaged_old
                 FROM clean
                 WHERE cluster_complete>0 AND examined = 1 AND age >= 15 and left_eye_upper_tt is not null
                 GROUP BY eu, cluster, age_group, sex
                 ORDER BY eu, cluster, age_group ASC, sex DESC'))

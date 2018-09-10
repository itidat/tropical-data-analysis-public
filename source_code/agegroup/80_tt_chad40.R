###Create mydb_tf and mydb_tt by age groups for populations with 80 as highest adult age and single year age groups for children
###Beck Willis, Updated June 29, 2015

library(sqldf)

mydb_tt <- as.data.frame(sqldf('SELECT eu, cluster, (CASE
                 WHEN age BETWEEN 40 AND 44 THEN "40_44" 
                 WHEN age BETWEEN 45 AND 49 THEN "45_49" 
                 WHEN age BETWEEN 50 AND 54 THEN "50_54" 
                 WHEN age BETWEEN 55 AND 59 THEN "55_59" 
                 WHEN age BETWEEN 60 AND 64 THEN "60_64" 
                 WHEN age BETWEEN 65 AND 69 THEN "65_69" 
                 WHEN age BETWEEN 70 AND 74 THEN "70_74" 
                 WHEN age BETWEEN 75 AND 79 THEN "75_79" 
                 WHEN age >= 80 THEN "80+" 
                 END) AS age_group, sex,
                 COUNT(*) AS residents, 
                 SUM(CASE WHEN tt_old=1 THEN 1 ELSE 0 END) AS tt_old,
                 SUM(CASE WHEN tt_true=1 THEN 1 ELSE 0 END) AS tt_true,
                 SUM(CASE WHEN tt_unmanaged=1 THEN 1 ELSE 0 END) as tt_unmanaged,
                 SUM(CASE WHEN tt_unmanaged_old=1 THEN 1 ELSE 0 END) as tt_unmanaged_old
                 FROM clean
                 WHERE cluster_complete>0 AND examined = 1 AND age >= 40
                 GROUP BY eu, cluster, age_group, sex
                 ORDER BY eu, cluster, age_group ASC, sex DESC'))

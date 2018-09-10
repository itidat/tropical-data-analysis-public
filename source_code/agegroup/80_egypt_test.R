###Create mydb_tf and mydb_tt by age groups for populations with 80 as highest adult age and single year age groups for children
###Beck Willis, Updated June 29, 2015

library(sqldf)
mydb_tf <- sqldf('SELECT EU, CLUSTER, (CASE 
                 WHEN AGE BETWEEN 1 AND 4 THEN "1_4" 
                 WHEN AGE BETWEEN 5 AND 9 THEN "5_9" 
                 END) AS AGE_GROUP, 
                 COUNT(INSTANCE_ID_RES) AS RESIDENTS,
                 SUM(CASE WHEN (LEFT_EYE_TF=1 OR RIGHT_EYE_TF=1) THEN 1 ELSE 0 END) AS tf_pos
                 FROM clean
                 WHERE AGE BETWEEN 1 AND 9 AND EXAMINED = 1 AND CLUSTER_COMPLETE>0
                 GROUP BY EU, CLUSTER, AGE_GROUP
                 ORDER BY EU, CLUSTER, AGE_GROUP ASC')
data.frame(mydb_tf)

mydb_tt <- sqldf('SELECT EU, CLUSTER, (CASE
                 WHEN AGE BETWEEN 15 AND 19 THEN "15_19" 
                 WHEN AGE BETWEEN 20 AND 24 THEN "20_24" 
                 WHEN AGE BETWEEN 25 AND 29 THEN "25_29" 
                 WHEN AGE BETWEEN 30 AND 34 THEN "30_34" 
                 WHEN AGE BETWEEN 35 AND 39 THEN "35_39" 
                 WHEN AGE BETWEEN 40 AND 44 THEN "40_44" 
                 WHEN AGE BETWEEN 45 AND 49 THEN "45_49" 
                 WHEN AGE BETWEEN 50 AND 54 THEN "50_54" 
                 WHEN AGE BETWEEN 55 AND 59 THEN "55_59" 
                 WHEN AGE BETWEEN 60 AND 64 THEN "60_64" 
                 WHEN AGE BETWEEN 65 AND 69 THEN "65_69" 
                 WHEN AGE BETWEEN 70 AND 74 THEN "70_74" 
                 WHEN AGE BETWEEN 75 AND 79 THEN "75_79" 
                 WHEN AGE >= 80 THEN "80+" 
                 END) AS AGE_GROUP, SEX,
                 COUNT(*) AS RESIDENTS, 
                 SUM(CASE WHEN tt_old=1 THEN 1 ELSE 0 END) AS tt_old,
                 SUM(CASE WHEN tt_true=1 THEN 1 ELSE 0 END) AS tt_true
                 FROM clean
                 WHERE CLUSTER_COMPLETE>0 AND EXAMINED = 1 AND AGE >= 15
                 GROUP BY EU, CLUSTER, AGE_GROUP, SEX
                 ORDER BY EU, CLUSTER, AGE_GROUP ASC, SEX DESC')
data.frame(mydb_tt)

###TT analysis for Paul C research
###Beck Willis, Updated October 27, 2015

district <- district[ , c("eu_id", "admin0_name", "admin1_name", "admin2_name")]
colnames(district)[1] <- "eu"
colnames(district)[2] <- "Admin0"
colnames(district)[3] <- "Admin1"
colnames(district)[4] <- "Admin2"

library(plyr)
district <- ddply(district, .(eu, Admin0, Admin1), summarise, Admin2 = paste(Admin2, collapse = ", "))

library(sqldf)

#ONLY FOR PROJECTS WITH TS Q: Export line list of residents with trichiasis & trachomatous trichiasis
clean_linelist <- subset(clean, tt_old=="1")

ifelse(("offered_epi_left_eye" %in% colnames(clean)), 
(clean_linelist <- clean_linelist[ ,c("eu","cluster","age", "sex", "left_eye_tt", "offered_surgery_left_eye", 
                                     "offered_epi_left_eye", "left_eye_ts", "right_eye_tt", "offered_surgery_right_eye", 
                                     "offered_epi_right_eye", "right_eye_ts", "tt_old", "tt_true", "tt_unmanaged")]),
(clean_linelist <- clean_linelist[ ,c("eu","cluster","age", "sex", "left_eye_tt", "offered_surgery_left_eye", 
                                     "left_eye_ts", "right_eye_tt", "offered_surgery_right_eye", 
                                     "right_eye_ts", "tt_old", "tt_true", "tt_unmanaged")]))

###Run code to produce the counts
source("source_code/expandedtt/surgery_epi_ts_gtmp.R") #clean_epi_ts subset exists

# This creates the new column named "EYES_POSTOP" filled with zeros
clean_counts_ts["EYES_POSTOP"] <- 0; 
clean_counts_ts$EYES_POSTOP <- (clean_counts_ts$POSTOP + clean_counts_ts$BILAT_POSTOP)

clean_counts_ts["EYES_POSTOP_PERCENT"] <- 0;
clean_counts_ts$EYES_POSTOP_PERCENT <- (clean_counts_ts$EYES_POSTOP / clean_counts_ts$EYES_TT)

clean_counts_ts["TT_TS_PERCENT"] <- 0;
clean_counts_ts$TT_TS_PERCENT <- (clean_counts_ts$TS_PRESENT / clean_counts_ts$TT_PRESENT)
clean_counts_ts$TT_TS_PERCENT[clean_counts_ts$CLASS!="TS"] <- NA
clean_counts_ts$TS_PRESENT[clean_counts_ts$CLASS!="TS"] <- NA

clean_counts_ts <- clean_counts_ts[ ,c(1:8,11,13,17,9,12,15,16,10,14)]


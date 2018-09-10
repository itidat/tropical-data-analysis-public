clean["tt_old_left"] <- 0
clean$tt_old_left[clean$left_eye_tt=="1"] <- 1

clean["tt_old_right"] <- 0
clean$tt_old_right[clean$right_eye_tt=="1"] <- 1

clean["tt_old"] <- 0
clean$tt_old[clean$left_eye_tt=="1"] <- 1
clean$tt_old[clean$right_eye_tt=="1"] <- 1

clean["tt_old_unmanaged_right"] <- 0

ifelse(("offered_epi_right_eye" %in% colnames(clean)), 
	(clean$tt_old_unmanaged_right[clean$right_eye_tt=="1" & clean$offered_surgery_right_eye=="0" & 
		(clean$offered_epi_right_eye=="0" | clean$offered_epi_right_eye=="8")] <- 1),
	(clean$tt_old_unmanaged_right[clean$right_eye_tt=="1" & clean$offered_surgery_right_eye=="0"] <- 1))

ifelse(("offered_epi_right_eye" %in% colnames(clean)), 
	(clean$tt_old_unmanaged_right[clean$right_eye_tt=="1" & clean$offered_surgery_right_eye=="8" & 
		(clean$offered_epi_right_eye=="0" | clean$offered_epi_right_eye=="8")] <- 1),
	(clean$tt_old_unmanaged_right[clean$right_eye_tt=="1" & clean$offered_surgery_right_eye=="8"] <- 1))

clean["tt_old_unmanaged_left"] <- 0

ifelse(("offered_epi_left_eye" %in% colnames(clean)), 
	(clean$tt_old_unmanaged_left[clean$left_eye_tt=="1" & clean$offered_surgery_left_eye=="0" & 
		(clean$offered_epi_left_eye=="0" | clean$offered_epi_left_eye=="8")] <- 1),
	(clean$tt_old_unmanaged_left[clean$left_eye_tt=="1" & clean$offered_surgery_left_eye=="0"] <- 1))

ifelse(("offered_epi_left_eye" %in% colnames(clean)), 
	(clean$tt_old_unmanaged_left[clean$left_eye_tt=="1" & clean$offered_surgery_left_eye=="8" & 
		(clean$offered_epi_left_eye=="0" | clean$offered_epi_left_eye=="8")] <- 1),
	(clean$tt_old_unmanaged_left[clean$left_eye_tt=="1" & clean$offered_surgery_left_eye=="8"] <- 1))

clean["tt_old_unmanaged"] <- 0
clean$tt_old_unmanaged[clean$tt_old_unmanaged_right==1] <- 1
clean$tt_old_unmanaged[clean$tt_old_unmanaged_left==1] <- 1


clean["tt_true_right"] <- 0
clean$tt_true_right[clean$right_eye_tt=="1" & clean$right_eye_ts=="NULL"] <- 1
clean$tt_true_right[clean$right_eye_tt=="1" & clean$right_eye_ts==""] <- 1
clean$tt_true_right[clean$right_eye_tt=="1" & clean$right_eye_ts=="1"] <- 1
clean$tt_true_right[clean$right_eye_tt=="1" & clean$right_eye_ts=="2"] <- 1
clean$tt_true_right[clean$right_eye_tt=="1" & clean$right_eye_ts=="9"] <- 1

clean["tt_true_left"] <- 0
clean$tt_true_left[clean$left_eye_tt=="1" & clean$left_eye_ts=="NULL"] <- 1
clean$tt_true_left[clean$left_eye_tt=="1" & clean$left_eye_ts==""] <- 1
clean$tt_true_left[clean$left_eye_tt=="1" & clean$left_eye_ts=="1"] <- 1
clean$tt_true_left[clean$left_eye_tt=="1" & clean$left_eye_ts=="2"] <- 1
clean$tt_true_left[clean$left_eye_tt=="1" & clean$left_eye_ts=="9"] <- 1

clean["tt_true"] <- 0
clean$tt_true[clean$tt_true_right==1] <- 1
clean$tt_true[clean$tt_true_left==1] <- 1

clean["tt_unmanaged_right"] <- 0

ifelse(("offered_epi_right_eye" %in% colnames(clean)), 
	(clean$tt_unmanaged_right[clean$tt_true_right=="1" & clean$offered_surgery_right_eye=="0" & 
	                            (clean$offered_epi_right_eye=="0" | clean$offered_epi_right_eye=="8")] <- 1),
	(clean$tt_unmanaged_right[clean$tt_true_right=="1" & clean$offered_surgery_right_eye=="0"] <- 1))

ifelse(("offered_epi_right_eye" %in% colnames(clean)), 
	(clean$tt_unmanaged_right[clean$tt_true_right=="1" & clean$offered_surgery_right_eye=="8" & 
	                            (clean$offered_epi_right_eye=="0" | clean$offered_epi_right_eye=="8")] <- 1),
	(clean$tt_unmanaged_right[clean$tt_true_right=="1" & clean$offered_surgery_right_eye=="8"] <- 1))

clean["tt_unmanaged_left"] <- 0

ifelse(("offered_epi_left_eye" %in% colnames(clean)), 
	(clean$tt_unmanaged_left[clean$tt_true_left=="1" & clean$offered_surgery_left_eye=="0" & 
	                           (clean$offered_epi_left_eye=="0" | clean$offered_epi_left_eye=="8")] <- 1),
	(clean$tt_unmanaged_left[clean$tt_true_left=="1" & clean$offered_surgery_left_eye=="0"] <- 1))

ifelse(("offered_epi_left_eye" %in% colnames(clean)), 
	(clean$tt_unmanaged_left[clean$tt_true_left=="1" & clean$offered_surgery_left_eye=="8" & 
	                           (clean$offered_epi_left_eye=="0" | clean$offered_epi_left_eye=="8")] <- 1),
	(clean$tt_unmanaged_left[clean$tt_true_left=="1" & clean$offered_surgery_left_eye=="8"] <- 1))

clean["tt_unmanaged"] <- 0
clean$tt_unmanaged[clean$tt_unmanaged_right==1] <- 1
clean$tt_unmanaged[clean$tt_unmanaged_left==1] <- 1


updateQuery <- data.frame(eu = character(), updateQuery = character(), stringsAsFactors = FALSE)

for (i in 1:nlevels(as.factor(analysis_insert$eu))) {
  analysis_insert_temp <- subset(analysis_insert, eu==levels(as.factor(eu))[i])
  updateQuery_temp <- if (ttOnly == TRUE) {
    paste("update ignore sdk_tropicaldata.eu_analysis_expanded set date_completed = STR_TO_DATE('", analysis_insert_temp$maxDate, "', '%Y-%c-%e %T'), trich_unadj = ", analysis_insert_temp$trich_unadj, ", trich_95_low = ", analysis_insert_temp$trich_95_low,
          ", trich_95_upp = ", analysis_insert_temp$trich_95_upp, ", trich_unmanaged_unadj = ", analysis_insert_temp$trich_unmanaged_unadj, ", trich_unmanaged_adj = ",
          analysis_insert_temp$trich_unmanaged_adj, ", trich_unmanaged_95_low = ", analysis_insert_temp$trich_unmanaged_95_low, ", trich_unmanaged_95_upp = ", 
          analysis_insert_temp$trich_unmanaged_95_upp, ", tt_unmanaged_unadj = ", analysis_insert_temp$tt_unmanaged_unadj, ", tt_unmanaged_95_low = ", analysis_insert_temp$tt_unmanaged_95_low,
          ", tt_unmanaged_95_upp = ", analysis_insert_temp$tt_unmanaged_95_upp, ", adult_trich_ct = ", analysis_insert_temp$adult_trich, ", adult_female_trich_ct = ", 
          analysis_insert_temp$adult_female_trich, ", adult_tt_ct = ", analysis_insert_temp$adult_tt, ", adult_female_tt_ct = ", analysis_insert_temp$adult_female_tt,
          ", adult_trich_bilat = ", analysis_insert_temp$adult_trich_bilat, ", adult_female_trich_bilat = ", analysis_insert_temp$adult_female_trich_bilat, ", adult_trich_lowerOnly = ",
          analysis_insert_temp$adult_trich_lowerOnly, ", adult_female_trich_lowerOnly = ", analysis_insert_temp$adult_female_trich_lowerOnly, ", adult_tt_bilat = ", analysis_insert_temp$adult_tt_bilat,
          ", adult_female_tt_bilat = ", analysis_insert_temp$adult_female_tt_bilat, ", adult_trich_postop_eyes = ", analysis_insert_temp$adult_trich_postop_eyes, ", adult_female_trich_postop_eyes = ",
          analysis_insert_temp$adult_female_trich_postop_eyes, ", adult_female_tt_postop_eyes = ", analysis_insert_temp$adult_female_tt_postop_eyes, ", adult_tt_postop_eyes = ", 
          analysis_insert_temp$adult_tt_postop_eyes, ", adult_trich_postop_bilat = ", analysis_insert_temp$adult_trich_postop_bilat, ", adult_female_trich_postop_bilat = ", 
          analysis_insert_temp$adult_female_trich_postop_bilat, ", adult_tt_postop_bilat = ", analysis_insert_temp$adult_tt_postop_bilat, ", adult_female_tt_postop_bilat = ", 
          analysis_insert_temp$adult_female_tt_postop_bilat, ", adult_trich_unmanaged_ct = ", analysis_insert_temp$adult_trich_unmanaged, ", adult_female_trich_unmanaged_ct = ",
          analysis_insert_temp$adult_female_trich_unmanaged, ", adult_trich_unmanaged_bilat = ", analysis_insert_temp$adult_trich_unmanaged_bilat, ", adult_female_trich_unmanaged_bilat = ", 
          analysis_insert_temp$adult_female_trich_unmanaged_bilat, ", adult_tt_unmanaged_ct = ", analysis_insert_temp$adult_tt_unmanaged, ", adult_female_tt_unmanaged_ct = ",
          analysis_insert_temp$adult_female_tt_unmanaged, ", adult_tt_unmanaged_bilat = ", analysis_insert_temp$adult_tt_unmanaged_bilat, ", adult_female_tt_unmanaged_bilat = ", 
          analysis_insert_temp$adult_female_tt_unmanaged_bilat, ", adult_trich_postop_unmanaged_ct = ", analysis_insert_temp$adult_trich_postop_unmanaged, 
          ", adult_female_trich_postop_unmanaged_ct = ", analysis_insert_temp$adult_female_trich_postop_unmanaged, ", adult_tt_postop_unmanaged_ct = ", 
          analysis_insert_temp$adult_tt_postop_unmanaged, ", adult_female_tt_postop_unmanaged_ct = ", analysis_insert_temp$adult_female_tt_postop_unmanaged, ", adult_enum = ", analysis_insert_temp$adult_enum, ", adult_female_enum = ", analysis_insert_temp$adult_female_enum, 
          ", adult_ex = ", analysis_insert_temp$adult_ex, ", adult_female_ex = ", analysis_insert_temp$adult_female_ex, ", adult_abs = ", analysis_insert_temp$adult_abs, ", adult_female_abs = ", 
          analysis_insert_temp$adult_female_abs, ", adult_refu = ", analysis_insert_temp$adult_refu, ", adult_female_refu = ", analysis_insert_temp$adult_female_refu, ", adult_oth = ", 
          analysis_insert_temp$adult_oth, ", adult_female_oth = ", analysis_insert_temp$adult_female_oth, ", child_enum = ", analysis_insert_temp$child_enum, ", child_female_enum = ",
          analysis_insert_temp$child_female_enum, ", child_ex = ", analysis_insert_temp$child_ex, ", child_female_ex = ", analysis_insert_temp$child_female_ex, ", child_abs = ", 
          analysis_insert_temp$child_abs, ", child_female_abs = ", analysis_insert_temp$child_female_abs, ", child_refu = ", analysis_insert_temp$child_refu, ", child_female_refu = ", 
          analysis_insert_temp$child_female_refu, ", child_oth = ", analysis_insert_temp$child_oth, ", child_female_oth = ", analysis_insert_temp$child_female_oth, ", mid_enum = ", 
          analysis_insert_temp$mid_enum, ", mid_female_enum = ", analysis_insert_temp$mid_female_enum, ", mid_ex = ", analysis_insert_temp$mid_ex, ", mid_female_ex = ", analysis_insert_temp$mid_female_ex, 
          ", mid_abs = ", analysis_insert_temp$mid_abs, ", mid_female_abs = ", analysis_insert_temp$mid_female_abs, ", mid_refu = ", analysis_insert_temp$mid_refu, ", mid_female_refu = ", 
          analysis_insert_temp$mid_female_refu, ", mid_oth = ", analysis_insert_temp$mid_oth, ", mid_female_oth = ", analysis_insert_temp$mid_female_oth, 
          ", analysis_date = NOW() where eu = ", analysis_insert_temp$eu,";", sep = '')
  } else {
    paste("update ignore sdk_tropicaldata.eu_analysis_expanded set date_completed = STR_TO_DATE('", analysis_insert_temp$maxDate, "', '%Y-%c-%e %T'), ti_unadj = ", analysis_insert_temp$ti_unadj, ", ti_adj = ", analysis_insert_temp$ti_adj, ", ti_95_low = ", analysis_insert_temp$ti_95_low,
          ", ti_95_upp = ", analysis_insert_temp$ti_95_upp, ", trich_unadj = ", analysis_insert_temp$trich_unadj, ", trich_95_low = ", analysis_insert_temp$trich_95_low,
          ", trich_95_upp = ", analysis_insert_temp$trich_95_upp, ", trich_unmanaged_unadj = ", analysis_insert_temp$trich_unmanaged_unadj, ", trich_unmanaged_adj = ",
          analysis_insert_temp$trich_unmanaged_adj, ", trich_unmanaged_95_low = ", analysis_insert_temp$trich_unmanaged_95_low, ", trich_unmanaged_95_upp = ", 
          analysis_insert_temp$trich_unmanaged_95_upp, ", tt_unmanaged_unadj = ", analysis_insert_temp$tt_unmanaged_unadj, ", tt_unmanaged_95_low = ", analysis_insert_temp$tt_unmanaged_95_low,
          ", tt_unmanaged_95_upp = ", analysis_insert_temp$tt_unmanaged_95_upp, ", adult_trich_ct = ", analysis_insert_temp$adult_trich, ", adult_female_trich_ct = ", analysis_insert_temp$adult_female_trich,
          ", adult_tt_ct = ", analysis_insert_temp$adult_tt, ", adult_female_tt_ct = ", analysis_insert_temp$adult_female_tt,
          ", adult_trich_bilat = ", analysis_insert_temp$adult_trich_bilat, ", adult_female_trich_bilat = ", analysis_insert_temp$adult_female_trich_bilat, ", adult_tt_bilat = ", analysis_insert_temp$adult_tt_bilat,
          ", adult_female_tt_bilat = ", analysis_insert_temp$adult_female_tt_bilat, ", adult_trich_postop_eyes = ", analysis_insert_temp$adult_trich_postop_eyes, ", adult_female_trich_postop_eyes = ",
          analysis_insert_temp$adult_female_trich_postop_eyes, ", adult_female_tt_postop_eyes = ", analysis_insert_temp$adult_female_tt_postop_eyes, ", adult_tt_postop_eyes = ", 
          analysis_insert_temp$adult_tt_postop_eyes, ", adult_trich_postop_bilat = ", analysis_insert_temp$adult_trich_postop_bilat, ", adult_female_trich_postop_bilat = ", 
          analysis_insert_temp$adult_female_trich_postop_bilat, ", adult_tt_postop_bilat = ", analysis_insert_temp$adult_tt_postop_bilat, ", adult_female_tt_postop_bilat = ", 
          analysis_insert_temp$adult_female_tt_postop_bilat, ", adult_trich_unmanaged_ct = ", analysis_insert_temp$adult_trich_unmanaged, ", adult_female_trich_unmanaged_ct = ",
          analysis_insert_temp$adult_female_trich_unmanaged, ", adult_trich_unmanaged_bilat = ", analysis_insert_temp$adult_trich_unmanaged_bilat, ", adult_female_trich_unmanaged_bilat = ", 
          analysis_insert_temp$adult_female_trich_unmanaged_bilat, ", adult_tt_unmanaged_ct = ", analysis_insert_temp$adult_tt_unmanaged, ", adult_female_tt_unmanaged_ct = ",
          analysis_insert_temp$adult_female_tt_unmanaged, ", adult_tt_unmanaged_bilat = ", analysis_insert_temp$adult_tt_unmanaged_bilat, ", adult_female_tt_unmanaged_bilat = ", 
          analysis_insert_temp$adult_female_tt_unmanaged_bilat, ", adult_trich_postop_unmanaged_ct = ", analysis_insert_temp$adult_trich_postop_unmanaged, 
          ", adult_female_trich_postop_unmanaged_ct = ", analysis_insert_temp$adult_female_trich_postop_unmanaged, ", adult_tt_postop_unmanaged_ct = ", 
          analysis_insert_temp$adult_tt_postop_unmanaged, ", adult_female_tt_postop_unmanaged_ct = ", analysis_insert_temp$adult_female_tt_postop_unmanaged, ", drink_imp = ", 
          analysis_insert_temp$drink_imp, ", wash_imp = ", analysis_insert_temp$wash_imp, ", drink_near = ", analysis_insert_temp$drink_near, ", wash_near = ", analysis_insert_temp$wash_near, ", latrine_imp = ",
          analysis_insert_temp$latrine_imp, ", hw = ", analysis_insert_temp$hw, ", drink_imp_yard = ", analysis_insert_temp$drink_imp_yard, ", wash_imp_yard = ", analysis_insert_temp$wash_imp_yard, ", drink_imp_30 = ", 
          analysis_insert_temp$drink_imp_30, ", wash_imp_30 = ", analysis_insert_temp$wash_imp_30, ", adult_enum = ", analysis_insert_temp$adult_enum, ", adult_female_enum = ", analysis_insert_temp$adult_female_enum, 
          ", adult_ex = ", analysis_insert_temp$adult_ex, ", adult_female_ex = ", analysis_insert_temp$adult_female_ex, ", adult_abs = ", analysis_insert_temp$adult_abs, ", adult_female_abs = ", 
          analysis_insert_temp$adult_female_abs, ", adult_refu = ", analysis_insert_temp$adult_refu, ", adult_female_refu = ", analysis_insert_temp$adult_female_refu, ", adult_oth = ", 
          analysis_insert_temp$adult_oth, ", adult_female_oth = ", analysis_insert_temp$adult_female_oth, ", child_enum = ", analysis_insert_temp$child_enum, ", child_female_enum = ",
          analysis_insert_temp$child_female_enum, ", child_ex = ", analysis_insert_temp$child_ex, ", child_female_ex = ", analysis_insert_temp$child_female_ex, ", child_tf = ", analysis_insert_temp$child_tf,
          ", child_female_tf = ", analysis_insert_temp$child_female_tf, ", child_ti = ", analysis_insert_temp$child_ti, ", child_female_ti = ", analysis_insert_temp$child_female_ti, ", child_abs = ", 
          analysis_insert_temp$child_abs, ", child_female_abs = ", analysis_insert_temp$child_female_abs, ", child_refu = ", analysis_insert_temp$child_refu, ", child_female_refu = ", 
          analysis_insert_temp$child_female_refu, ", child_oth = ", analysis_insert_temp$child_oth, ", child_female_oth = ", analysis_insert_temp$child_female_oth, ", mid_enum = ", 
          analysis_insert_temp$mid_enum, ", mid_female_enum = ", analysis_insert_temp$mid_female_enum, ", mid_ex = ", analysis_insert_temp$mid_ex, ", mid_female_ex = ", analysis_insert_temp$mid_female_ex, 
          ", mid_abs = ", analysis_insert_temp$mid_abs, ", mid_female_abs = ", analysis_insert_temp$mid_female_abs, ", mid_refu = ", analysis_insert_temp$mid_refu, ", mid_female_refu = ", 
          analysis_insert_temp$mid_female_refu, ", mid_oth = ", analysis_insert_temp$mid_oth, ", mid_female_oth = ", analysis_insert_temp$mid_female_oth, 
          ", analysis_date = NOW() where eu = ", analysis_insert_temp$eu,";", sep = '')
  }
  eu_temp <- as.character(analysis_insert$eu[i])
  updateQuery[i,] <- c(eu_temp, updateQuery_temp)
}


write.csv(updateQuery, paste("Box Sync/R_WD/R_WD_TD/td_results/offline_results/update_queries/", nameProject, "_updateQuery_",currentDate,".csv",sep=""))
 
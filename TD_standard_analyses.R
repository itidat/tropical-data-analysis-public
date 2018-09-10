###Calculating GTMP unadjusted and adjusted TF prevalence from exported file
###Beck Willis, complete overhaul on May 15, 2018

library(RPostgreSQL)
library(RMySQL)
library(tidyverse)

# Select appropriate working directory (There has to be a way to automate this!!)
setwd("~path/tropical-data-analysis")
#setwd("C:/Users/krenneker/Box Sync/R_WD/R_WD_TD")
#setwd("C:/Users/abakhtiari/Box Sync/R_WD/R_WD_TD")

##Change this to match "name" in projects table in public schema
######MANUALLY CHANGE TO MATCH NAME OF POP FILE
population<- read.csv("population/demo_population.csv", stringsAsFactors = FALSE, sep = ",")

#Manually change to match the project "name" in projects table of public schema
nameProject <- "demo"

# Change this to FALSE if you DO want to analyse EUs that already have results in eu_analysis_expanded
newOnly <- TRUE

# Change this to TRUE if you are doing a TT-only analysis
ttOnly  <- FALSE

# Leave this as FALSE when you have connection. Only change to TRUE when you are unable to connect
# NOTE: if you are disconnected, you will still require access to R_WD_TD working directory
offline <- FALSE #NOTE: if you mark this as "TRUE", you will need to have full dataset in WD and uncomment below line starting with "clean <- "

# ONLY UPDATE & UN-COMMENT BELOW LINE WHEN WORKING OFFLINE
# NOTE: projectSetup_offline.R source code will not run correctly unless the below line is run first
clean <- as.data.frame(read.csv(demo_clean.csv, stringsAsFactors = FALSE))

#####################################################
###############END OF MANUAL CHANGES#################
#####################################################

## Generate data frames necessary to run analysis
## NOTE: you may see some warnings that appear when you run the below piece of code [...]
## check to make sure you have objects clean, population, approval_log, [...]
## eu_cross, eu_analysis_all before proceeding
source("source_code/projectSetup_offline.R")


## Do final prep of data frames for analysis
source("source_code/analysisPrep.R") # will run whether offline or online

## WASH summary code. Will not run for TT-only projects because they don't include WASH data
ifelse(ttOnly == TRUE,
       clean <- clean, #does nothing
       source("source_code/summaryWASH.R"))

## Cluster-level GPS data
source("source_code/clusterGPS.R")

ifelse(ttOnly == TRUE,
       clean <- clean, #does nothing
       source("source_code/tf_ti_prev.R"))

source("source_code/trichiasis_prev.R") # will run for standard and TT-only

## Create results set to QC prior to bootstrapping, which takes ages
## Also exports cluster-level results for future QC, to facilitate future QC
source("source_code/resultsQuick.R") # will run for standard and TT-only

## Create results set to QC
## NOTE: this QC code runs the analysis for all EUs, regardless of newOnly [...]
## this is because a discrepancy could point to a larger issue that should be [...]
## resolved before continuing with the analysis.
## DAT internal note: if you get flag here, likely due to previously-deleted results being added back
source("source_code/resultsQC.R") # will run for standard and TT-only

##Set-up the various TT categories for analyses
source("source_code/counts.R") # will run for standard and TT-only

# Calculate confidence intervals
# NOTE: if there aren't any cases, the CIs will default to zero and the analysis won't run
# NOTE2: All bootstrap code has built-in export to "td_results/td_results_bootstrap_save" folder, just in cases
if(ttOnly == TRUE) {
  clean <- clean # does nothing
} else {
# Based on your entry for "newOnly", this code may remove extra EUs to speed up analysis
# If "newOnly" set to FALSE, prev_cluster dfs will be unaffected
if(newOnly == TRUE) {
  tiprev_cluster2 <- tiprev_cluster %>% anti_join(doNotRun, by = "eu")
  tfprev_cluster2 <- tfprev_cluster %>% anti_join(doNotRun, by = "eu")
} else {
  tiprev_cluster2 <- tiprev_cluster
  tfprev_cluster2 <- tfprev_cluster
}
  if(length(tiEU) > 0) {
    source("source_code/tiBootstrapRun.R")
    source("source_code/tiBootstrapWrite.R")
  } else {
    source("source_code/tiBootstrapWrite.R")
    print("No need to calculate TI 95% confidence intervals due to zero TI cases")
  }
  
  if(length(tfEU) > 0) {
    source("source_code/tfBootstrapRun.R")
    source("source_code/tfBootstrapWrite.R")
  } else {
    source("source_code/tfBootstrapWrite.R")
    print("No need to calculate TF 95% confidence intervals due to zero TF cases")
  }
}

if(length(trichEU) >0) {
  source("source_code/trichBootstrapRun.R") # will run for standard and TT-only, alike
  source("source_code/trichBootstrapWrite.R") # will run for standard and TT-only, alike
} else {
  source("source_code/trichBootstrapWrite.R") # will run for standard and TT-only, alike
}

if(length(ttEU) > 0) {
  source("source_code/ttBootstrapRun.R") # will run for standard and TT-only, alike
  source("source_code/ttBootstrapWrite.R") # will run for standard and TT-only, alike
} else {
  source("source_code/ttBootstrapWrite.R") # will run for standard and TT-only, alike
}

## Write analysis results to working directory
source("source_code/writeAnalysisResults.R") # will run for standard and TT-only, alike

## Write new results to dB
source("source_code/writeResults_offline.R")

### END ###
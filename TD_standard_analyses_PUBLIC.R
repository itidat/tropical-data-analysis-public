## Tropical Data standard analyses - public version - v1/v2/v3 methodology combined 
## v. 9 September 2025
## Please refer to the README file for instructions on how to use this code 

# Install required packages 
if (!requireNamespace("rstudioapi", quietly = TRUE)) {
  install.packages("rstudioapi")}

if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")}

# load and update packages
library(tidyverse)
library(rstudioapi)
update.packages("dplyr")

# get the source file location and set this as the working directory 
current_path <- rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))
# alternatively, you can run line 21 after manually replacing ~path with the path to the folder where you saved the contents of the ZIP folder downloaded from GitHub
#setwd("~path/tropical-data-analysis-public-master")

#####################################################
############ BEGINNING OF MANUAL CHANGES ############
#####################################################

# set this object to TRUE if you are analysing TT-only EUs 
ttOnly  <- FALSE

# Tropical Data creates population files based on publicly available census data; email support@tropicaldata.org if you would like us to share your project's file
# change the file name in "" to match the name of the population file saved in your working directory 
population <- read.csv("country_population.csv", stringsAsFactors = FALSE, sep = ",")

# download the 'Aggregated EU crosswalk' under the section 'Clean Individual-level Datasets (all EUs)' in your project's Downloads module *available for users with the data downloader role* 
# change the file name in "" to match the name of the EU crosswalk file saved in your working directory 
eu_cross <- as.data.frame(read.csv("country-eu_cross_aggregated.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM"))

# download the 'Partial clean dataset without PII' under the section 'Clean Individual-level Datasets (only fully approved EUs)' in your project's Downloads module *available for users with the data downloader role* 
# change the file name in "" to match the name of the clean dataset file saved in your working directory
clean <- as.data.frame(read.csv("td_country_clean-approved.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM"))

#####################################################
############### END OF MANUAL CHANGES ###############
#####################################################

# limit the 'clean' object to include only fully approved EUs
clean <- subset(clean, eu_approved == 2)

# set the 'currentDate' object to be appended to the results file exported to your working directory 
currentDate <- format(Sys.Date(), "%Y%m%d")

# set the number of digits for numeric values
options(digits=10)

# generate a list of EUs from the 'clean' dataset 
eu_list <- clean %>%  
  distinct(eu) %>% 
  arrange(eu)

# NOTE: you do not need to open the source_code files referenced below to run them but you can refer to them if you would like more info on how the figures are generated

# run the source code file to calculate WASH proportions  
# TT-only projects do not include WASH data - for these projects, this code will generate an empty dataframe
ifelse(ttOnly == TRUE,
       wash_eu <- data.frame(eu=numeric(), w1_drink_agg=numeric(), w2_get_drink_agg=numeric(), s2_latrine_agg=numeric(), stringsAsFactors=FALSE) %>% 
         bind_rows(eu_list), 
       source("source_code/WASH.R"))

# run the source code file to calculate TF prevalence 
# TT-only projects do not include TF data - for these projects, this code will generate an empty dataframe
ifelse(ttOnly == TRUE,
       tfprev_eu <- data.frame(eu=numeric(), tf_adj=numeric(), stringsAsFactors=FALSE) %>% 
         bind_rows(eu_list),
       source("source_code/tfPrev.R"))

# run the source code file to calculate TT prevalence 
# this code will run for both standard and TT-only projects 
source("source_code/ttPrev.R") 

# run the source code file to calculate other EU-level counts 
# this code will run for both standard and TT-only projects 
source("source_code/counts.R") 

# calculate confidence intervals (CIs) for TF, Trichiasis and Trichiasis + TS (v1 methodology), TT (v2/v3 methodology) 
# CIs will default to zero for EUs with zero cases
if(ttOnly == TRUE) {
  tfprev_eu_CIs <- data.frame(eu=numeric(), tf_adj=numeric(), tf_95_low=numeric(), tf_95_upp=numeric(), stringsAsFactors=FALSE) %>% 
    bind_rows(eu_list) 
} else {
  if(length(tfEU) > 0) {
    source("source_code/tfBootstrapRun.R")
    source("source_code/tfBootstrapWrite.R")
  } else {
    source("source_code/tfBootstrapWrite.R")
    print("No need to calculate TF 95% confidence intervals due to zero TF cases")
  }
}

if(length(trichEU) > 0) {
  source("source_code/trichBootstrapRun.R") 
  source("source_code/trichBootstrapWrite.R") 
} else {
  source("source_code/trichBootstrapWrite.R") 
  print("No need to calculate Trichiasis 95% confidence intervals due to zero Trichiasis cases (v1 methodology)")
}

if(length(tt1EU) > 0) {
  source("source_code/tt1BootstrapRun.R") 
  source("source_code/tt1BootstrapWrite.R") 
} else {
  source("source_code/tt1BootstrapWrite.R") 
  print("No need to calculate Trichiasis+TS 95% confidence intervals due to zero Trichiasis+TS cases (v1 methodology)")
}

if(length(tt2EU) > 0) {
  source("source_code/tt2BootstrapRun.R") 
  source("source_code/tt2BootstrapWrite.R") 
} else {
  source("source_code/tt2BootstrapWrite.R") 
  print("No need to calculate TT 95% confidence intervals due to zero TT cases (v2/v3 methodology)")
}

# run the source code file to merge analysis results and write them to a file in your working directory
# please refer to the data dictionary on the Github page for variable descriptions
source("source_code/writeAnalysisResults.R")

### END ###

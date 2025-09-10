#### Greetings! 

##### With the aim of supporting our collaborative relationships with health ministries and of promoting the importance of reproducibility in scientific research, we are happy to share this public code repository for the standard analyses we perform as part of the Tropical Data service. For more information about the Tropical Data service, please refer to our [website](https://www.tropicaldata.org/).

##### We hope you find this repository useful and we encourage you to send comments and/or questions to our support email address at support@tropicaldata.org. 

##### 1) Get started by downloading this code repository as a ZIP folder by using the green download button above. Once downloaded, you will extract the zipped contents to a folder on your PC. Please take note of this folder path - it will be your working directory (WD) where you will save files to be imported and find your exported results.   

##### 2) Next, you will download your "Aggregated EU crosswalk" and your "Full clean dataset including PII (for fully approved EUs)" from the project's downloads page on the Tropical Data data management webiste. See screenshot below for the correct download links. There are also demo_country-eu_cross_aggregated.csv and demo_td_country_clean-approved.csv files included above - these files are only to show the basic table structures and should NOT be used for analyses.

######      Note: you will need the "Data Downloader - Full Access" role for the project on the Tropical Data website to be able to download these files. 

######      Note: you will need to use the (csv) links when downloading these files. 

![Tropical Data Downloads module](/images/GitHub_Downloads_screenshot.png)

##### 3) You will also need your project-specific population file derived from publicly-available census data. You can submit a request for an already-prepared file by sending an email to our support email address at support@tropicaldata.org. There is a demo_population.csv file included above - this file is only to show the basic table structure and should NOT be used for analyses.

######      Note: you will need to save the aggregated EU crosswalk, full clean dataset, and population files in the same folder from step 1. See screenshot below for an example of a complete working directory. 

![Tropical Data Downloads module](/images/GitHub_WD_screenshot.png)

##### 4) After completing the steps above, you are ready to run an analysis! You will open the main file (TD_standard_analyses_PUBLIC.R) and make the necessary changes in the "MANUAL CHANGES" section, as outlined below: 

######      Line 28: change to TRUE if you are running an analysis for 'TT-only' EUs

######      Line 32: reference the name of the population file saved in your WD

######      Line 36: reference the name of the "Aggregated EU crosswalk" file saved in your WD

######      Line 40: reference the name of the "Full clean dataset" file saved in your WD

###### NOTE: check that your utils package (The R utils package) is at least version 4.5.1 in your package library. If not, please update your R version and the utils package before running this code.

##### 5) After making the changes outlined above, run the entire script. 

##### NOTE: this analysis code includes bootstrapping to calculate confidence intervals. A higher number of EUs and/or a higher number of trachoma cases will result in a longer running time for the various bootstrap source code files. You will see a STOP SIGN in your RStudio console while these source code files are running. Histograms for each measure and each EU will appear in the "Plots" tab.

##### 6) Once the analysis has finished running, the results will be exported to your working directory (WD) with the file name analysis_results_COUNTRY_DATE.csv. Please use the data_dictionary_analysis.xlsx file included above for definitions of the variables in the results output. 

##### NOTE: this analysis code was written to allow you to analyse EUs that used the original Tropical Data methodology (v1), EUs that used the 2019 updated Tropical Data methodology (v2), and EUs that used the 2023 updated Tropical Data methodology (v3).  

##### NOTE: this analysis code is fit for use for standard Tropical Data surveys. If your surveys included additional questions/options for operational research and/or programmatic decision making, this code will need to be adapted before use.    

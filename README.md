With the aim of supporting our collaborative relationships with health ministries and of promoting the importance of reproducibility in scientific research, we are happy to share this public code repository for the standard analyses we perform as part of the Tropical Data service. For more information about the Tropical Data service, please refer to our website https://www.tropicaldata.org.

We hope you find this repository useful and we encourage you to send comments and/or questions to our support email address at support@tropicaldata.org. 

## 1) Get started by downloading this code repository as a ZIP folder by using the green download button above

Once downloaded, you will extract the zipped contents to a folder on your PC. Please take note of this folder path - you will need it to set your working directory in line 17 of the main file (TD_standard_analyses_PUBLIC.R). 

## 2) Download your District to EU crosswalk and your MOH full approved dataset

https://www.tropicaldata.org/downloads

See screenshot below for correct download links. There are also demo_eu_cross.csv and demo_clean.csv files included above - these files are only to present the basic table structures and should NOT be used for analyses.

> Note: you will need "downloader" access on the Tropical Data website to be able to download these files. 
> Note: you will need to use the (csv) links when downloading these files. 

![Tropical Data Downloads module](/images/GitHub_Downloads_screenshot.png)

## 3) Prepare your project-specific population file derived from publicly-available census data

You can submit a request for an already-prepared file by sending an email to our support email address at support@tropicaldata.org. There is a demo_population.csv file included above - this file is only to present the basic table structure and should NOT be used for analyses.

> Note: you will need to save the EU crosswalk, full approved dataset, and population files in the same folder from step 1. See screenshot below for an example of a complete working directory.  

![Tropical Data Downloads module](/images/GitHub_WD_screenshot.png)

## 4) Run an analysis 

You will open the main file (TD_standard_analyses_PUBLIC.R) and make the necessary changes in the "MANUAL CHANGES" section, as outlined below: 

```
Line 17: edit the path to your working directory (WD)
Line 20: change to TRUE if you are running an analysis for 'TT-only' EUs
Line 23: reference the name of the population file saved in your WD
Line 27: reference the name of the District to EU crosswalk file saved in your WD
Line 31: reference the name of the MOH full approved dataset file saved in your WD
```

## 5) After making the changes outlined above, run the entire script

Once the analysis has finished running, the results will be exported to your WD. These results can be used with the District Report template available for download here: https://www.tropicaldata.org/downloads. See screenshot below for correct download links. 

![Tropical Data Downloads module](/images/GitHub_Templates_screenshot.png)

> Note: this analysis code was written to allow you to analyse EUs that used the original GTMP/Tropical Data methodology (v1) and EUs that used the 2019 updated Tropical Data methodology (v2).    

> Note: this analysis code is fit for use for standard Tropical Data surveys. If your surveys included additional questions/options for operational research and/or programmatic decision making, this code will need to be adapted before use. 
   
> Note: this analysis code includes bootstrapping to calculate confidence intervals. A higher number of EUs and/or a higher number of trachoma cases will result in a longer running time for the various bootstrap source code files. You will see a STOP SIGN in your RStudio console while these source code files are running. Histograms for each measure and each EU will appear in the "Plots" tab. 

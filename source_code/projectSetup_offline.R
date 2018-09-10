### This is the code to set-up the analysis when you have internet connection
## Note that at the end of this code, you export all of the objects to the offline library for future offline use
## Beck Willis - May 15, 2018

## Get objects from offline library when not connected to internet
## NOTE: in order for "clean" object to be generated, must have saved dataset in working directory

clean <- subset(clean, cluster_complete>0)
eu_cross <- as.data.frame(read.csv("offline_library/eu_cross.csv"))
eu_analysis_all <- as.data.frame(read.csv("offline_library/eu_analysis_all.csv"))
projects <- as.data.frame(read.csv("offline_library/projects.csv"))
  
projectsRow <- subset(projects, projects$name == nameProject)
projectID <- projectsRow[,c("id")]
analysisName <- projectsRow[,c("analysis_project")]

### END ###
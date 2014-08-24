## run_Analysis.R written to create a tidy dataset for the Getting and Cleaning Data
## course project.  
## this makes use of the Human Activity Recognition Using Smartphone Dataset
## The solution relies heavily on the help posted by Community TA David Hood.
## lecture notes by Jeff Leak and hints posted by others.  Thank you.
## Rebecca Black, August 24, 2014


## check to make sure data directory exists, if not create it
if (!file.exists("./data/")) {dir.create("./data")}

target_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
target_localfile <- ("./data/UCI HAR Dataset.zip")
download.file(target_url, target_localfile) 


## load necessary libraries
library(reshape2)

## 1. read data into dataframes
        ## to merge properly - always "train" data first, then "test"
        
        TrainDF <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
        TestDF <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
        
        SubjectTrainDF <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
        SubjectTestDF <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
        
        ActivityTrainDF <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
        ActivityTestDF <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
        
        FeatureNamesDF <- read.table("./data/UCI HAR Dataset/features.txt")
        ActivityLabelsDF <- read.table("./data/UCI HAR Dataset/activity_labels.txt", col.names=c("Activity_ID","Activity_Name")) 

## 2. put the data together
        ## create vector for features.txt data.  This is the 561 variable names which need
        ## to be appended to the merged dataframe to give the columns appropriate labels 
        FeatureColnames <- FeatureNamesDF[,2]
        
        ## give the Train and Test DFs column names so rbind will work
        colnames(TrainDF) <- FeatureColnames
        colnames(TestDF) <- FeatureColnames
        
        ## use rbind to merge TrainDF and TestDF
        ComboTrainTestDF <- rbind(TrainDF, TestDF)
        
        ## give the SubjectTrainDf and SubjectTestDF column names so rbind will work
        colnames(SubjectTrainDF) <- "Subject_ID"
        colnames(SubjectTestDF) <- "Subject_ID"
        
        ## use rbind to merge SubjectTrainDF and SubjectTestDF
        ComboSubjectTrainTestDF <- rbind(SubjectTrainDF, SubjectTestDF)
        
        ## give the ActivityTrainDF and ActivityTestDF column names so rbind will work
        colnames(ActivityTrainDF) <- "Activity_ID"
        colnames(ActivityTestDF) <- "Activity_ID"
        
        ## use rbind to merge ActivityTrainDF and ActivityTestDF
        ComboActivityTrainTestDF <- rbind(ActivityTrainDF, ActivityTestDF)

#3. Pick out the mean and standard deviation columns
        ## reduce columns and create DF with only mean() and std() columns from ComboTrainTestDF
        MeanStdTrainTestDF <- ComboTrainTestDF[, grep('mean()|std()',FeatureNamesDF$V2)]

#4. Put the data together with cbind
        ## use cbind to add Activities and Subjects to the clean data set
        ComboDataDF <- cbind(ComboSubjectTrainTestDF, ComboActivityTrainTestDF, MeanStdTrainTestDF)
        
#5. Add descriptive acitivity names
        ## merge in the activity labels for easier reading and reporting
        ActivityNamesDF <- merge(ActivityLabelsDF,ComboDataDF,by.x="Activity_ID",by.y="Activity_ID", all=TRUE)

#6. Create an independent tidy dataset (write) with the average of each variable for each activity
## and each subject
        ## use reshape2 functions to melt a tall-skinny dataframe and get the mean dcast
        ## from Reshaping data lecture
        ComboMeltDF <- melt(ActivityNamesDF,id=c("Activity_ID", "Activity_Name", "Subject_ID"))
        CleanWithMeanDF <- dcast(ComboMeltDF, Activity_ID + Activity_Name + Subject_ID ~ variable,mean)

        write.table(CleanWithMeanDF,"tidy_data.txt", row.name=FALSE)

TidyDataProject2
================
ReadMe.md – written for Getting and Cleaning Data class project.  8/23/2014 by Rebecca Black.
The purpose of this file is to explain the thinking and organization behind the solution to the “Tidy Dataset Resulting from Split, Apply, Combine of the Human Activity Recognition Using Smartphones Dataset”.  
The variables, values, and metadata descriptions are detailed in CodeBook.md available here:
Tidy dataset location:
Github repository with script run_analysis.R: Rebecca_black
The original data for the project is here: Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Breakdown of run_analysis.R
1.	Merge the training and the test sets to create one dataset
2.	Extract only the measurements on the mean and standard deviation for each measurement
3.	Use descriptive activity names
4.	Label the dataset with the descriptive activity names
5.	Create an independent tidy data set with the average of each variable for each activity and each subject

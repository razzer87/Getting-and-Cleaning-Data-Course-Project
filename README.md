Getting-and-Cleaning-Data-Course-Project
========================================

This is my course project for the Getting and Cleaning Data coursera course.

The *run_analysis.R* file is the script for turning the Samsung data into a tidy data set. The data can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip Before running this script, you need to unzip this folder into your working directory.

This script requires the data.table and reshape2 libraries to process.

The script defines a function that replaces the numeric values from the y activities with the names as defined by activity.txt and replaces the column names for the measurement data with the names as defined in features.txt. It outputs a table where the first two columns are "Subject" and "Activity" and the rest are the mean and std values of measurements as defined by the original codebook.

The script will then call this function to create tables for the training and test data, and then use rbind to bind them together.

Finally, it reshapes the table so each row represents a unique subject and activity pair. The first two columns identify the subject and activity and the rest will be the mean of all the the instances of the specific measurement for that pair. It will the write this table to a file named output.txt.

While this is a wide dataset, I figured that this set up would allow very east use of the data in the following analysis. The codebook.txt file explains what all the column values refer to.
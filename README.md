# run_analysis.R

## Purpose

Implements the steps described in the course project for "Getting and Cleaning Data".

Those steps are:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Dependencies

* plyr
* reshape2
* data.table

## How to run

1. load R
2. source('run\_analysis.R')
3. run\_analysis()


## Output

1. mean\_and\_std\_measurments.table: The result of step 1 through step 4
2. variable\_means\_by\_activity\_and\_subject.table: The result of step 5

## Implementation details

The data will be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip if not already present.

Only variable names matching -mean() and -std() are kept as specify by the assignments.

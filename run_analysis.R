library(plyr)
library(reshape2)
library(data.table)

run_analysis <- function(){
  if(!file.exists('UCI HAR Dataset')){
    # Download the zip file and extract it
    download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                  destfile='uci.zip',
                  method='curl')
    unzip('uci.zip')
  }
  
  #Load the features.txt file and only keep those that are mean or std measurements.
  features <- read.table(file='UCI HAR Dataset/features.txt', sep='', header=FALSE);
  mean_feature_logic <- grepl('-mean()', features[,2], fixed=TRUE);
  std_feature_logic <- grepl('-std()', features[,2], fixed=TRUE);
  keeping_logic = mean_feature_logic | std_feature_logic
  features_to_keep <- features[keeping_logic, ];
  features_index <- features_to_keep[,1]
  features_names <- features_to_keep[,2]
  features_names <- gsub("\\(\\)","", features_names) #Removing the ()
  
  
  #Loading train and test data
  train_data <- read.table('UCI HAR Dataset/train/X_train.txt', sep='', header=FALSE)
  test_data <- read.table('UCI HAR Dataset/test/X_test.txt', sep='', header=FALSE)
  
  #STEP 1: Concat both data set
  concatenated_result <- rbind(train_data, test_data)
  #STEP 2: Extract only mean and std measurements
  mean_and_std_data <- concatenated_result[,features_index] #keeping only the features we wants
  #STEP 3: Uses descriptive activity names to name the activities in the data set
  activities <- read.table(file='UCI HAR Dataset/activity_labels.txt', sep='', header=FALSE)
  train_labels <- read.table('UCI HAR Dataset/train/y_train.txt', header=FALSE)
  test_labels <- read.table('UCI HAR Dataset/test/y_test.txt', header=FALSE)
  labels <- rbind(train_labels, test_labels)
  mean_and_std_data$Activity <- activities[labels[,1], 2]
  
  #Step 4: Appropriately labels the data set with descriptive variable names. 
  colnames(mean_and_std_data) <- c(as.character(features_names), 'Activity') #Assigning meaningful names to the columns  
  
  write.table(mean_and_std_data, file='mean_and_std_measurements.table', row.names=FALSE) #This is the first tidy data file
  
  #Step 5: Data set with the average of each variable for each activity and each subject
  train_subjects <- read.table('UCI HAR Dataset/train/subject_train.txt', header=FALSE)
  test_subjects <- read.table('UCI HAR Dataset/test/subject_test.txt', header=FALSE)
  subjects <- rbind(train_subjects, test_subjects)
  mean_and_std_data$Subject <- as.factor(subjects[,1])
  molten <- melt(mean_and_std_data, id.vars=c('Subject', 'Activity')) #Regrouping columns by Subject and Activity
  dt_molten <- data.table(molten)
  dt_molten <- dt_molten[, avg:= mean(value), by= list(Subject, Activity, variable)] 
  dt_molten <- dt_molten[, list(Subject, Activity, variable, avg)] #dropping the value column
  dt_molten <- unique(dt_molten) # removing duplicates
  write.table(dt_molten, 'variable_means_by_activity_and_subject.table')
  dt_molten
}
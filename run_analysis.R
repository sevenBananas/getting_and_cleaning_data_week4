## This script should complete the following

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average 
##    of each variable for each activity and each subject.

## STEP 1 (Merges the training and the test sets to create one data set.)
## get the data
## data_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## file_name <- basename(data_URL)
## download.file(data_URL, file_name)
## unzip(file_name)

## read in the data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## add names for the activities and columns
column_names <- read.table("./UCI HAR Dataset/features.txt")[, 2]
names(subject_test) <- "subject_id"
names(subject_train) <- "subject_id"
names(x_test) <- column_names
names(x_train) <- column_names
names(y_test) <- "activity"
names(y_train) <- "activity"

## combine into one dataset
test_data <- cbind(subject_test, y_test, x_test)
train_data <- cbind(subject_train, y_train, x_train)
all_data <- rbind(test_data, train_data)

## STEP 2 (Extracts only the measurements on the mean and standard deviation for each measurement.)
## find the columns with the data we want
mean_std_columns <- grepl("mean|std", names(all_data))

## keep the subject_id and activity columns
mean_std_columns[1:2] <- TRUE

## just get the data we want
mean_std_data <- all_data[, mean_std_columns]


## STEP 3 (Uses descriptive activity names to name the activities in the data set)
## get the activity names
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
mean_std_data$activity <- activity_names[mean_std_data$activity]

## STEP 4 (Appropriately labels the data set with descriptive variable names.)
## this has been done along the way, and the data set is currently in this state

## STEP 5 (From the data set in step 4, creates a second, independent tidy data set with the average
##         of each variable for each activity and each subject.)
library(dplyr)
tidy_df <- mean_std_data %>% group_by(subject_id, activity) %>% summarize_all(funs(mean))
write.table(tidy_df, file = "./tidy_data.txt", row.name = FALSE)





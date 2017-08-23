###############################################################
## Getting and Cleaning Data, Project - Week 4 - Peer Assesment
###############################################################

## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set.
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Preliminaries. (Get and) load required packages.
if (!require("data.table")) install.packages("data.table")
if (!require("dplyr")) install.packages("dplyr")
if (!require("reshape2")) install.packages("reshape2")

packages <- c("data.table", "dplyr", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

## Download the UCI data set.
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./UCI HAR Dataset.zip")) download.file(fileUrl, destfile = "./UCI HAR Dataset.zip", method = "curl")
if (!file.exists("./UCI HAR Dataset")) unzip("./UCI HAR Dataset.zip", exdir = "./")

## Set the path to the working directory and the UCI data.
path     <- getwd()
path_UCI <- file.path(path, "UCI HAR Dataset")


## Load activity labels.
activity_labels <- fread(file.path(path_UCI, "activity_labels.txt"))[,2]

## Load data column names.
features <- read.table(file.path(path_UCI, "features.txt"))[,2]

## Extract only the measurements on the mean and standard deviation for each measurement.
## Note that \\(\\) is important to avoid including the meanFreq and angle variables.
## After extraction, use gsup to remove perentheses from the variable names.
extract_features <- grepl("mean\\(\\)|std\\(\\)", features)
features <- gsub("\\(\\)", "", features)
features <- gsub("-", "_", features)

## Load the test/train data (X-files), activities (Y-files) and subject file.
test_subject   <- fread(file.path("UCI HAR Dataset/test", "subject_test.txt"))
test_activity  <- fread(file.path("UCI HAR Dataset/test", "Y_test.txt"))
test_data      <- fread(file.path("UCI HAR Dataset/test", "X_test.txt"))

train_subject  <- fread(file.path("UCI HAR Dataset/train", "subject_train.txt"))
train_activity <- fread(file.path("UCI HAR Dataset/train", "Y_train.txt"))
train_data     <- fread(file.path("UCI HAR Dataset/train", "X_train.txt"))

## Merge the test and train data. Convert to data.frame and rename using the features.
data = rbind(test_data, train_data)
data <- as.data.frame(data)
names(data) = features

## Extract only the measurements on the mean and standard deviation for each measurement.
data = data[,extract_features]

## Bind activity labels.
activity <- rbind(test_activity, train_activity)
activity <- as.data.frame(activity)

## Use "activity_labels" to pair "activity_id" to descriptive activity names.
activity[,2] = activity_labels[activity[,1]]
colnames(activity) = c("activity_id", "activity")

## Bind subjects.
subject <- rbind(test_subject, train_subject)
subject <- as.data.frame(subject)
colnames(subject) = c("subject")

## Bind data with subject ID, and use descriptive activity names
## to name the activities in the data set.
data <- cbind(subject, activity, data)

## Melt the data to a tall format before calculating the mean.
## Melt anything but the "id_labels".
id_labels   = c("subject", "activity_id", "activity")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

## Apply mean function to dataset using the dcast function.
tidy_data   = dcast(melt_data, formula = subject + activity ~ variable, mean)

## Make the tidy datafile.
file_name <- "./DatasetHumanActivityRecognitionUsingSmartphones.txt"
write.table(tidy_data, file = file_name, row.name=FALSE)
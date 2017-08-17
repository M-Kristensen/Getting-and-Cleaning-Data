---
title: "Getting and Cleaning Data:<br> Peer Assessment Week 4"
output: 
  html_document:
    keep_md: true
---



The data set (Human Activity Recognition Using Smartphones) is from the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). Information about the data file can be found in README.txt, features.txt and features_info.txt, and any changes to the data file will be described here.<br>

## Preliminaries
Load packages.

```r
library(data.table)
```

Set path.

```r
path <- getwd()
```


## Part 1
**Merge the training and the test sets to create one data set.**<br>

### Read the files
Let's start off by getting the activity data into R by downloading and unzipping the file. A URL for the data is provided on the course homepage.


```r
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("./UCI HAR Dataset.zip")) {
      download.file(fileUrl, destfile = "./UCI HAR Dataset.zip", method = "curl")
      }

if (!file.exists("./UCI HAR Dataset")) unzip("./UCI HAR Dataset.zip", exdir = "./")
```


The archive put the files in a folder named **UCI HAR Dataset**. Let's see what this folder contains. 

```r
pathIn <- file.path(path, "UCI HAR Dataset")
list.files(pathIn, recursive = TRUE)
```

```
##  [1] "activity_labels.txt"                         
##  [2] "features_info.txt"                           
##  [3] "features.txt"                                
##  [4] "README.txt"                                  
##  [5] "test/Inertial Signals/body_acc_x_test.txt"   
##  [6] "test/Inertial Signals/body_acc_y_test.txt"   
##  [7] "test/Inertial Signals/body_acc_z_test.txt"   
##  [8] "test/Inertial Signals/body_gyro_x_test.txt"  
##  [9] "test/Inertial Signals/body_gyro_y_test.txt"  
## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"  
## [12] "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"  
## [14] "test/subject_test.txt"                       
## [15] "test/X_test.txt"                             
## [16] "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt" 
## [18] "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt" 
## [20] "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt"
## [22] "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt"
## [24] "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt"
## [26] "train/subject_train.txt"                     
## [27] "train/X_train.txt"                           
## [28] "train/y_train.txt"
```










In this part of the assignment, we are asked to merge the training and the test sets to create one data set. The relevant factors are:

* X_test/train is the test/training set.
* Y_test/train is the test/training labels.
* subject_test/train is used to identify the subject who performed a given task.
* Features is a list of the measured features.
* Activity links the class labels with their activity name.


Read the subject files.

```r
SubjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt")
SubjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")
```

Read the activity files.

```r
ActivityTest<- read.table("UCI HAR Dataset/test/Y_test.txt")
ActivityTrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
```

Read the data files.

```r
DataTest<- read.table("UCI HAR Dataset/test/X_test.txt")
DataTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
```


### Merging the training and the test sets

```r
## Merging and renaming activity
activity <- rbind(ActivityTest, ActivityTrain)
setnames(activity, "V1", "activityNumber")

## Merging and renaming subject
subject <- rbind(SubjectTest, SubjectTrain)
setnames(subject, "V1", "subject")

## Merging data
data <- rbind(DataTest, DataTrain)
data <- cbind(subject, activity, data)

## Convert the data.frame to a data.table.
setDT(data)
setkey(data, subject, activityNumber)
```

The dimensions of the new data sets are:

```r
dim(data)
```

```
## [1] 10299   563
```

As of now, we see that the data contains 10299 observations on 563 variables. Let's reduce these numbers a little.





## Part 2
**Extract only the measurements on the mean and standard deviation for each measurement.**<br>

To accomplish this, we use the *grep* function to get only the features indeces which contain **mean()** or **std()** in their name. Read the *features.txt* file.


```r
features <- fread(file.path(pathIn, "features.txt"))
setnames(features, names(features), c("featureNumber", "featureName"))
```

Now we subset for only the measurements of mean and std.


```r
features <- features[grepl("mean\\(\\)|std\\(\\)", featureName)]
```

If we take a look at the features, we notice that they are labeled only by featurenumber (integer) whereas the names in data all start with V(integer). Let's match the two files by supplying a featureCode to *features* and view the result.


```r
features$featureCode <- features[, paste0("V", featureNumber)]
head(features)
```

```
##    featureNumber       featureName featureCode
## 1:             1 tBodyAcc-mean()-X          V1
## 2:             2 tBodyAcc-mean()-Y          V2
## 3:             3 tBodyAcc-mean()-Z          V3
## 4:             4  tBodyAcc-std()-X          V4
## 5:             5  tBodyAcc-std()-Y          V5
## 6:             6  tBodyAcc-std()-Z          V6
```

We can now use the list of desired features to subset the data.


```r
selectData <- c(key(data), features$featureCode)
data <- data[, selectData, with = FALSE]
```





## Part 3
**Use descriptive activity names to name the activities in the data set.**

The descriptive activity names can be found in **activity_labels.txt** from the zip file, so lets start by importing those.


```r
activityName <- fread(file.path(pathIn, "activity_labels.txt"))
setnames(activityName, names(activityName), c("activityNumber", "activityName"))
```

The variable now **activity_labels** contains the descriptive names, so let's merge these with the data. We can use the *activityNumber* as a reference between the two.


```r
data <- merge(data, activityName, by = "activityNumber", all.x = TRUE)
setkey(data, subject, activityNumber, activityName)
```





## Part 4
**Appropriately label the data set with descriptive variable names.**

This is all well and good, but the data variable still has 66 variables, and is by no means "tidy" yet. As an example, there are several instances of seperate colums for an X, Y and Z variable. Let's reshape and melt the data to make it tidy. In the previous line of code, we set a key to let R now how we would like to reshape the data.


```r
data <- data.table(melt(data, key(data), variable.name = "featureCode"))
```

Now, include the activity names, using the featureCode as a reference.


```r
data <- merge(data, features[, list(featureNumber, featureCode, featureName)], by = "featureCode", 
    all.x = TRUE)
```

Let's have a look at the data:


```r
head(data)
```

```
##    featureCode subject activityNumber activityName     value featureNumber
## 1:          V1       1              1      WALKING 0.2820216             1
## 2:          V1       1              1      WALKING 0.2558408             1
## 3:          V1       1              1      WALKING 0.2548672             1
## 4:          V1       1              1      WALKING 0.3433705             1
## 5:          V1       1              1      WALKING 0.2762397             1
## 6:          V1       1              1      WALKING 0.2554682             1
##          featureName
## 1: tBodyAcc-mean()-X
## 2: tBodyAcc-mean()-X
## 3: tBodyAcc-mean()-X
## 4: tBodyAcc-mean()-X
## 5: tBodyAcc-mean()-X
## 6: tBodyAcc-mean()-X
```

Excellent. But now we notice that the featureName(s) actually is a cover for several different variables. Not tidy at all. E.g. the first element of *featureName* is "tBodyAcc-mean()-X" which tells us that we are looking at time, acceleration and mean for a measurement on the X axis performed on the body. We would like to split these into seperate variables.<br>

To split the data.table we create two new variables as a factor class. **activity** is equivalent to **activityName** and **feature** is equivalent to **featureName** (but this time as factors).


```r
data$activity <- factor(data$activityName)
data$feature <- factor(data$featureName)
```

From a call to **unique(data[ ,featureName])** we see that the *featureName* covers the variables:

1) **t** or **f** for time or frequency.
2) **Acc** or **Gyro** for accelerometer or gyroscope.
3) **Body** or **Gravity** for measurement on the body or gravity.
4) **mean()** or **std()** for mean or standard deviation. 
5) **Jerk**. Body linear acceleration and angular velocity were derived in time to obtain Jerk signals.
6) **Mag** for magnitude of the three-dimensional signals.
7) **-X**, **-Y**, **-Z** to indicate the axis of measurement. We include the "-" to avoid that random capital X, Y or Z are mistaken for an axis.

To extract all of these properties from the featureName, we  will use a helper function to avoid some excess typing. The helper function seperates features from *data$feature*.


```r
grepFeature <- function(regex) grepl(regex, data$feature)
```

Let's use this function. Notice that the features in the list above can have either one, two or three different outcomes and hence the code to relabel will be a little bit different depending on the number of outcomes. In all instances we create a new variable in the data.table to account for the given variable.<br>

Features with one category:


```r
## Jerk and Magnitude.
data$jerk <- factor(grepFeature("Jerk"), labels = c(NA, "Jerk"))
data$magnitude <- factor(grepFeature("Mag"), labels = c(NA, "Magnitude"))
```

Features with two categories. Create a vector to hold the categories.


```r
n <- 2
numberOfCategories <- matrix(seq(1, n), nrow = n)

## Time or frequency.
categories <- matrix(c(grepFeature("^t"), grepFeature("^f")), ncol = nrow(numberOfCategories))
data$domain <- factor(categories %*% numberOfCategories, labels = c("Time", "Freq"))

## Accelerometer or gyroscope.
categories <- matrix(c(grepFeature("Acc"), grepFeature("Gyro")), ncol = nrow(numberOfCategories))
data$instrument <- factor(categories %*% numberOfCategories, labels = c("Accelerometer", "Gyroscope"))

## Body or gravity.
categories <- matrix(c(grepFeature("BodyAcc"), grepFeature("GravityAcc")), ncol = nrow(numberOfCategories))
data$acceleration <- factor(categories %*% numberOfCategories, labels = c(NA, "Body", "Gravity"))

## Mean or standard deviation.
categories <- matrix(c(grepFeature("mean()"), grepFeature("std()")), ncol = nrow(numberOfCategories))
data$variable <- factor(categories %*% numberOfCategories, labels = c("Mean", "Std"))
```

Features with three categories:


```r
n <- 3
numberOfCategories <- matrix(seq(1, n), nrow = n)

categories <- matrix(c(grepFeature("-X"), grepFeature("-Y"), grepFeature("-Z")), ncol = nrow(numberOfCategories))
data$axis <- factor(categories %*% numberOfCategories, labels = c(NA, "X", "Y", "Z"))
```





## Part 5
**From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.**

Finally we create the tidy data set, with the average of each variable for each activity and each subject.


```r
setkey(data, subject, activity, domain, acceleration, instrument, jerk, magnitude, variable, axis)
tidyData <- data[, list(count = .N, average = mean(value)), by = key(data)]
```

... and just for the fun of it, let's have a look at what we have obtained:


```r
head(tidyData)
```

```
##    subject activity domain acceleration instrument jerk magnitude variable
## 1:       1   LAYING   Time           NA  Gyroscope   NA        NA     Mean
## 2:       1   LAYING   Time           NA  Gyroscope   NA        NA     Mean
## 3:       1   LAYING   Time           NA  Gyroscope   NA        NA     Mean
## 4:       1   LAYING   Time           NA  Gyroscope   NA        NA      Std
## 5:       1   LAYING   Time           NA  Gyroscope   NA        NA      Std
## 6:       1   LAYING   Time           NA  Gyroscope   NA        NA      Std
##    axis count     average
## 1:    X    50 -0.01655309
## 2:    Y    50 -0.06448612
## 3:    Z    50  0.14868944
## 4:    X    50 -0.87354387
## 5:    Y    50 -0.95109044
## 6:    Z    50 -0.90828466
```





The last few lines are just practicallities for creating the CodeBook for this project.

```r
knit("MakeCodeBook.rmd", output = "CodeBook.md")
```

```
## 
## 
## processing file: MakeCodeBook.rmd
```

```
## Error in parse_block(g[-1], g[1], params.src): duplicate label 'setup'
```

```r
markdownToHTML("CodeBook.md", "CodeBook.html")
```

```
## Warning in readLines(con): kan ikke åbne fil 'CodeBook.md': No such file or
## directory
```

```
## Error in readLines(con): kan ikke åbne forbindelsen
```

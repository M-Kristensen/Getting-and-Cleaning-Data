---
title: "MakeCodeBook"
output: html_document
---



## CodeBook

For the peer evaluted assignment of the "Getting and Cleaning Data" (week 4) course on Coursera, we are asked to produce a CodeBook, that "*describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md*".

### Variables (list and description)





| Variable name | Description |
| :--------- | :------------------------------------------------- |
| subject | The ID number for the subject who performed the activity. the range is 1 to 30. |
| activity | Name of the activity |
| domain | The domain can be either time or frequency (Time or Freq) |
| instrument | Measuring instrument (Accelerometer or Gyroscope) |
| acceleration | Acceleration signal (Body or Gravity) |
| variable | Either the mean or the standard deviation (mean or SD) |
| jerk | Jerk signal |
| magnitude | Magnitude of the signals calculated using the Euclidean norm. |
| axis | axial signal in the X, Y and Z directions (X, Y, or Z). |
| count | Count of data points used to compute the average. |
| average | Average of each variable for each activity and each subject. |

### Structure of the data

```r
str(tidyData)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  11 variables:
##  $ subject     : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity    : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ domain      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
##  $ acceleration: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ instrument  : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ jerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
##  $ magnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
##  $ variable    : Factor w/ 2 levels "Mean","Std": 1 1 1 2 2 2 1 2 1 1 ...
##  $ axis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
##  $ count       : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ average     : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
##  - attr(*, "sorted")= chr  "subject" "activity" "domain" "acceleration" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

### List of variables

```r
names(tidyData)
```

```
##  [1] "subject"      "activity"     "domain"       "acceleration"
##  [5] "instrument"   "jerk"         "magnitude"    "variable"    
##  [9] "axis"         "count"        "average"
```

### Show a few rows of the data set

```r
head(tidyData)
```

### Summary of variables

```r
summary(tidyData)
```

```
##     subject                   activity     domain      acceleration 
##  Min.   : 1.0   LAYING            :1980   Time:7200   NA     :4680  
##  1st Qu.: 8.0   SITTING           :1980   Freq:4680   Body   :5760  
##  Median :15.5   STANDING          :1980               Gravity:1440  
##  Mean   :15.5   WALKING           :1980                             
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                             
##  Max.   :30.0   WALKING_UPSTAIRS  :1980                             
##          instrument     jerk          magnitude    variable    axis     
##  Accelerometer:7200   NA  :7200   NA       :8640   Mean:5940   NA:3240  
##  Gyroscope    :4680   Jerk:4680   Magnitude:3240   Std :5940   X :2880  
##                                                                Y :2880  
##                                                                Z :2880  
##                                                                         
##                                                                         
##      count          average        
##  Min.   :36.00   Min.   :-0.99767  
##  1st Qu.:49.00   1st Qu.:-0.96205  
##  Median :54.50   Median :-0.46989  
##  Mean   :57.22   Mean   :-0.48436  
##  3rd Qu.:63.25   3rd Qu.:-0.07836  
##  Max.   :95.00   Max.   : 0.97451
```

### Save to file
Finally we dave the data to a tab-delimetered file, that we shall call HumanActivityRecognitionUsingSmartphonesDataSet.txt.


```r
f <- file.path(path, "HumanActivityRecognitionUsingSmartphonesDataSet.txt")
write.table(tidyData, f, quote = FALSE, sep = "\t", row.names = FALSE)
```

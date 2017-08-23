### About the UCI data

From the UCI README file: The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features\_info.txt' for more details.

### Steps to create the tidy data from the original data set

1.  Load activity labels from `activity_labels.txt`.
2.  Load `features.txt` to a data.frame. We will need this data.frame to get the column names for the data, and to select only the columns we neeed from the data.
3.  `grep` main() and std() functions from the data frame to identify the columns in the data we need. Note that I did not include meanFreq() (as this is a weighted average instead of a mean) or measurements of the angles. I save these indices in the variable `extract_features`.
4.  Replace "()" and "-" with "" and "\_" respectivily to make the names more readable.
5.  Load the subject ID, activity ID and data from the test and the train files.
6.  Bind the test and train data to being simply `data`.
7.  Convert the data to a data.frame before renaming the variables, using the names from `features.txt`.
8.  Use `extract_features` to select the desired columns from the data, using their names.
9.  Bind `activity` labels from the test and train files, and convert to a data.frame.
10. Use `activity_labels` to pair activity\_id to a descriptive activity name. I rename the columns to `activity_id` and `activity`.
11. Bind the list of subjects from the test and train data sets, and convert to a data.frame. I rename the variable to `subject`.
12. Bind the subject, activity and data to the `data` variable.
13. Before I make a tidy data set with the average of each variable for each activity and each subject, I will need to melt the data to a long format.
14. Use `dcast` to cast the data set using subject and activity as id and mean() as the aggregator function. The result of this step is the tidy data set.
15. Write the tidy data set to a file called `DatasetHumanActivityRecognitionUsingSmartphones.txt`. Remember to use `row.name = FALSE`.

### Variables (list and description)

The variables are:

-   `subject`, which is the ID number of the test subject. The range is 1 to 30.
-   `activity`, either WALKING, WALKNING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANING or LAYING.
-   A string indicating what type of measurement was performed. The string consist of the following components:

| Component in string | Description                                                   |
|:--------------------|:--------------------------------------------------------------|
| t or f              | The domain can be either t (time) or f (frequency)            |
| Body or Gravity     | Acceleration signal (Body or Gravity)                         |
| Acc or Gyro         | Measuring instrument (Accelerometer or Gyroscope)             |
| mean or std         | Either the mean (mean) or the standard deviation (std)        |
| jerk                | Jerk signal                                                   |
| Mag                 | Magnitude of the signals calculated using the Euclidean norm. |
| X, Y, Z             | axial signal in the X, Y and Z directions (X, Y, or Z).       |

Note that all the values of the variables, are the calculated means for each subject and each activity.

### Structure of the tidy data set

``` r
## Which seems correct, given that we have 30 subjects and 6 different activities.
dim(tidy_data)
```

    ## [1] 180  68

``` r
str(tidy_data)
```

    ## 'data.frame':    180 obs. of  68 variables:
    ##  $ subject                  : int  1 1 1 1 1 1 2 2 2 2 ...
    ##  $ activity                 : chr  "LAYING" "SITTING" "STANDING" "WALKING" ...
    ##  $ tBodyAcc_mean_X          : num  0.222 0.261 0.279 0.277 0.289 ...
    ##  $ tBodyAcc_mean_Y          : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
    ##  $ tBodyAcc_mean_Z          : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
    ##  $ tBodyAcc_std_X           : num  -0.928 -0.977 -0.996 -0.284 0.03 ...
    ##  $ tBodyAcc_std_Y           : num  -0.8368 -0.9226 -0.9732 0.1145 -0.0319 ...
    ##  $ tBodyAcc_std_Z           : num  -0.826 -0.94 -0.98 -0.26 -0.23 ...
    ##  $ tGravityAcc_mean_X       : num  -0.249 0.832 0.943 0.935 0.932 ...
    ##  $ tGravityAcc_mean_Y       : num  0.706 0.204 -0.273 -0.282 -0.267 ...
    ##  $ tGravityAcc_mean_Z       : num  0.4458 0.332 0.0135 -0.0681 -0.0621 ...
    ##  $ tGravityAcc_std_X        : num  -0.897 -0.968 -0.994 -0.977 -0.951 ...
    ##  $ tGravityAcc_std_Y        : num  -0.908 -0.936 -0.981 -0.971 -0.937 ...
    ##  $ tGravityAcc_std_Z        : num  -0.852 -0.949 -0.976 -0.948 -0.896 ...
    ##  $ tBodyAccJerk_mean_X      : num  0.0811 0.0775 0.0754 0.074 0.0542 ...
    ##  $ tBodyAccJerk_mean_Y      : num  0.003838 -0.000619 0.007976 0.028272 0.02965 ...
    ##  $ tBodyAccJerk_mean_Z      : num  0.01083 -0.00337 -0.00369 -0.00417 -0.01097 ...
    ##  $ tBodyAccJerk_std_X       : num  -0.9585 -0.9864 -0.9946 -0.1136 -0.0123 ...
    ##  $ tBodyAccJerk_std_Y       : num  -0.924 -0.981 -0.986 0.067 -0.102 ...
    ##  $ tBodyAccJerk_std_Z       : num  -0.955 -0.988 -0.992 -0.503 -0.346 ...
    ##  $ tBodyGyro_mean_X         : num  -0.0166 -0.0454 -0.024 -0.0418 -0.0351 ...
    ##  $ tBodyGyro_mean_Y         : num  -0.0645 -0.0919 -0.0594 -0.0695 -0.0909 ...
    ##  $ tBodyGyro_mean_Z         : num  0.1487 0.0629 0.0748 0.0849 0.0901 ...
    ##  $ tBodyGyro_std_X          : num  -0.874 -0.977 -0.987 -0.474 -0.458 ...
    ##  $ tBodyGyro_std_Y          : num  -0.9511 -0.9665 -0.9877 -0.0546 -0.1263 ...
    ##  $ tBodyGyro_std_Z          : num  -0.908 -0.941 -0.981 -0.344 -0.125 ...
    ##  $ tBodyGyroJerk_mean_X     : num  -0.1073 -0.0937 -0.0996 -0.09 -0.074 ...
    ##  $ tBodyGyroJerk_mean_Y     : num  -0.0415 -0.0402 -0.0441 -0.0398 -0.044 ...
    ##  $ tBodyGyroJerk_mean_Z     : num  -0.0741 -0.0467 -0.049 -0.0461 -0.027 ...
    ##  $ tBodyGyroJerk_std_X      : num  -0.919 -0.992 -0.993 -0.207 -0.487 ...
    ##  $ tBodyGyroJerk_std_Y      : num  -0.968 -0.99 -0.995 -0.304 -0.239 ...
    ##  $ tBodyGyroJerk_std_Z      : num  -0.958 -0.988 -0.992 -0.404 -0.269 ...
    ##  $ tBodyAccMag_mean         : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
    ##  $ tBodyAccMag_std          : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
    ##  $ tGravityAccMag_mean      : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
    ##  $ tGravityAccMag_std       : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
    ##  $ tBodyAccJerkMag_mean     : num  -0.9544 -0.9874 -0.9924 -0.1414 -0.0894 ...
    ##  $ tBodyAccJerkMag_std      : num  -0.9282 -0.9841 -0.9931 -0.0745 -0.0258 ...
    ##  $ tBodyGyroMag_mean        : num  -0.8748 -0.9309 -0.9765 -0.161 -0.0757 ...
    ##  $ tBodyGyroMag_std         : num  -0.819 -0.935 -0.979 -0.187 -0.226 ...
    ##  $ tBodyGyroJerkMag_mean    : num  -0.963 -0.992 -0.995 -0.299 -0.295 ...
    ##  $ tBodyGyroJerkMag_std     : num  -0.936 -0.988 -0.995 -0.325 -0.307 ...
    ##  $ fBodyAcc_mean_X          : num  -0.9391 -0.9796 -0.9952 -0.2028 0.0382 ...
    ##  $ fBodyAcc_mean_Y          : num  -0.86707 -0.94408 -0.97707 0.08971 0.00155 ...
    ##  $ fBodyAcc_mean_Z          : num  -0.883 -0.959 -0.985 -0.332 -0.226 ...
    ##  $ fBodyAcc_std_X           : num  -0.9244 -0.9764 -0.996 -0.3191 0.0243 ...
    ##  $ fBodyAcc_std_Y           : num  -0.834 -0.917 -0.972 0.056 -0.113 ...
    ##  $ fBodyAcc_std_Z           : num  -0.813 -0.934 -0.978 -0.28 -0.298 ...
    ##  $ fBodyAccJerk_mean_X      : num  -0.9571 -0.9866 -0.9946 -0.1705 -0.0277 ...
    ##  $ fBodyAccJerk_mean_Y      : num  -0.9225 -0.9816 -0.9854 -0.0352 -0.1287 ...
    ##  $ fBodyAccJerk_mean_Z      : num  -0.948 -0.986 -0.991 -0.469 -0.288 ...
    ##  $ fBodyAccJerk_std_X       : num  -0.9642 -0.9875 -0.9951 -0.1336 -0.0863 ...
    ##  $ fBodyAccJerk_std_Y       : num  -0.932 -0.983 -0.987 0.107 -0.135 ...
    ##  $ fBodyAccJerk_std_Z       : num  -0.961 -0.988 -0.992 -0.535 -0.402 ...
    ##  $ fBodyGyro_mean_X         : num  -0.85 -0.976 -0.986 -0.339 -0.352 ...
    ##  $ fBodyGyro_mean_Y         : num  -0.9522 -0.9758 -0.989 -0.1031 -0.0557 ...
    ##  $ fBodyGyro_mean_Z         : num  -0.9093 -0.9513 -0.9808 -0.2559 -0.0319 ...
    ##  $ fBodyGyro_std_X          : num  -0.882 -0.978 -0.987 -0.517 -0.495 ...
    ##  $ fBodyGyro_std_Y          : num  -0.9512 -0.9623 -0.9871 -0.0335 -0.1814 ...
    ##  $ fBodyGyro_std_Z          : num  -0.917 -0.944 -0.982 -0.437 -0.238 ...
    ##  $ fBodyAccMag_mean         : num  -0.8618 -0.9478 -0.9854 -0.1286 0.0966 ...
    ##  $ fBodyAccMag_std          : num  -0.798 -0.928 -0.982 -0.398 -0.187 ...
    ##  $ fBodyBodyAccJerkMag_mean : num  -0.9333 -0.9853 -0.9925 -0.0571 0.0262 ...
    ##  $ fBodyBodyAccJerkMag_std  : num  -0.922 -0.982 -0.993 -0.103 -0.104 ...
    ##  $ fBodyBodyGyroMag_mean    : num  -0.862 -0.958 -0.985 -0.199 -0.186 ...
    ##  $ fBodyBodyGyroMag_std     : num  -0.824 -0.932 -0.978 -0.321 -0.398 ...
    ##  $ fBodyBodyGyroJerkMag_mean: num  -0.942 -0.99 -0.995 -0.319 -0.282 ...
    ##  $ fBodyBodyGyroJerkMag_std : num  -0.933 -0.987 -0.995 -0.382 -0.392 ...

### Summary of variables

``` r
summary(tidy_data)
```

    ##     subject       activity         tBodyAcc_mean_X  tBodyAcc_mean_Y    
    ##  Min.   : 1.0   Length:180         Min.   :0.2216   Min.   :-0.040514  
    ##  1st Qu.: 8.0   Class :character   1st Qu.:0.2712   1st Qu.:-0.020022  
    ##  Median :15.5   Mode  :character   Median :0.2770   Median :-0.017262  
    ##  Mean   :15.5                      Mean   :0.2743   Mean   :-0.017876  
    ##  3rd Qu.:23.0                      3rd Qu.:0.2800   3rd Qu.:-0.014936  
    ##  Max.   :30.0                      Max.   :0.3015   Max.   :-0.001308  
    ##  tBodyAcc_mean_Z    tBodyAcc_std_X    tBodyAcc_std_Y     tBodyAcc_std_Z   
    ##  Min.   :-0.15251   Min.   :-0.9961   Min.   :-0.99024   Min.   :-0.9877  
    ##  1st Qu.:-0.11207   1st Qu.:-0.9799   1st Qu.:-0.94205   1st Qu.:-0.9498  
    ##  Median :-0.10819   Median :-0.7526   Median :-0.50897   Median :-0.6518  
    ##  Mean   :-0.10916   Mean   :-0.5577   Mean   :-0.46046   Mean   :-0.5756  
    ##  3rd Qu.:-0.10443   3rd Qu.:-0.1984   3rd Qu.:-0.03077   3rd Qu.:-0.2306  
    ##  Max.   :-0.07538   Max.   : 0.6269   Max.   : 0.61694   Max.   : 0.6090  
    ##  tGravityAcc_mean_X tGravityAcc_mean_Y tGravityAcc_mean_Z
    ##  Min.   :-0.6800    Min.   :-0.47989   Min.   :-0.49509  
    ##  1st Qu.: 0.8376    1st Qu.:-0.23319   1st Qu.:-0.11726  
    ##  Median : 0.9208    Median :-0.12782   Median : 0.02384  
    ##  Mean   : 0.6975    Mean   :-0.01621   Mean   : 0.07413  
    ##  3rd Qu.: 0.9425    3rd Qu.: 0.08773   3rd Qu.: 0.14946  
    ##  Max.   : 0.9745    Max.   : 0.95659   Max.   : 0.95787  
    ##  tGravityAcc_std_X tGravityAcc_std_Y tGravityAcc_std_Z tBodyAccJerk_mean_X
    ##  Min.   :-0.9968   Min.   :-0.9942   Min.   :-0.9910   Min.   :0.04269    
    ##  1st Qu.:-0.9825   1st Qu.:-0.9711   1st Qu.:-0.9605   1st Qu.:0.07396    
    ##  Median :-0.9695   Median :-0.9590   Median :-0.9450   Median :0.07640    
    ##  Mean   :-0.9638   Mean   :-0.9524   Mean   :-0.9364   Mean   :0.07947    
    ##  3rd Qu.:-0.9509   3rd Qu.:-0.9370   3rd Qu.:-0.9180   3rd Qu.:0.08330    
    ##  Max.   :-0.8296   Max.   :-0.6436   Max.   :-0.6102   Max.   :0.13019    
    ##  tBodyAccJerk_mean_Y  tBodyAccJerk_mean_Z tBodyAccJerk_std_X
    ##  Min.   :-0.0386872   Min.   :-0.067458   Min.   :-0.9946   
    ##  1st Qu.: 0.0004664   1st Qu.:-0.010601   1st Qu.:-0.9832   
    ##  Median : 0.0094698   Median :-0.003861   Median :-0.8104   
    ##  Mean   : 0.0075652   Mean   :-0.004953   Mean   :-0.5949   
    ##  3rd Qu.: 0.0134008   3rd Qu.: 0.001958   3rd Qu.:-0.2233   
    ##  Max.   : 0.0568186   Max.   : 0.038053   Max.   : 0.5443   
    ##  tBodyAccJerk_std_Y tBodyAccJerk_std_Z tBodyGyro_mean_X  
    ##  Min.   :-0.9895    Min.   :-0.99329   Min.   :-0.20578  
    ##  1st Qu.:-0.9724    1st Qu.:-0.98266   1st Qu.:-0.04712  
    ##  Median :-0.7756    Median :-0.88366   Median :-0.02871  
    ##  Mean   :-0.5654    Mean   :-0.73596   Mean   :-0.03244  
    ##  3rd Qu.:-0.1483    3rd Qu.:-0.51212   3rd Qu.:-0.01676  
    ##  Max.   : 0.3553    Max.   : 0.03102   Max.   : 0.19270  
    ##  tBodyGyro_mean_Y   tBodyGyro_mean_Z   tBodyGyro_std_X   tBodyGyro_std_Y  
    ##  Min.   :-0.20421   Min.   :-0.07245   Min.   :-0.9943   Min.   :-0.9942  
    ##  1st Qu.:-0.08955   1st Qu.: 0.07475   1st Qu.:-0.9735   1st Qu.:-0.9629  
    ##  Median :-0.07318   Median : 0.08512   Median :-0.7890   Median :-0.8017  
    ##  Mean   :-0.07426   Mean   : 0.08744   Mean   :-0.6916   Mean   :-0.6533  
    ##  3rd Qu.:-0.06113   3rd Qu.: 0.10177   3rd Qu.:-0.4414   3rd Qu.:-0.4196  
    ##  Max.   : 0.02747   Max.   : 0.17910   Max.   : 0.2677   Max.   : 0.4765  
    ##  tBodyGyro_std_Z   tBodyGyroJerk_mean_X tBodyGyroJerk_mean_Y
    ##  Min.   :-0.9855   Min.   :-0.15721     Min.   :-0.07681    
    ##  1st Qu.:-0.9609   1st Qu.:-0.10322     1st Qu.:-0.04552    
    ##  Median :-0.8010   Median :-0.09868     Median :-0.04112    
    ##  Mean   :-0.6164   Mean   :-0.09606     Mean   :-0.04269    
    ##  3rd Qu.:-0.3106   3rd Qu.:-0.09110     3rd Qu.:-0.03842    
    ##  Max.   : 0.5649   Max.   :-0.02209     Max.   :-0.01320    
    ##  tBodyGyroJerk_mean_Z tBodyGyroJerk_std_X tBodyGyroJerk_std_Y
    ##  Min.   :-0.092500    Min.   :-0.9965     Min.   :-0.9971    
    ##  1st Qu.:-0.061725    1st Qu.:-0.9800     1st Qu.:-0.9832    
    ##  Median :-0.053430    Median :-0.8396     Median :-0.8942    
    ##  Mean   :-0.054802    Mean   :-0.7036     Mean   :-0.7636    
    ##  3rd Qu.:-0.048985    3rd Qu.:-0.4629     3rd Qu.:-0.5861    
    ##  Max.   :-0.006941    Max.   : 0.1791     Max.   : 0.2959    
    ##  tBodyGyroJerk_std_Z tBodyAccMag_mean  tBodyAccMag_std  
    ##  Min.   :-0.9954     Min.   :-0.9865   Min.   :-0.9865  
    ##  1st Qu.:-0.9848     1st Qu.:-0.9573   1st Qu.:-0.9430  
    ##  Median :-0.8610     Median :-0.4829   Median :-0.6074  
    ##  Mean   :-0.7096     Mean   :-0.4973   Mean   :-0.5439  
    ##  3rd Qu.:-0.4741     3rd Qu.:-0.0919   3rd Qu.:-0.2090  
    ##  Max.   : 0.1932     Max.   : 0.6446   Max.   : 0.4284  
    ##  tGravityAccMag_mean tGravityAccMag_std tBodyAccJerkMag_mean
    ##  Min.   :-0.9865     Min.   :-0.9865    Min.   :-0.9928     
    ##  1st Qu.:-0.9573     1st Qu.:-0.9430    1st Qu.:-0.9807     
    ##  Median :-0.4829     Median :-0.6074    Median :-0.8168     
    ##  Mean   :-0.4973     Mean   :-0.5439    Mean   :-0.6079     
    ##  3rd Qu.:-0.0919     3rd Qu.:-0.2090    3rd Qu.:-0.2456     
    ##  Max.   : 0.6446     Max.   : 0.4284    Max.   : 0.4345     
    ##  tBodyAccJerkMag_std tBodyGyroMag_mean tBodyGyroMag_std 
    ##  Min.   :-0.9946     Min.   :-0.9807   Min.   :-0.9814  
    ##  1st Qu.:-0.9765     1st Qu.:-0.9461   1st Qu.:-0.9476  
    ##  Median :-0.8014     Median :-0.6551   Median :-0.7420  
    ##  Mean   :-0.5842     Mean   :-0.5652   Mean   :-0.6304  
    ##  3rd Qu.:-0.2173     3rd Qu.:-0.2159   3rd Qu.:-0.3602  
    ##  Max.   : 0.4506     Max.   : 0.4180   Max.   : 0.3000  
    ##  tBodyGyroJerkMag_mean tBodyGyroJerkMag_std fBodyAcc_mean_X  
    ##  Min.   :-0.99732      Min.   :-0.9977      Min.   :-0.9952  
    ##  1st Qu.:-0.98515      1st Qu.:-0.9805      1st Qu.:-0.9787  
    ##  Median :-0.86479      Median :-0.8809      Median :-0.7691  
    ##  Mean   :-0.73637      Mean   :-0.7550      Mean   :-0.5758  
    ##  3rd Qu.:-0.51186      3rd Qu.:-0.5767      3rd Qu.:-0.2174  
    ##  Max.   : 0.08758      Max.   : 0.2502      Max.   : 0.5370  
    ##  fBodyAcc_mean_Y    fBodyAcc_mean_Z   fBodyAcc_std_X    fBodyAcc_std_Y    
    ##  Min.   :-0.98903   Min.   :-0.9895   Min.   :-0.9966   Min.   :-0.99068  
    ##  1st Qu.:-0.95361   1st Qu.:-0.9619   1st Qu.:-0.9820   1st Qu.:-0.94042  
    ##  Median :-0.59498   Median :-0.7236   Median :-0.7470   Median :-0.51338  
    ##  Mean   :-0.48873   Mean   :-0.6297   Mean   :-0.5522   Mean   :-0.48148  
    ##  3rd Qu.:-0.06341   3rd Qu.:-0.3183   3rd Qu.:-0.1966   3rd Qu.:-0.07913  
    ##  Max.   : 0.52419   Max.   : 0.2807   Max.   : 0.6585   Max.   : 0.56019  
    ##  fBodyAcc_std_Z    fBodyAccJerk_mean_X fBodyAccJerk_mean_Y
    ##  Min.   :-0.9872   Min.   :-0.9946     Min.   :-0.9894    
    ##  1st Qu.:-0.9459   1st Qu.:-0.9828     1st Qu.:-0.9725    
    ##  Median :-0.6441   Median :-0.8126     Median :-0.7817    
    ##  Mean   :-0.5824   Mean   :-0.6139     Mean   :-0.5882    
    ##  3rd Qu.:-0.2655   3rd Qu.:-0.2820     3rd Qu.:-0.1963    
    ##  Max.   : 0.6871   Max.   : 0.4743     Max.   : 0.2767    
    ##  fBodyAccJerk_mean_Z fBodyAccJerk_std_X fBodyAccJerk_std_Y
    ##  Min.   :-0.9920     Min.   :-0.9951    Min.   :-0.9905   
    ##  1st Qu.:-0.9796     1st Qu.:-0.9847    1st Qu.:-0.9737   
    ##  Median :-0.8707     Median :-0.8254    Median :-0.7852   
    ##  Mean   :-0.7144     Mean   :-0.6121    Mean   :-0.5707   
    ##  3rd Qu.:-0.4697     3rd Qu.:-0.2475    3rd Qu.:-0.1685   
    ##  Max.   : 0.1578     Max.   : 0.4768    Max.   : 0.3498   
    ##  fBodyAccJerk_std_Z  fBodyGyro_mean_X  fBodyGyro_mean_Y  fBodyGyro_mean_Z 
    ##  Min.   :-0.993108   Min.   :-0.9931   Min.   :-0.9940   Min.   :-0.9860  
    ##  1st Qu.:-0.983747   1st Qu.:-0.9697   1st Qu.:-0.9700   1st Qu.:-0.9624  
    ##  Median :-0.895121   Median :-0.7300   Median :-0.8141   Median :-0.7909  
    ##  Mean   :-0.756489   Mean   :-0.6367   Mean   :-0.6767   Mean   :-0.6044  
    ##  3rd Qu.:-0.543787   3rd Qu.:-0.3387   3rd Qu.:-0.4458   3rd Qu.:-0.2635  
    ##  Max.   :-0.006236   Max.   : 0.4750   Max.   : 0.3288   Max.   : 0.4924  
    ##  fBodyGyro_std_X   fBodyGyro_std_Y   fBodyGyro_std_Z   fBodyAccMag_mean 
    ##  Min.   :-0.9947   Min.   :-0.9944   Min.   :-0.9867   Min.   :-0.9868  
    ##  1st Qu.:-0.9750   1st Qu.:-0.9602   1st Qu.:-0.9643   1st Qu.:-0.9560  
    ##  Median :-0.8086   Median :-0.7964   Median :-0.8224   Median :-0.6703  
    ##  Mean   :-0.7110   Mean   :-0.6454   Mean   :-0.6577   Mean   :-0.5365  
    ##  3rd Qu.:-0.4813   3rd Qu.:-0.4154   3rd Qu.:-0.3916   3rd Qu.:-0.1622  
    ##  Max.   : 0.1966   Max.   : 0.6462   Max.   : 0.5225   Max.   : 0.5866  
    ##  fBodyAccMag_std   fBodyBodyAccJerkMag_mean fBodyBodyAccJerkMag_std
    ##  Min.   :-0.9876   Min.   :-0.9940          Min.   :-0.9944        
    ##  1st Qu.:-0.9452   1st Qu.:-0.9770          1st Qu.:-0.9752        
    ##  Median :-0.6513   Median :-0.7940          Median :-0.8126        
    ##  Mean   :-0.6210   Mean   :-0.5756          Mean   :-0.5992        
    ##  3rd Qu.:-0.3654   3rd Qu.:-0.1872          3rd Qu.:-0.2668        
    ##  Max.   : 0.1787   Max.   : 0.5384          Max.   : 0.3163        
    ##  fBodyBodyGyroMag_mean fBodyBodyGyroMag_std fBodyBodyGyroJerkMag_mean
    ##  Min.   :-0.9865       Min.   :-0.9815      Min.   :-0.9976          
    ##  1st Qu.:-0.9616       1st Qu.:-0.9488      1st Qu.:-0.9813          
    ##  Median :-0.7657       Median :-0.7727      Median :-0.8779          
    ##  Mean   :-0.6671       Mean   :-0.6723      Mean   :-0.7564          
    ##  3rd Qu.:-0.4087       3rd Qu.:-0.4277      3rd Qu.:-0.5831          
    ##  Max.   : 0.2040       Max.   : 0.2367      Max.   : 0.1466          
    ##  fBodyBodyGyroJerkMag_std
    ##  Min.   :-0.9976         
    ##  1st Qu.:-0.9802         
    ##  Median :-0.8941         
    ##  Mean   :-0.7715         
    ##  3rd Qu.:-0.6081         
    ##  Max.   : 0.2878

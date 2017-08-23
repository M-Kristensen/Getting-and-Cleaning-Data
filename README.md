## Getting and Cleaning Data - Graded Assignment
The purpose of this project is to create tidy data from the data provided by the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

### Files in the Repository
1) `README.md`: this file.
2) `run_analysis.R`: the R script containing the functions that will create the tidy data.
3) `CodeBook.md`: contains a description of the resulting data set, and the transformations executed on the original data set.



### To Use the Scripts
1) Download and source in the `run_analysis.R` file.

Note: When you run (or source) `run_analysis.R` the script will automatically download and unzip the UCI data file to your current working directory, as well as perform the desired transformations of the data set.

If necessary, the script also install the R packages `data.table`, `dplyr`, and `reshape2` before requiring them.



### Outputs Produced
The tidy data set is stored in the object tidyData, and written to a file called `DatasetHumanActivityRecognitionUsingSmartphones.txt`.
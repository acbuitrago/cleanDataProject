# Getting and Cleaning Data - Course Project

## Prerequisites
To run the script "run_analysis.R" you need to install the following packages in R:
-plyr
-dplyr

Also, the script assumes it's executed in an environment where exists a folder named "UCI HAR Dataset", which contains the next files and folders:

-train/X_train.txt
-train/y_train.txt
-train/subject_train.txt
-test/X_test.txt
-test/y_test.txt
-test/subject_test.txt
-features.txt
-activity_labels.txt

Meaning, you only have to unzip the dataset file in the same folder where "run_analysis.R" is and the script will work.

## Description of the script

To obtain a tidy dataset, I didn’t follow the steps in the proposed order. Instead I followed this order:
2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
1.	Merges the training and the test sets to create one data set.
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names. 
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Also I did many things before getting to the first step. 
The main reason why I didn’t followed the order was because I think that merging the training and tests sets before extracting the measures we are interested in, is a highly inefficient since there are many rows and columns in both data frames. 
Now I will explain each the specific steps I followed in the script. Hopefully this will explain all my work.
1.	Read the X files of both training and testing.
However, since the files sometimes have uneven separators between variables (sometimes " " and sometimes "  "),  I first had to change a double space ("  ") for a single space (" ") in each line, and then I read the file.
Also, with the previous change, always the first column of the data frame would be NA, because the first double space in each line of the file is transformed to a single space and R reads it as a missing variable. So, I had to remove the first column of the dataframe.
2.	Read the y files of both training and testing.
3.	Read the subject files of both training and testing.
4.	Bind the subject and y data frames of training and testing to the respective x data frames.
In this way, now I have a data frame for all the information of training and another with all the information of testing. The only thing I don’t have is the name of each column in both data frames.
5.	Read the features file.
In this file there are two columns, but I’m only interested in the labels of each feature, so I only keep this column (the second). In addition, I add two more labels: “Activity” and “Subject”.
This list gives the names of each column in the training and testing data frames.
6.	Set the names of the testing and training data frames to features.
7.	Remove duplicate columns of the training and testing data frames.
This step is important, since I can’t use the function “select” if there are columns with the same name. Also, I want to use “select” to keep only the measures related to mean and standard deviation. 
8.	Select the columns I’m interested in, which are the ones which have in their labels the words “mean” or “std”.
In order to do this step I used the option “matches” in the function “select” and applied this regular expression: ".*(mean|std).*". However, this regular expression keeps the features that are related with angles between two vectors, like this one: angle(gravityMean, tBodyAccMean). So, I had to remove all the columns whose label started with “angle(”.
In this point, I have two data frames, one for training and one for testing, and each of them contains the columns which are measures related to mean and standard deviation.
9.	Merge the training and test data frames.
This step is performed using the “merge” function.
10.	Load Activity Labels file.
This file tells which activity number is related with which label.
11.	Name the activities in the dataset with descriptive labels.
The labels are the ones in the activity_labeles.txt file.
This step is performed using the “mutate” function and the “mapvalues” function (plyr package).
12.	Change the names of the activities.
These names are explained in the Code Book.
13.	Create a data frame grouped by subject and activity.
14.	Using the data frame created in the previous step and the function “summarize”  , create another data set with the average of each variable for each activity and each subject.

Thank you.  (:


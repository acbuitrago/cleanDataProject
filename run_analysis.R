#Load libraries
library(plyr); library(dplyr)

#R ead the X files of both training and testing. 
# However, since the files sometimes have uneven separators between variables (sometimes " " and sometimes "  "), 
# first change a double space ("  ") for a single space (" ") in each line, then read the line.
fileXtrain<-"UCI HAR Dataset/train/X_train.txt"
fileXtest<-"UCI HAR Dataset/test/X_test.txt"

dataXTrain<-read.table(textConnection(gsub("  ", " ", readLines(fileXtrain))), sep=" ")
dataXTest<-read.table(textConnection(gsub("  ", " ", readLines(fileXtest))), sep=" ")

#The first column of the dataframe is always NA because the first double space in each line of
# the file is transformed to a single space and R reads it as a missing variable.

dataXTrain<-dataXTrain[,2:562] #Must remove the first column, because is empty. 
dataXTest<-dataXTest[,2:562]

# Read the y files
fileYtrain<-"UCI HAR Dataset/train/y_train.txt"
fileYtest<-"UCI HAR Dataset/test/y_test.txt"

dataYTrain<-read.table(fileYtrain)
dataYTest<-read.table(fileYtest)

#Read Subject files
fileSubjectTrain<-"UCI HAR Dataset/train/subject_train.txt"
fileSubjectTest<-"UCI HAR Dataset/test/subject_test.txt"

dataSubjectTrain<-read.table(fileSubjectTrain)
dataSubjectTest<-read.table(fileSubjectTest)

#Bind the xfiles and y files (activites) of training and testing
dataXTrain<-cbind(dataXTrain, dataYTrain)
dataXTest<-cbind(dataXTest, dataYTest)

#Bind the files and subjects of training and testing
dataXTrain<-cbind(dataXTrain, dataSubjectTrain)
dataXTest<-cbind(dataXTest, dataSubjectTest)

#Read features file
fileFeatures<-"UCI HAR Dataset/features.txt"
features<-read.table(fileFeatures, stringsAsFactors = FALSE)
features<-rbind(features,c(562,"Activity")) ##Add activity since that's the name of the last feature after binding x and y files
features<-rbind(features,c(563,"Subject")) # Add subject

features<-features[,2] # keep only the names of the features

names(dataXTrain)<-features # Set the names of dataframes to features
names(dataXTest)<-features

#xTrain <- tbl_df(dataXTrain) #Load the data into a data frame tbl
#Remove duplicate columns, they are not needed anyway
xTrain <- dataXTrain[ , !duplicated(colnames(dataXTrain))]
xTest <- dataXTest[ , !duplicated(colnames(dataXTest))]

#Select columns which give information of mean, std also, and keep Activity and Subject
xTrain<-select(xTrain, matches(".*(mean|std).*",  ignore.case=TRUE), Activity, Subject)
xTest<-select(xTest, matches(".*(mean|std).*",  ignore.case=TRUE), Activity, Subject)

#Merge training and test
XData<-merge(xTrain,xTest, all=TRUE)

#Load Activity Labels file
fileActLabels<-"UCI HAR Dataset/activity_labels.txt"
actLabels<-read.table(fileActLabels, stringsAsFactors=FALSE)
#Divide in numbers and labels
activityNumbers<-actLabels[,1]
activityLabels<-actLabels[,2]

#Set names of activities.
XData<-mutate(XData, Activity=plyr::mapvalues(Activity,activityNumbers, activityLabels))
XData<-select(XData, -contains("angle(")) #Remove data which has "angle("
names(XData)<-c("BodyAccTime_Mean_X","BodyAccTime_Mean_Y","BodyAccTime_Mean_Z",
                "BodyAccTime_Std_X","BodyAccTime_Std_Y","BodyAccTime_Std_Z",
                "GravityAccTime_Mean_X","GravityAccTime_Mean_Y","GravityAccTime_Mean_Z",
                "GravityAccTime_Std_X","GravityAccTime_Std_Y","GravityAccTime_Std_Z",
                "BodyJerkAccTime_Mean_X","BodyJerkAccTime_Mean_Y","BodyJerkAccTime_Mean_Z",
                "BodyJerkAccTime_Std_X","BodyJerkAccTime_Std_Y","BodyJerkAccTime_Std_Z",
                "BodyGyroTime_Mean_X","BodyGyroTime_Mean_Y","BodyGyroTime_Mean_Z",
                "BodyGyroTime_Std_X","BodyGyroTime_Std_Y","BodyGyroTime_Std_Z",
                "BodyGyroJerkTime_Mean_X","BodyGyroJerkTime_Mean_Y","BodyGyroJerkTime_Mean_Z",
                "BodyGyroJerkTime_Std_X","BodyGyroJerkTime_Std_Y","BodyGyroJerkTime_Std_Z",
                "BodyAccTimeMagnitude_Mean","BodyAccTimeMagnitude_Std",
                "GravityAccTimeMagnitude_Mean","GravityAccTimeMagnitude_Std",
                "BodyAccJerkTimeMagnitude_Mean","BodyAccJerkTimeMagnitude_Std",
                "BodyGyroTimeMagnitude_Mean","BodyGyroTimeMagnitude_Std",
                "BodyGyroJerkTimeMagnitude_Mean","BodyGyroJerkTimeMagnitude_Std",
                "BodyAccFrec_Mean_X","BodyAccFrec_Mean_Y","BodyAccFrec_Mean_Z",
                "BodyAccFrec_Std_X","BodyAccFrec_Std_Y","BodyAccFrec_Std_Z",
                "BodyAccFrec_MeanFrec_X","BodyAccFrec_MeanFrec_Y","BodyAccFrec_MeanFrec_Z",
                "BodyJerkAccFrec_Mean_X","BodyJerkAccFrec_Mean_Y","BodyJerkAccFrec_Mean_Z",
                "BodyJerkAccFrec_Std_X","BodyJerkAccFrec_Std_Y","BodyJerkAccFrec_Std_Z",
                "BodyJerkAccFrec_MeanFrec_X","BodyJerkAccFrec_MeanFrec_Y","BodyJerkAccFrec_MeanFrec_Z",
                "BodyGyroFrec_Mean_X","BodyGyroFrec_Mean_Y","BodyGyroFrec_Mean_Z",
                "BodyGyroFrec_Std_X","BodyGyroFrec_Std_Y","BodyGyroFrec_Std_Z",
                "BodyGyroFrec_MeanFrec_X","BodyGyroFrec_MeanFrec_Y","BodyGyroFrec_MeanFrec_Z",
                "BodyAccFrecMagnitude_Mean","BodyAccFrecMagnitude_Std","BodyAccFrecMagnitude_MeanFreq",
                "BodyAccJerkFrecMagnitude_Mean","BodyAccJerkFrecMagnitude_Std","BodyAccJerkFrecMagnitude_MeanFrec",
                "BodyGyroFrecMagnitude_Mean","BodyGyroFrecMagnitude_Std","BodyGyroFrecMagnitude_MeanFrec",
                "BodyGyroJerkFrecMagnitude_Mean","BodyGyroJerkFrecMagnitude_Std","BodyGyroJerkFrecMagnitude_MeanFrec",
                "Activity", "Subject")

#Create a dataframed grouped by subject and activity
by_Subject_Activity<-group_by(XData, Subject, Activity)

#Create a tidy dataset.
tidyData<-summarize(by_Subject_Activity, 
                    avg_BodyAccTime_Mean_X= mean(BodyAccTime_Mean_X),avg_BodyAccTime_Mean_Y= mean(BodyAccTime_Mean_Y),avg_BodyAccTime_Mean_Z= mean(BodyAccTime_Mean_Z),
                    avg_BodyAccTime_Std_X= mean(BodyAccTime_Std_X),avg_BodyAccTime_Std_Y= mean(BodyAccTime_Std_Y),avg_BodyAccTime_Std_Z= mean(BodyAccTime_Std_Z),
                    avg_GravityAccTime_Mean_X= mean(GravityAccTime_Mean_X),avg_GravityAccTime_Mean_Y= mean(GravityAccTime_Mean_Y),avg_GravityAccTime_Mean_Z= mean(GravityAccTime_Mean_Z),
                    avg_GravityAccTime_Std_X= mean(GravityAccTime_Std_X),avg_GravityAccTime_Std_Y= mean(GravityAccTime_Std_Y),avg_GravityAccTime_Std_Z= mean(GravityAccTime_Std_Z),
                    avg_BodyJerkAccTime_Mean_X= mean(BodyJerkAccTime_Mean_X),avg_BodyJerkAccTime_Mean_Y= mean(BodyJerkAccTime_Mean_Y),avg_BodyJerkAccTime_Mean_Z= mean(BodyJerkAccTime_Mean_Z),
                    avg_BodyJerkAccTime_Std_X= mean(BodyJerkAccTime_Std_X),avg_BodyJerkAccTime_Std_Y= mean(BodyJerkAccTime_Std_Y),avg_BodyJerkAccTime_Std_Z= mean(BodyJerkAccTime_Std_Z),
                    avg_BodyGyroTime_Mean_X= mean(BodyGyroTime_Mean_X),avg_BodyGyroTime_Mean_Y= mean(BodyGyroTime_Mean_Y),avg_BodyGyroTime_Mean_Z= mean(BodyGyroTime_Mean_Z),
                    avg_BodyGyroTime_Std_X= mean(BodyGyroTime_Std_X),avg_BodyGyroTime_Std_Y= mean(BodyGyroTime_Std_Y),avg_BodyGyroTime_Std_Z= mean(BodyGyroTime_Std_Z),
                    avg_BodyGyroJerkTime_Mean_X= mean(BodyGyroJerkTime_Mean_X),avg_BodyGyroJerkTime_Mean_Y= mean(BodyGyroJerkTime_Mean_Y),avg_BodyGyroJerkTime_Mean_Z= mean(BodyGyroJerkTime_Mean_Z),
                    avg_BodyGyroJerkTime_Std_X= mean(BodyGyroJerkTime_Std_X),avg_BodyGyroJerkTime_Std_Y= mean(BodyGyroJerkTime_Std_Y),avg_BodyGyroJerkTime_Std_Z= mean(BodyGyroJerkTime_Std_Z),
                    avg_BodyAccTimeMagnitude_Mean= mean(BodyAccTimeMagnitude_Mean),avg_BodyAccTimeMagnitude_Std= mean(BodyAccTimeMagnitude_Std),
                    avg_GravityAccTimeMagnitude_Mean= mean(GravityAccTimeMagnitude_Mean),avg_GravityAccTimeMagnitude_Std= mean(GravityAccTimeMagnitude_Std),
                    avg_BodyAccJerkTimeMagnitude_Mean= mean(BodyAccJerkTimeMagnitude_Mean),avg_BodyAccJerkTimeMagnitude_Std= mean(BodyAccJerkTimeMagnitude_Std),
                    avg_BodyGyroTimeMagnitude_Mean= mean(BodyGyroTimeMagnitude_Mean),avg_BodyGyroTimeMagnitude_Std= mean(BodyGyroTimeMagnitude_Std),
                    avg_BodyGyroJerkTimeMagnitude_Mean= mean(BodyGyroJerkTimeMagnitude_Mean),avg_BodyGyroJerkTimeMagnitude_Std= mean(BodyGyroJerkTimeMagnitude_Std),
                    avg_BodyAccFrec_Mean_X= mean(BodyAccFrec_Mean_X),avg_BodyAccFrec_Mean_Y= mean(BodyAccFrec_Mean_Y),avg_BodyAccFrec_Mean_Z= mean(BodyAccFrec_Mean_Z),
                    avg_BodyAccFrec_Std_X= mean(BodyAccFrec_Std_X),avg_BodyAccFrec_Std_Y= mean(BodyAccFrec_Std_Y),avg_BodyAccFrec_Std_Z= mean(BodyAccFrec_Std_Z),
                    avg_BodyAccFrec_MeanFrec_X= mean(BodyAccFrec_MeanFrec_X),avg_BodyAccFrec_MeanFrec_Y= mean(BodyAccFrec_MeanFrec_Y),avg_BodyAccFrec_MeanFrec_Z= mean(BodyAccFrec_MeanFrec_Z),
                    avg_BodyJerkAccFrec_Mean_X= mean(BodyJerkAccFrec_Mean_X),avg_BodyJerkAccFrec_Mean_Y= mean(BodyJerkAccFrec_Mean_Y),avg_BodyJerkAccFrec_Mean_Z= mean(BodyJerkAccFrec_Mean_Z),
                    avg_BodyJerkAccFrec_Std_X= mean(BodyJerkAccFrec_Std_X),avg_BodyJerkAccFrec_Std_Y= mean(BodyJerkAccFrec_Std_Y),avg_BodyJerkAccFrec_Std_Z= mean(BodyJerkAccFrec_Std_Z),
                    avg_BodyJerkAccFrec_MeanFrec_X= mean(BodyJerkAccFrec_MeanFrec_X),avg_BodyJerkAccFrec_MeanFrec_Y= mean(BodyJerkAccFrec_MeanFrec_Y),avg_BodyJerkAccFrec_MeanFrec_Z= mean(BodyJerkAccFrec_MeanFrec_Z),
                    avg_BodyGyroFrec_Mean_X= mean(BodyGyroFrec_Mean_X),avg_BodyGyroFrec_Mean_Y= mean(BodyGyroFrec_Mean_Y),avg_BodyGyroFrec_Mean_Z= mean(BodyGyroFrec_Mean_Z),
                    avg_BodyGyroFrec_Std_X= mean(BodyGyroFrec_Std_X),avg_BodyGyroFrec_Std_Y= mean(BodyGyroFrec_Std_Y),avg_BodyGyroFrec_Std_Z= mean(BodyGyroFrec_Std_Z),
                    avg_BodyGyroFrec_MeanFrec_X= mean(BodyGyroFrec_MeanFrec_X),avg_BodyGyroFrec_MeanFrec_Y= mean(BodyGyroFrec_MeanFrec_Y),avg_BodyGyroFrec_MeanFrec_Z= mean(BodyGyroFrec_MeanFrec_Z),
                    avg_BodyAccFrecMagnitude_Mean= mean(BodyAccFrecMagnitude_Mean),avg_BodyAccFrecMagnitude_Std= mean(BodyAccFrecMagnitude_Std),avg_BodyAccFrecMagnitude_MeanFreq= mean(BodyAccFrecMagnitude_MeanFreq),
                    avg_BodyAccJerkFrecMagnitude_Mean= mean(BodyAccJerkFrecMagnitude_Mean),avg_BodyAccJerkFrecMagnitude_Std= mean(BodyAccJerkFrecMagnitude_Std),avg_BodyAccJerkFrecMagnitude_MeanFrec= mean(BodyAccJerkFrecMagnitude_MeanFrec),
                    avg_BodyGyroFrecMagnitude_Mean= mean(BodyGyroFrecMagnitude_Mean),avg_BodyGyroFrecMagnitude_Std= mean(BodyGyroFrecMagnitude_Std),avg_BodyGyroFrecMagnitude_MeanFrec= mean(BodyGyroFrecMagnitude_MeanFrec),
                    avg_BodyGyroJerkFrecMagnitude_Mean= mean(BodyGyroJerkFrecMagnitude_Mean),avg_BodyGyroJerkFrecMagnitude_Std= mean(BodyGyroJerkFrecMagnitude_Std),avg_BodyGyroJerkFrecMagnitude_MeanFrec= mean(BodyGyroJerkFrecMagnitude_MeanFrec)
)

tidyData
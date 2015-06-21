setwd("D:/Online courses/Coursera courses/Data Science Specialization/03 - Getting and cleaning data/Project")
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","datafile.zip")
#unzip("datafile.zip")

### Read the train data set
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = "subjects")
trainActivities <- read.table("./UCI HAR Dataset/train/y_train.txt",col.names = "activities")
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainComplete <- cbind(trainSubjects,trainActivities,train)

### Read the test data set
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",col.names = "subjects")
testActivities <- read.table("./UCI HAR Dataset/test/y_test.txt",col.names = "activities")
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
testComplete <- cbind(testSubjects,testActivities,test)

### Merge both data sets
mergedData <- rbind(trainComplete,testComplete)


### Read features
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("variable number","name"),stringsAsFactors = F)
# Find variables with means and std
featuresMean <- grep("mean",features$name)
featuresStd <- grep("std",features$name)
# Variables to select
SelecFeatures <- sort(c(featuresMean,featuresStd))
### Select them in the merged Data frame (step 2)
SelectedData <- cbind(mergedData[,c(1,2)],mergedData[,-c(1,2)][,SelecFeatures])
#change variable names 
names(SelectedData)[-c(1,2)] <- features$name[SelecFeatures]

### Change the activities by their names instead of the code
SelectedData$activities[SelectedData$activities == 1] <- "Walking"
SelectedData$activities[SelectedData$activities == 2] <- "Walking_upstairs"
SelectedData$activities[SelectedData$activities == 3] <- "Walking_downstairs"
SelectedData$activities[SelectedData$activities == 4] <- "Sitting"
SelectedData$activities[SelectedData$activities == 5] <- "Standing"
SelectedData$activities[SelectedData$activities == 6] <- "Laying"

### Create a data frame with means for each activity and subject (step 5)
MeanData <- aggregate(SelectedData[,-c(1,2)],list(Subject = SelectedData$subjects,Activity = SelectedData$activities),mean)
#write.table(MeanData,"MeanData.txt",row.name = F)

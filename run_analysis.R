## Read in and assign each file to an object in R. Assumes the working directory is the "UCI HAR Dataset" directory

features<-read.table("./features.txt")
labels<-read.table("./activity_labels.txt")

ytest<-read.table("./test/y_test.txt")
xtest<-read.table("./test/X_test.txt")
subtest<-read.table("./test/subject_test.txt")

ytrain<-read.table("./train/y_train.txt")
xtrain<-read.table("./train/X_train.txt")
subtrain<-read.table("./train/subject_train.txt")

## 1. Merges the training and the test sets to create one data set.

testset<-cbind(ytest, subtest, xtest)
trainset<-cbind(ytrain, subtrain, xtrain)
dataset<-rbind(testset, trainset)

## 4. Appropriately labels the data set with descriptive variable names.
## Step 4 is performed before step 2 in order to simplify the code for step 2 and 3

colnames(dataset)<-c("Activity", "Subject", features[,2])
colnames(labels)<-c("Activity", "ActivityName")

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

dataset2<-select(dataset, matches("Activity|Subject|mean|std"))

## 3. Uses descriptive activity names to name the activities in the data set

dataset3<-merge(labels, dataset2)

## 5. From the data set in the above step, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.

dataset4<-group_by(dataset3, ActivityName, Subject)
tidydataset<-aggregate(dataset4[,4:89], list(Subject=dataset4$Subject, ActivityName=dataset4$ActivityName), mean)
tidydataset<-tidydataset[,c(2,1,3:88)]
write.table(tidydataset, "Tidy Data Set.txt")


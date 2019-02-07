library(dplyr)
filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
if(!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL,filename,method = "curl")
}

if(!file.exists("UCI HAR Dataset")){
    unzip(filename)
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")


X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)


Tidy_Data <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

Tidy_Data$code <- activities[Tidy_Data$code, 2]

names(Tidy_Data)[2] = "activity"
names(Tidy_Data)<-gsub("Acc", "Accelerometer", names(Tidy_Data))
names(Tidy_Data)<-gsub("Gyro", "Gyroscope", names(Tidy_Data))
names(Tidy_Data)<-gsub("BodyBody", "Body", names(Tidy_Data))
names(Tidy_Data)<-gsub("Mag", "Magnitude", names(Tidy_Data))
names(Tidy_Data)<-gsub("^t", "Time", names(Tidy_Data))
names(Tidy_Data)<-gsub("^f", "Frequency", names(Tidy_Data))
names(Tidy_Data)<-gsub("tBody", "TimeBody", names(Tidy_Data))
names(Tidy_Data)<-gsub("-mean()", "Mean", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-std()", "STD", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-freq()", "Frequency", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("angle", "Angle", names(Tidy_Data))
names(Tidy_Data)<-gsub("gravity", "Gravity", names(Tidy_Data))

myData <- Tidy_Data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean),na.rm = T)


write.table(myData, "myData.txt", row.name=FALSE)





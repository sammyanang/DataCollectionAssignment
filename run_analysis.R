filename <- "Coursera_DS3_Final.zip"

# Download data zip if not already done.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Unzip downloaded data zip
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Assigning data to data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Merge  x and y datasets from train and test
#Merge all x rows
merged_x <- rbind(x_test,x_train)
#Merge all y rows
merged_y <- rbind(y_test, y_train)
#Merge all subject rows
merged_subject <- rbind(subject_test, subject_train)
#Merge all subject, x and y rows by column
final_merged <- cbind(merged_subject,merged_x,merged_y)

#Extract only the measurements on the mean and standard deviation for each measurement.
tidy_data <- select(final_merged,subject, code, contains("mean"), contains("std"))

#Use descriptive activity names to name the activities in the data set
tidy_data$code <- activities[tidy_data$code, 2]

#Appropriately label the data set with descriptive variable names.
names(tidy_data)[2] = "activity"
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
final_independent_tidy_data <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(final_independent_tidy_data, "FinalIndependentTidyData.txt", row.name=FALSE)


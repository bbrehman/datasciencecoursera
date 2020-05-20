

# Download and extract Zip File
filename <- "UCI HAR Dataset.zip"
dataURL <-
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists(filename)) {
    download.file(dataURL, filename)
}
# unzip
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
    unzip(filename)
    
}

#Print all files
pathFiles <- file.path(getwd() , dataPath)
files <- list.files(dataPath, recursive = TRUE)
print(files)


#merge train data
trainValues <-
    read.table(file.path(dataPath, "train" , "X_train.txt"), header = FALSE)
trainActivities <-
    read.table(file.path(dataPath, "train" , "Y_train.txt"), header = FALSE)
trainSubjects <-
    read.table(file.path(dataPath, "train" , "subject_train.txt"), header = FALSE)

# test data
testValues <-
    read.table(file.path(dataPath, "test" , "X_test.txt"), header = FALSE)
testActivities <-
    read.table(file.path(dataPath, "test" , "Y_test.txt"), header = FALSE)
testSubjects <-
    read.table(file.path(dataPath, "test" , "subject_test.txt"), header = FALSE)

#train data
values <- rbind(trainValues, testValues)
activities <- rbind(trainActivities, testActivities)
subjects <- rbind(trainSubjects, testSubjects)


#column names
activityLabels <-
    read.table(file.path(dataPath, "" , "activity_labels.txt"), header = FALSE)
activityLabels$V2 <-  as.character(activityLabels$V2)

colnames(activities) <- c("activity")
colnames(subjects) <- c("subject")
features <-
    read.table(file.path(dataPath, "features.txt"), head = FALSE)
names(values) <- features$V2

#merge train and test data
tmp <- cbind(subjects, activities)
data <- cbind(values, tmp)


# map activity descritpion
data$activity <-
    factor(data$activity, levels = activityLabels[, 1], labels = activityLabels[, 2])


# remove unnecessary tables to save memory
rm(
    trainValues,
    trainActivities,
    trainSubjects,
    testValues,
    testActivities,
    testSubjects,
    values,
    activities,
    subjects,
    activityLabels,
    features
)



#map abbreviation
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))

print(names(data))


#prepare and write out data
library(plyr)

out <- aggregate(. ~ subject + activity, data, mean)
out <- out[order(out$subject, out$activity), ]
write.table(out, file = "tidydata.txt", row.name = FALSE, quote = FALSE)


#printout tidydata
tidydata <-
    read.table(file.path(getwd(), "" , "tidydata.txt"),
               header = FALSE)
print(str(tidydata))


#install the package "plyr" if you don't have one
library(plyr)

# First Step - Merge the training and test sets to create one data set
#Get data from text files and assign to specific variable
#You suppose to have all files in your repository unzipped
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
# Bind all data from "x" data sets
x_all <- rbind(x_train, x_test)
# Bind all data from "y" data sets
y_all <- rbind(y_train, y_test)
# Bind all data from "subject" data sets
subject_all <- rbind(subject_train, subject_test)

# Second Step - Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")
# Only get measurement on mean and standard deviation
get_features <- grep("-(mean|std)\\(\\)", features[, 2])
# separate the columns that we need
x_all <- x_all[, get_features]
# assign correct names
names(x_all) <- features[get_features, 2]

# Third Step - Use descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
# Assign activity names to a certain variables. Get acteivity names from the given text file
y_all[, 1] <- activities[y_all[, 1], 2]
# correct column name
names(y_all) <- "activity"

# Fourth Step - Appropriately label the data set with descriptive variable names
# assign proper column name
names(subject_all) <- "subject"
# Bind all data into one huge data set
dataset <- cbind(x_all, y_all, subject_all)

# Final Fifth Step - Create a second, independent tidy data set with the average of each variable for each activity and each subject
data_of_averages <- ddply(dataset, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(data_of_averages, "data_of_averages.txt", row.name=FALSE)

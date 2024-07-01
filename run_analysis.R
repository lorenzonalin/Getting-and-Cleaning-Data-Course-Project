# Load required packages
library(dplyr)

# Step 1: Download and unzip the data
zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file <- "UCI_HAR_Dataset.zip"
download.file(zip_url, zip_file)
unzip(zip_file)

# Step 2: Load the data
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")

test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Step 3: Merge the training and test sets
merged_x <- rbind(train_x, test_x)
merged_y <- rbind(train_y, test_y)
merged_subject <- rbind(train_subject, test_subject)

# Step 4: Extract mean and standard deviation measurements
mean_std_indices <- grep("-(mean|std)\\(\\)", features$V2)
merged_x <- merged_x[, mean_std_indices]

# Step 5: Use descriptive activity names
merged_y <- merge(merged_y, activity_labels, by.x = "V1", by.y = "V1")[, 2]

# Step 6: Label the dataset with descriptive variable names
names(merged_x) <- features[mean_std_indices, 2]
names(merged_x) <- gsub("^t", "time", names(merged_x))
names(merged_x) <- gsub("^f", "frequency", names(merged_x))
names(merged_x) <- gsub("Acc", "Accelerometer", names(merged_x))
names(merged_x) <- gsub("Gyro", "Gyroscope", names(merged_x))
names(merged_x) <- gsub("Mag", "Magnitude", names(merged_x))
names(merged_x) <- gsub("BodyBody", "Body", names(merged_x))

# Combine subject, activity, and measurements into one dataset
merged_data <- cbind(merged_subject, merged_y, merged_x)
names(merged_data)[1:2] <- c("subject", "activity")

# Step 7: Create a second, independent tidy dataset
tidy_data <- merged_data %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))

# Define the output file path
output_file <- "C:/Users/Lorenzo Nalin/Dropbox/Corso R/Data-cleaning/Peer-graded-Assignment-Getting-and-Cleaning-Data-Course-Project/tidy_data.txt"

# Write the tidy dataset to a file
write.table(tidy_data, output_file, row.name = FALSE)
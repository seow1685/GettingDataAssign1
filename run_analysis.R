
library(reshape2)


require("R.utils")

if(!file.exists("./data")){dir.create("./data")}

Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data/UCI.zip")){download.file(Url, destfile = "./data/UCI.zip")}

unzip("./data/UCI.zip",exdir = "./data" )



subject.test <- read.table("data/UCI HAR Dataset/test/subject_test.txt", header=FALSE, col.names=c("Subject.ID"))
subject.train <- read.table("data/UCI HAR Dataset/train/subject_train.txt", header=FALSE, col.names=c("Subject.ID"))
str(subject.test)
summary(subject.test)
table(subject.test)
table(subject.train)


y.test <- read.table("data/UCI HAR Dataset/test/y_test.txt", header=FALSE, col.names=c("Activity"))
y.train <- read.table("data/UCI HAR Dataset/train/y_train.txt", header=FALSE, col.names=c("Activity"))
str(y.test)
head(y.test)



features <- read.table("data/UCI HAR Dataset/features.txt", header=FALSE, as.is=TRUE, col.names=c("Featire.ID", "Featire.Name"))
str(features)



X.test <- read.table("data/UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="", col.names=features$Featire.Name)
X.train <- read.table("data/UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="", col.names=features$Featire.Name)
str(X.train)
summary(X.test)


mean.std.index <- grep(".*mean\\(\\)|.*std\\(\\)", features$Featire.Name)

str(mean.std.index)

X.test <- X.test[, mean.std.index]
X.train <- X.train[, mean.std.index]
head(X.test)


X.test$Subject.ID <- subject.test$Subject.ID
X.train$Subject.ID <- subject.train$Subject.ID


X.test$Activity <- y.test$Activity
X.train$Activity <- y.train$Activity



X.data <- rbind(X.test, X.train)
names(X.data)
head(X.data)


activity.labels <- read.table("data/UCI HAR Dataset/activity_labels.txt", header=F, col.names=c("Activity", "Activity.Name"))

activity.labels

activity.labels$Activity.Name <- as.factor(activity.labels$Activity.Name)

          
X.data$Activity <- factor(X.data$Activity, levels = 1:6, labels = activity.labels$Activity.Name)
head(X.data)
names(X.data)

column.names <- colnames(X.data)

column.names <- gsub("\\.+mean\\.+", column.names, replacement="Mean")
column.names <- gsub("\\.+std\\.+", column.names, replacement="Std")

column.names <- gsub("Mag", column.names, replacement="Magnitude")
column.names <- gsub("Acc", column.names, replacement="Accelerometer")
column.names <- gsub("Gyro", column.names, replacement="Gyroscope")
column.names

colnames(X.data) <- column.names


meltdata <- melt(X.data, id.vars = c("Activity", "Subject.ID"))
tidydata <- dcast(meltdata, Activity + Subject.ID ~ variable, mean)
head(meltdata)

head(tidydata)
table(tidydata$Subject.ID)

write.table(tidydata, "tidydata.txt", row.names = FALSE)

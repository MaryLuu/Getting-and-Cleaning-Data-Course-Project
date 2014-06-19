# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# Good luck!

setwd("C:/Users/PCPC/Desktop/Data-cleaning/getdata-projectfiles-UCI-HAR-Dataset")
getwd()

###
# 1.Merges the training and the test sets to create one data set:

# tr <- training
# ts <- test

# reading data
X_ts <- read.table("./test/X_test.txt")
head(X_ts)

X_tr <- read.table("./train/X_train.txt")
head(X_tr)


y_ts <- read.table("./test/y_test.txt")
head(y_ts)

y_tr <- read.table("./train/y_train.txt")
head(y_tr)


s_tr <- read.table("./train/subject_train.txt")
s_ts <- read.table("./test/subject_test.txt")

# Merges

X_tr_ts <- rbind.data.frame(X_tr, X_ts)
head(X_tr_ts)
tail(X_tr_ts)
dim(X_tr_ts)


Y_tr_ts <- rbind.data.frame(y_tr, y_ts)
head(Y_tr_ts)
tail(Y_tr_ts)
dim(Y_tr_ts)

s <- rbind(s_tr, s_ts)
head(s)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
Fe <- read.table("./features.txt")
head(Fe)


MeanSD_X_tr_ts <- grep("-mean\\(\\)|-std\\(\\)", Fe$V2)
x.mean.sd <- X_tr_ts[ ,MeanSD_X_tr_ts]

head(x.mean.sd)

# Mean_X_tr_ts <- sapply(X_tr_ts, mean)
# head(Mean_X_tr_ts)
# SD_X_tr_ts <- sapply(X_tr_ts, sd)
# head(SD_X_tr_ts)

# Uses descriptive activity names to name the activities in the data set

activ <- read.table('./activity_labels.txt')
activ
activ[, 2] <- tolower(gsub("_", "", activ[, 2]))
activ_descrip  <- activ[Y_tr_ts[, 1], 2]
Y_tr_ts[, 1] <- activ_descrip
names(Y_tr_ts) <- "act"

# Appropriately labels the data set with descriptive variable names. 
names(s) <- "subject"
new_table <- cbind(s, Y_tr_ts, X_tr_ts)
dim(new_table)
write.table(new_table, './new_merged_set.txt')
head(new_table)
dim(s)
dim(Y_tr_ts)
dim(new_table)
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

average <- aggregate(new_table, by=list(activ=new_table$act, s=new_table$subject), mean)
write.table(average, './average.txt')


# First set your working directory. Please adapt the root directory accordingly depending on the computer and working directory that you are currently using. 

WorkingDir <- "/Documents/Coursera_DataScience/GettingCleaningData/"

setwd(WorkingDir)

list.files(WorkingDir)


# Set a foldername for the folder where your data is stored. Please adapt the folder name in the following command according to your actual folder name where your data is stored: 

folderName <- "UCI_HAR_Dataset/"


# Load the needed data. Please adapt the following command depending on the folder name you are using: 

activity_labels <- read.table(paste0(WorkingDir, folderName, "activity_labels.txt"))

x_train <- read.table(paste0(WorkingDir, folderName, "train/X_train.txt"))

class(x_train)
dim(x_train)
colnames(x_train)
str(x_train)


y_train <- read.table(paste0(WorkingDir, folderName, "train/Y_train.txt"))

class(y_train)
dim(y_train)


subject_train <- read.table(paste0(WorkingDir, folderName, "train/subject_train.txt"))

class(subject_train)
dim(subject_train)


x_test <- read.table(paste0(WorkingDir, folderName, "test/X_test.txt"))

class(x_test)
dim(x_test)


y_test <- read.table(paste0(WorkingDir, folderName, "test/Y_test.txt"))

class(y_test)
dim(y_test)


subject_test <- read.table(paste0(WorkingDir, folderName, "test/subject_test.txt"))

class(subject_test)
dim(subject_test)


features <- read.table(paste0(WorkingDir, folderName, "features.txt"))

class(features)
dim(features)
colnames(features)
head(features)

# Eliminate parentheses, commas, dollar signs, and hyphens from the feature names in order to avoid difficulties later on: 

library(dplyr)

features$V2 %>% {gsub("\\()", "", .)} %>% {gsub("\\-", "_", .)} %>% {gsub("\\(", "_", .)} %>% {gsub("\\)", "_", .)} %>% {gsub("\\,", "", .)}%>% {gsub("_$", "", .)}-> features_Clean

features_Clean

# Give column names to the different data frames: 

colnames(x_train) <- features_Clean

str(x_train)
length(colnames(x_train))
head(colnames(x_train))


colnames(x_test) <- features_Clean
head(colnames(x_test))
str(x_test)

colnames(y_train) <- "y_label"
colnames(y_train)

colnames(y_test) <- "y_label"
colnames(y_test)

colnames(subject_train) <- "subject"
str(subject_train)

colnames(subject_test) <- "subject"
str(subject_test)



# Combine the different data fraims into a training_set and a test_set:

dim(subject_train)
dim(x_train)
dim(y_train)

training_set <- cbind(subject_train, x_train, y_train)

dim(training_set)
head(colnames(training_set))


dim(subject_test)
dim(x_test)
dim(y_test)

test_set <- cbind(subject_test, x_test, y_test)

dim(test_set)
head(colnames(test_set))


# Create vectors of activity label names for both training_set and test_set: 


colnames(activity_labels) <- c("label", "activity")

activity_labels


# For the training set: 

indices_list_train <- vector("list",length(activity_labels$label))
for(i in 1:length(activity_labels$label)){
	indices_list_train[[i]] <- which(activity_labels$label[i] == training_set$y_label)
	}



training_set$activity <- rep(0, dim(training_set)[1])
for(i in 1:length(activity_labels$label)){
	training_set$activity[indices_list_train[[i]]] <- as.character(activity_labels$activity[i])
	}


# Verify if the activity names match the y labels: 

head(training_set$activity[training_set$y_label == 1])
tail(training_set$activity[training_set$y_label == 1])
head(training_set$activity[training_set$y_label == 2])
head(training_set$activity[training_set$y_label == 3])
head(training_set$activity[training_set$y_label == 4])
head(training_set$activity[training_set$y_label == 5])
head(training_set$activity[training_set$y_label == 6])

activity_labels
head(colnames(training_set))
tail(colnames(training_set))

# For the test set: 

indices_list_test <- vector("list",length(activity_labels$label))
for(i in 1:length(activity_labels$label)){
	indices_list_test[[i]] <- which(activity_labels$label[i] == test_set$y_label)	
	}


test_set$activity <- rep(0, dim(test_set)[1])
for(i in 1:length(activity_labels$label)){
	test_set$activity[indices_list_test[[i]]] <- as.character(activity_labels$activity[i])
	}


# Verify if the activity names match the y labels: 

head(test_set$activity[test_set$y_label == 1])
tail(test_set$activity[test_set$y_label == 1])
head(test_set$activity[test_set$y_label == 2])
head(test_set$activity[test_set$y_label == 3])
head(test_set$activity[test_set$y_label == 4])
head(test_set$activity[test_set$y_label == 5])
head(test_set$activity[test_set$y_label == 6])

activity_labels


head(colnames(test_set))
tail(colnames(test_set))

# Merge training_set and test_set. First check the dimensions of the two data sets: 

dim(training_set)
head(colnames(training_set))
tail(colnames(training_set))

dim(test_set)
head(colnames(test_set))
tail(colnames(test_set))

# Check if the column names of the data frames to be merged are the same:
 
sum(colnames(training_set) == colnames(test_set))

sum(!colnames(training_set) == colnames(test_set))

# All column names match, good. 


# Check if the number of columns in the two data frames are the same: 
dim(training_set)
dim(test_set)

# Merge the two data frames: 
Data_TrainingAndTest <- rbind(training_set, test_set)
dim(Data_TrainingAndTest)


# Check if the number of rows in the new data frame equals the sum of the number of rows of the two original data frames: 
dim(training_set)
dim(test_set)
dim(training_set)[1] + dim(test_set)[1]

head(colnames(Data_TrainingAndTest))
tail(colnames(Data_TrainingAndTest))



# Extracting means and standard deviations: 

length(features_Clean)

head(features_Clean, n = 20)


colnames(Data_TrainingAndTest)[c(grep("mean", colnames(Data_TrainingAndTest)), grep("std", colnames(Data_TrainingAndTest)))]


TrainTest_MeanStd <- Data_TrainingAndTest[grepl("mean", colnames(Data_TrainingAndTest)) | grepl("std", colnames(Data_TrainingAndTest))]


# Check dimensions: 

dim(Data_TrainingAndTest)
dim(TrainTest_MeanStd)



# Add the subject, y_label and activity columns again: 

library(dplyr)
TrainTest_MeanStd %>% mutate(subject = Data_TrainingAndTest$subject, y_label = Data_TrainingAndTest$y_label, activity = Data_TrainingAndTest$activity) -> TrainTest_MeanStd_Complete

dim(TrainTest_MeanStd_Complete)
colnames(TrainTest_MeanStd_Complete)
tail(colnames(TrainTest_MeanStd_Complete))
head(colnames(TrainTest_MeanStd_Complete))



#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

# In order to calculate the means of each variable for each activity and subject (meaning we will have a mean for every variable-activity-subject combination), create an additional column vector indicating activity-subject-combinations (I call this vector 'factorCombinations even though my code does not actually convert the activity and subject character vectors into factors (not necessary). The new vector 'factorCombination' will be converted into a factor though): 



TrainTest_MeanStd_Complete$factorCombinations <- paste0(as.character(TrainTest_MeanStd_Complete$activity), "_", as.character(TrainTest_MeanStd_Complete$subject))

# Get an impression of the newly created variable: 
length(TrainTest_MeanStd_Complete$factorCombinations)
head(TrainTest_MeanStd_Complete$factorCombinations)
tail(TrainTest_MeanStd_Complete$factorCombinations)


# Check how many levels this variable shall have when converted into a factor: 
length(unique(TrainTest_MeanStd_Complete$factorCombinations))


# Convert the new character vector 'factorCombinations' into a factor: 

class(TrainTest_MeanStd_Complete$factorCombinations)

TrainTest_MeanStd_Complete$factorCombinations <- factor(TrainTest_MeanStd_Complete$factorCombinations, levels= unique(TrainTest_MeanStd_Complete$factorCombinations))

class(TrainTest_MeanStd_Complete$factorCombinations)
length(levels(TrainTest_MeanStd_Complete$factorCombinations))

length(TrainTest_MeanStd_Complete$factorCombinations)
head(TrainTest_MeanStd_Complete$factorCombinations)
tail(TrainTest_MeanStd_Complete$factorCombinations)


# Take a couple of samples to check if the 'factorCombinations' vector has been attributed correctly, i.e. if its entries match the entries of the vectors 'subject' and 'activity': 

columnsSubActFactorcom <- c(which(colnames(TrainTest_MeanStd_Complete) == "subject"), which(colnames(TrainTest_MeanStd_Complete) == "activity"), which(colnames(TrainTest_MeanStd_Complete) == "factorCombinations"))

dim(TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[1], columnsSubActFactorcom])

TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[1], columnsSubActFactorcom]

dim(TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[2], columnsSubActFactorcom])

TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[2], columnsSubActFactorcom]

dim(TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[10], columnsSubActFactorcom])

TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[10], columnsSubActFactorcom]

head(TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[21], columnsSubActFactorcom])
tail(TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[21], columnsSubActFactorcom])

head(TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[100], columnsSubActFactorcom])
tail(TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[100], columnsSubActFactorcom])

head(TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[150], columnsSubActFactorcom])
tail(TrainTest_MeanStd_Complete[TrainTest_MeanStd_Complete$factorCombinations == levels(TrainTest_MeanStd_Complete$factorCombinations)[150], columnsSubActFactorcom])

length(levels(TrainTest_MeanStd_Complete$factorCombinations))


colnames(TrainTest_MeanStd_Complete)



# Create a new data frame where the mean values will be stored: 

PrecursorMatrix_forDF <- matrix(0, length(levels(TrainTest_MeanStd_Complete$factorCombinations)), length(colnames(TrainTest_MeanStd_Complete)))

dim(PrecursorMatrix_forDF)

VariableMeans_ActivitySubject <- data.frame(PrecursorMatrix_forDF)
colnames(VariableMeans_ActivitySubject) <- colnames(TrainTest_MeanStd_Complete)

dim(VariableMeans_ActivitySubject)
tail(colnames(VariableMeans_ActivitySubject))


# Calculate the means of all variables for each subject and activity and store them in the new data frame: 

for(i in 1:dim(TrainTest_MeanStd)[2]){
	
	VariableMeans_ActivitySubject[,i] <- as.vector(tapply(TrainTest_MeanStd_Complete[,i], TrainTest_MeanStd_Complete$factorCombinations, mean, simplify = TRUE))
	
}


# Add the vector 'factorCombinations' to the new data frame: 

VariableMeans_ActivitySubject$factorCombinations <- names(tapply(TrainTest_MeanStd_Complete$tBodyAcc_mean_X, TrainTest_MeanStd_Complete$factorCombinations, mean, simplify = FALSE))


# Split the 'factorCombinations' vector of the new data frame into activity and subject labels:  

splitActivitySubject <- strsplit(VariableMeans_ActivitySubject$factorCombinations, "_")

class(unlist(splitActivitySubject))
length(splitActivitySubject)
dim(VariableMeans_ActivitySubject)
length(unlist(splitActivitySubject))
head(unlist(splitActivitySubject))


# Just check if you can extract subject and activity correctly with some examples: 

splitActivitySubject[[1]]

splitActivitySubject[[1]][length(splitActivitySubject[[1]])]

splitActivitySubject[[1]][1:(length(splitActivitySubject[[1]]))-1]


splitActivitySubject[[179]]

splitActivitySubject[[179]][length(splitActivitySubject[[179]])]

splitActivitySubject[[179]][1:(length(splitActivitySubject[[179]]))-1]



# Add subject and activity vectors to their respective columns: 

for(i in 1:length(splitActivitySubject)){
	
	VariableMeans_ActivitySubject$subject[i] <- splitActivitySubject[[i]][length(splitActivitySubject[[i]])]
	
	VariableMeans_ActivitySubject$activity[i] <- paste0(splitActivitySubject[[i]][1:(length(splitActivitySubject[[i]]))-1], collapse = "_")
	
}


head(VariableMeans_ActivitySubject$activity)
head(VariableMeans_ActivitySubject$subject)

tail(colnames(VariableMeans_ActivitySubject))
length(colnames(VariableMeans_ActivitySubject))


# Get rid of the empty y_label column: 
VariableMeans_ActivitySubject$y_label <- NULL


# Have a look to check if the subject and activity columns match the factorCombinations column: 

head(VariableMeans_ActivitySubject[,80:82])
VariableMeans_ActivitySubject[,80:82]


# Voilà, here are your data frames:


# Question 4: 

str(TrainTest_MeanStd_Complete)

head(TrainTest_MeanStd_Complete)

dim(TrainTest_MeanStd_Complete)



# Question 5: 
str(VariableMeans_ActivitySubject)

head(VariableMeans_ActivitySubject)

dim(VariableMeans_ActivitySubject)



# Save data to working directory as txt file: 
write.table(VariableMeans_ActivitySubject, paste0(WorkingDir, "VariableMeans_ActivitySubject.txt"), row.name = FALSE)


# Reimport the data frame as 'Mydata' to check if the data frame has been saved correctly: 

Mydata <- read.table(paste0(WorkingDir, "VariableMeans_ActivitySubject.txt"), header = TRUE)

dim(Mydata)
dim(VariableMeans_ActivitySubject)

colnames(Mydata)
colnames(VariableMeans_ActivitySubject)

sum(!colnames(Mydata) == colnames(VariableMeans_ActivitySubject))

head(Mydata)

sum(!(round(Mydata[,1]) == round(VariableMeans_ActivitySubject[,1])))

sum(!(round(Mydata[,10]) == round(VariableMeans_ActivitySubject[,10])))


SumLogicals <- 0

for(i in 1:79){
	SumLogicals <- SumLogicals + sum(!(round(Mydata[,i]) == round(VariableMeans_ActivitySubject[,i])))
	
}

SumLogicals
# Codebook: Assignment "Getting and Cleaning Data" on Coursera

## Source of Data: 

### Downloading Data and Information: 
The data were downloaded from the following site: 
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]
The downloaded data include the following files: 

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. 
Every row shows a 128 element vector. The same description applies for the 'total_acc_y_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Experiment: 
30 test persons (in the data sets and in the R code referred to as "subjects") performed six activities 
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) while wearing a smartphone (Samsung Galaxy S II) 
on their waist.
The smartphone carried out different measurements with regards to the physical movement of the test persons. The variables 
(also referred to as features) measured by the smartphone can be interpreted as characteristics of the physical activity performed by
test persons (subjects). 
 
A detailed description of the experiment and its measurements can be found here: 
[https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]


### Measurements and Variables: 
The smartphone is equipped with an accelerometer and a gyroscope, hence it measures features related to acceleration and 
angular velocity. These measurements are in the time domain (variable names with t in the beginning) and were used to derive 
signals in the frequency domain (variable names with f in the beginning). Based on these signals (both in the time and in 
the frequency domain) various variables (such as mean, standard deviation and others) were estimated. More detailed information 
about measurements and variables can be found in the 'README.txt' and 'features_info.txt' files (see above). 

A complete list of all variable names can be found in the 'features.txt'file. 

The test persons were subdivided into a training set (70% of test persons) and a test set (30% of test persons). The values 
of the different variables are found in the 'x_train.txt' (training set) and the 'x_test.txt' (test set) files, where every 
row represents one measurement and every column represents one variable. 


### Subject and Activity Labels: 
The subjects (test persons) are numbered, and the different physical activities carried out by the subjects are coded as numbers 
(class labels) as well.
The files 'subject_train.txt' and 'subject_test.txt' contain the subject numbers corresponding to the measurements in the files 
'x_train.txt' and 'x_test.txt'. The 'activity_labels.txt' file contains a legend that attributes class labels (numbers) to each 
of the physical activities carried out by the subjects. The 'y_train.txt' and 'y_test.txt' files contain the class labels (coding 
for activities) corresponding to each measurement in the 'x_train.txt' and 'x_test.txt' files. Hence, the number of rows is 
the same in the 'y_train.txt', 'x_train.txt' and'subject_train.txt' files, and respectively in the 'y_test.txt','x_test.txt', 
and 'subject_test.txt' files. 


## Data Cleaning Procedure:

(also see remarks in R-script)

### Loading Data: 
All data frames are loaded into R and stored in the following R objects:
activity_labels, features, subject_test, subject_train, WorkingDir, x_test, x_train, y_test, y_train 


### Naming the Variables: 
In order to avoid difficulties later on, parentheses, commas, dollar signs, and hyphens are eliminated from the feature names: 
from 'features' to 'features_Clean'.

The feature names in 'features_Clean' are used as column names for the data frames containing the variable values 
('x_train' and 'x_test'). "y_label" and "subject" are used as column names for the data frames containing the class labels 
and the subject numbers respectively ('y_test', 'y_train', 'subject_test', 'subject_train'). 


### Combing Data Frames into 'training_set' and 'test_set': 
'subject_train', 'x_train' and 'y_train' are combined into 'training_set' row-wise (using the cbind command, the rows match).
'subject_test', 'x_test' and 'y_test' are combined into 'test_set'row-wise (using the cbind command, the rows match).

Based on 'activity_labels' two vectors ('training_set$activity' and 'test_set$activity') containing activity labels corresponding 
to the measurements in x_train and y_train are created. The two new vectors match y_train and y_test respectively and are
added to training_set and test_set. 

### Combining 'training_set' and 'test_set' into 'Data_TrainingAndTest': 
Merge training_set and test_set column wise (by using rbind, the columns match) into 'Data_TrainingAndTest'. 

### Extracting all Variables Representing Means and Standard Deviations: 
All variables representing mean values or standard deviation values are extracted by searching for the patterns "mean" and "std"
within the variable names and are attributed to a new data frame 'TrainTest_MeanStd'. subject, y_label and activity columns
are then added and the data frame is renamed 'TrainTest_MeanStd_Complete'.

### Summarizing the Extracted Means and Standard Deviations by taking their means (Means of Means and Means of Standard Deviations)
for for every variable-subject-activity combination: 
TrainTest_MeanStd_Complete contains several data points for every variable-subject-activity combination. These data can thus be 
summarized by taking the mean value for every such combination and storing it in a new data frame 'VariableMeans_ActivitySubject'.
In order to calculate the means of each variable for each activity and subject, an additional variable indicating 
activity-subject-combinations is created (I call this variable 'factorCombinations' even though my code does not actually convert 
the activity and subject variables into factors (not necessary). The new variable 'factorCombination' is then converted into a factor. 
This factor 'factorCombination' is then used to take the mean for every activity-subject combination of any given variable by using 
'tapply'. Since we have many variables the code loops through all the variables. 

Subject and activity labels are created by splitting the factorCombination entries and are added to the new data frame 
'VariableMeans_ActivitySubject'. 

### Saving the Resulting Data Frame: 
Finally, the 'VariableMeans_ActivitySubject' data frame is saved as a text file to the working directory. 


















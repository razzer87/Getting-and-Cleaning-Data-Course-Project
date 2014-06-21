#Assumes the file is already downloaded and unzipped to working directory.

library(xtable)
library(data.table)
library(reshape2)

reader <- function(xfile,yfile,sfile){
        #This function takes three string arguments representing file locations
        #It uses the features.txt file to add column names to x, then filters
        #out the mean() and std() values.
        #It adds a column name to the yfile and changes the numbers to the 
        #activity names from activity_labels.txt
        #It adds a column name to the s file.
        #Then it cbinds the three tables together to form an output
        
        #get labels
        activity <- read.table("UCI HAR Dataset/activity_labels.txt")
        features <- read.table("UCI HAR Dataset/features.txt")
        
        #get data
        x <- read.table(xfile)
        y <- read.table(yfile)
        s <- read.table(sfile)

        #Clean up the x table
        colnames(x) <- features$V2

        filter1 <- sapply(features$V2,grepl,pattern="mean()",fixed=TRUE)
        filter2 <- sapply(features$V2,grepl,pattern="std()",fixed=TRUE)
        filtered <- subset(features$V2,filter1|filter2)
        x <- x[ , which(names(x) %in% filtered)]

        #Convert y to activity names
        y$V1 <- as.factor(y$V1)
        levels(y$V1) <- levels(activity$V2)
        colnames(y) <- "Activity"

        #Bind them together
        colnames(s) <- "Subject"
        cbind(s,y,x)
        }


#call function on training data
data.train <- reader("UCI HAR Dataset/train/x_train.txt",
       "UCI HAR Dataset/train/y_train.txt",
       "UCI HAR Dataset/train/subject_train.txt")

#call function on test data
data.test <- reader("UCI HAR Dataset//test/x_test.txt",
                    "UCI HAR Dataset/test/y_test.txt",
                    "UCI HAR Dataset/test/subject_test.txt")


#bind it together
data <- rbind(data.train,data.test)

#get measurement names
measures <- subset(colnames(data),colnames(data)!="Activity" & colnames(data)!= "Subject")

#melt dataframe, then cast with mean as function
dtmelt <- melt(data,id=c("Subject","Activity"),measure.vars=measures)
final <- dcast(dtmelt, Subject + Activity ~ variable,mean)

#final is a table of 180 rows and 68 columns. The first two columns are subject 
#and activity respectively, and the rest are the mean of each of the mean() and
#std() values for each measurement taken for each pair of subject and activity
##this is written to the file output.txt
write.table(final, file="output.txt")

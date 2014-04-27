
# -------------------------------------------------------------------
# Fetch all data required in order to build single data.frame
# storing all information for a given group. Currently `group_name`
# argument can take one of the two possible values "test" or "train"
# --------------------------------------------------------------------
create_group_df <- function (group_name) {
    
    # check for the correctness of `group_name`
    if (!(group_name %in% c('test', 'train'))) {
        stop(sub('-name-', group_name, 
                  "Unrecognized group_name: -name-!"))
    }

    # -----------------------------
    # Get observation variables ---
    # -----------------------------
    path <- gsub("-name-", group_name, "./data/-name-/X_-name-.txt")
    x <- read.table(path)
    # get features list ...
    features <- read.table('./data/features.txt')
    names(features) <- c('index', 'name')
    # ... retrieve positions of Mean and SD columns ...
    mean_mask <- with(features, grepl("mean\\(\\)", name))
    std_mask <-  with(features, grepl("std\\(\\)", name))
    mean_and_std_df <- features[mean_mask | std_mask, ]
    # ... finally retrieve only mean and std columns from x 
    # dataframe ... 
    x <- x[, mean_and_std_df$index]
    # ... and rename its column names.
    names(x) <- mean_and_std_df$name 

    # ---------------------
    # Get activity flag ---
    # ---------------------
    path <- gsub("-name-", group_name, "./data/-name-/y_-name-.txt")
    y <- read.table(path)
    names(y) <- c('short') 
    # get activity labels mapping ...
    activity_labels <- read.table('./data/activity_labels.txt')
    names(activity_labels) <- c('short', 'long')
    # ... merge them with activity flags data and get label column.
    activity_long <- merge(activity_labels, y)$long
    
    # -----------------------
    # Get subject mapping ---
    # -----------------------
    path <- gsub("-name-", group_name, "./data/-name-/subject_-name-.txt")
    subject_df <- read.table(path) 
    names(subject_df) <- c('subjectid')
    
    # ---------------------------
    # Create final data frame ---
    # ---------------------------
    # bind all data together
    final_df <- cbind(subject_df, activity_long, x)
    final_df$groupname <- group_name 
    # return final df
    final_df
}


# -----------------------------------------------------------
# Build table for train and test data and bind them together
# -----------------------------------------------------------
run <- function() {
    train_df <- create_group_df('train')
    test_df <- create_group_df('test')
    
    final_df <- rbind(train_df, test_df)
    
    write.csv(file='./data/complete.csv', x=final_df)
    
    # generate simple dataframe with averages for each activity
    # and each subject
    library(plyr)
    
    group_columns = c("subjectid", "activity_long")
    # retrieve list of variable names
    final_names <- names(final_df)
    data_columns = final_names[3:68]
    # generate simple csv
    simple_df <- ddply(final_df, group_columns, function(x) colMeans(x[data_columns]))   
    write.csv(file='./data/simple.csv', x=simple_df)
} 

run()

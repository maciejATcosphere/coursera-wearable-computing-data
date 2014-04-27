
# ----------------------------------------------------------
# Fetch zipped data, build directory structure and clean up
# ----------------------------------------------------------
get_data <- function () {
    if(!file.exists("./data")){
        dir.create("./data")
    }
    file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(file_url, destfile="./data/data.zip", method="curl")
    # unzip data in the current directory 
    
    system("unzip -d ./data ./data/data.zip")
    system("mv ~/data/'UCI HAR Dataset'/* ~/data/")
    system("rm -r ~/data/'UCI HAR Dataset'")
    
    # and remove zip file
    system("rm ./data/data.zip")
}
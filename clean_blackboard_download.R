#######################
# Barbara Toizer
# Cleaning assignment file download from Blackboard
# October 2020
#######################

# Step 1: download a file of assignments from Blackboard
  # Full Grade Center > find the applicable column > click on arrow > Assignment File Download
  # Save zip file to directory where you want the assignment files to be
# Step 2: Run function code below so it is saved in your global environment
# Step 3: Run function clean_blackboard_download() 
  # Add argument "zipped_file" with file path of the zip file you downloaded
  # Add argument due date in "YYYY-MM-DD" format
# Step 4: Navigate to location of zip file to find output folder with renamed files and summary file
# Note: In summary file, there is a Late column with 1s indicating that the assignment may have been turned in late
  # However, it will only indicate if it was turned in after the due *date* ignoring time
  # This column should be used as a guide to point you to students to check the turn in date for


clean_blackboard_download <- function(zipped_file, due_date){

########## Set up

# Require these packages to run script
require(stringr)
require(tools)
  
# Change working directory to zip file location
cur_wd <- stringr::str_match(zipped_file, "(.*)/.*.zip")[,2]
setwd(cur_wd)

# Unzip zipped file
unzip(zipped_file, exdir = "./unzipped_folder")

# Change working directory to unzipped folder
setwd("./unzipped_folder")

# Save due date as date type object
due_date <- as.Date(due_date)

# Create dataframe to store summary information about each student's submission
summary_file <- data.frame(matrix(ncol=6))
names(summary_file) <- c("Last Name", "First Name", "Username", "num_files", "date_in", "late")

# Create new folder for output files
dir.create("../output")

########## Function to go through text file, extract info, save to summary file, 
# and move renamed version of file to output

process_files <- function(username){
  # Save name of info .txt file created by Blackboard
  txt_file_name <- files_by_username[[username]][length(files_by_username[[username]])]
  
  # Load contents of .txt file into R
  txt_file_vec <- read.delim(txt_file_name,
                             header = F,
                             colClasses = "character")
  
  # Save contents of .txt file into summary file
  name_line <- unlist(strsplit(txt_file_vec[1,], " "))
  first_name <- name_line[2]
  last_name <- ifelse(length(name_line) == 4, name_line[3], 
                      paste(name_line[3], name_line[4], sep = " "))
  username <- name_line[length(name_line)]
  username <- gsub("\\(", "", username)
  username <- gsub("\\)", "", username)
  date_in <- stringr::str_match(txt_file_vec[3,], "Date Submitted: (.*)")[,2]
  asdate_in <- as.Date(date_in, "%A, %B %d, %Y")
  late <- ifelse(asdate_in > due_date, 1, 0)
  num_files <- length(files_by_username[[username]]) - 1
  
  summary_file <- rbind(summary_file, c(last_name, first_name, username, num_files, date_in, late))
  
  # Rename file(s) and save to output folder
  if(length(files_by_username[[username]]) == 2){             # if only one assignment file
    old_filename <- files_by_username[[username]][1]
    new_filename <- paste0("../output/", last_name, ", ", first_name, ".", tools::file_ext(old_filename))
    file.copy(from = old_filename, to = new_filename)
  } else{ 
    for(i in 1:(length(files_by_username[[username]]) - 1)){    # if multiple assignment files, give each a number
      old_filename <- files_by_username[[username]][i]
      new_filename <- paste0("../output/", last_name, ", ", first_name, i, ".", tools::file_ext(old_filename))
      file.copy(from = old_filename, to = new_filename)
    }
  }
  return(summary_file)
}

########## Get some info about files before doing it

# Save names of files to vector
filenames <- list.files()

# Save all txt files names to a vector
txt_vec <- c()
for(i in 1:length(filenames)){
  if(i %in% grep(filenames, pattern = ".txt", fixed = T)){
    txt_vec <- c(txt_vec, filenames[i])
  }
}

# Extract usernames from text file namesand save into a new vector
username_vec <-  stringr::str_match(txt_vec, ".*_(.*)_attempt_")[,2]
username_vec <- unique(username_vec)

# Search for all files in filenames vector with username in them and save to list
files_by_username <- list()
for(i in 1:length(username_vec)){
  files_by_username[[username_vec[i]]] <- filenames[grepl(filenames, pattern = username_vec[i], fixed = T)]
}

# For each username, do process_files function
for(i in 1:length(username_vec)){
  summary_file <- process_files(i)
}


########## Save summary file
summary_file <- summary_file[-1,]
summary_file <- summary_file[order(summary_file$`Last Name`),]
write.csv(summary_file, "../output/*summary_file.csv")

}





# Blackboard download of assignment files cleanup using R

This is a function to process/clean assignment files which were uploaded by students and then downloaded into a zip file, using R. 

To use the function:

+ **Step 1**: download a file of assignments from Blackboard
  + Full Grade Center > find the applicable column > click on arrow > Assignment File Download
  + Save zip file to directory where you want the assignment files to be
+ **Step 2**: Open R and run the function code so it is saved in your global environment
+ **Step 3**: Run function clean_blackboard_download() 
  + Add argument "zipped_file" with file path of the zip file you downloaded
  + Add argument due date in "YYYY-MM-DD" format
+ **Step 4**: Navigate to location of zip file to find output folder with renamed files and summary file

*Note*: In summary file, there is a Late column with 1s indicating that the assignment may have been turned in late
  + However, it will only indicate if it was turned in after the due *date* ignoring time
  + This column should be used as a guide to point you to students to check the turn in date for

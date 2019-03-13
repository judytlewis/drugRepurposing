# Getting started (see Readme for more details)

1. Download the files drugbank.R and drugbankMarketing.R from this github repository
2. Set up an account on drugbank.ca and download the full drug detail xml database. It will be in a zipped format. Extract the "full database.xml" file to a directory on your computer. 
3. Make sure that your R working directory is set to the directory where you have stored your "full database.xml" file downloaded from drugbank.ca.

# Instructions for creating drugBankData spreadsheet
1. Source (run) the drugbank.R file (ensuring that the full database.xml file is in your working directory first)
2. While the code extracts details about each drug in the database, the drug names will scroll on the R console.
3. It will take up to 30 minutes to run this program depending on your processor speed. 
4. When the script is complete, you will have a new file in your working directory named "drugBankDatayyyy-mm-dd.csv" where yyyy-mm-dd is today's date

# Example code for creating a marketing details spreadsheet
1. Source the file drugbankMarketing.R
2. Make sure the full database.xml file is in your working directory
3. Create a file whose column drugName lists the drugs of interest. In this example, that file is called "ApprovedDrugsSheet.csv"
4. Choose a base name for your output file: example here is "approvedDrugsMarketing". Do not include an extension in the base file name. The output file name will be appended with the date and ".csv".

getMarketingDetails("ApprovedDrugsSheet.csv", "approvedDrugsMarketing") 


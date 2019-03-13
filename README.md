# drugRepurposing
## Description
R scripts to extract details from drugbank.ca detailed drug XML database

## Getting started
Visit the website drugbank.ca, create a user account, and select the Downloads tab at the top of the page. Click the "Download (XML)" button to download the full drugbank database to your computer. This file will be in a zipped format. Create a new directory on your computer and extract the database (which will be named "full database.xml") to that directory. Open R and set your working directory to the directory where you stored the "full database.xml" file. 

For drugbank.R, install the following R packages: XML and plyr 
For drugbankMarketing.R, install the following R packages: XML. plyr, tidyyverse, dplyr

## R Scripts

### drugbank.R
Source the file drugbank.R (with the working directory set to the directory containing the unzipped "full database.xml" file). As the script runs, the names of the drugs in the drugbank database will scroll by on the console as details about each drug are extracted from the database. Due to the large number of drugs included in the database, this process takes over 30 minutes. When the script is complete, it creates a new spreadsheet named "drugBankDatayyyy-mm-dd.csv" where yyyy-mm-dd is the current date. For each drug in the database, this spreadsheets lists the following details:
  * type (small molecule, biotech...)
  * status (approved, illicit, investigational,...)
  * number of enzymes
  * list of enzymes
  * number of transporters
  * list of transporters
  * number of targets
  * target 1 name
  * target 1 action
  * target 1 gene name
  * target 2 name
  * target 2 action
  * etc

### drugbankMarketing.R
This file contains a function, getMarketingDetails that requires two arguments: 
  * inputfile: the name of a csv file with a column named drugName that lists all the drugs for which you are interested in obtaining drug marketing details. The file can contain other columns, but the only required column in drugName. This file must be in the current working directory.
  * outputfile: the base name you would like to give the file this function generates (do not include an extension; the base file name will be appended with the current date and ".csv")
The output of the function is a csv spreadsheet with one row per drug listed in the input file. For each drug listed in the input file, the output file has the following details:
  * the date the drug was first marketed in the US, or Canada if no US marketing data
  * the country (US, or Canada only if no US marketing data)
  * the output file will also include any columns present in the original input file

## Software Versions
These R scripts were developed under version 3.4.2 of the R programming language and require the XML, plyr, tidyverse and dplyr packages.




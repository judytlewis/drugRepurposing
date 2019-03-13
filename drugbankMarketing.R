# drugbankMarketing.R
# Judy Lewis, Ph.D.
# Vanderbilt Institute for Clinical and Translational Research
# February 2018
# 
# Logic to extract relevant drug marketing details from drugbank.ca drug database
# for drug repurposing research

library(XML)
library(plyr)
library(tidyverse)
library(dplyr)

# getMarketingDetails: given a spreadsheet with a list of drugs of interest, creates
# an output file with marketing details for each drug.
# full database.xml must be in current working directory
#
# inputfile: a spreadsheet with a column called drugName listing all of the drugs of interest
# outputfile: (without extension) name to use for file with marketing details added
# Note: the output only includes Canada if no US marketing data
# 
getMarketingDetails <- function(inputfile, outputfile){
  print("File full database.xml must be in your working directory")
  xmlfile <- xmlParse("full database.xml")
  xmltop <- xmlRoot(xmlfile)
  
  drugList <- read_csv(inputfile)
  drugNamesOfInterest <- drugList$drugName
  columnNames <- c(
    "drugName",
    "MarketingStartDate",
    "Country"
  )
  
  numberOfColumns <- length(columnNames)
  numberOfDrugs <- xmlSize(xmltop)
  n <- numberOfDrugs
  numberOfRows <- length(drugNamesOfInterest)
  marketingDrugData <- data.frame(matrix(ncol = numberOfColumns, nrow = numberOfRows),
                         stringsAsFactors = FALSE)
  
  colnames(marketingDrugData) <- c(columnNames)
  rowIndex <- 0
  for (index in 1:numberOfDrugs){
    drug <- xmlToList(xmltop[[index]][["name"]])
    if (!(drug %in% drugNamesOfInterest)) next
    rowIndex <- rowIndex + 1
    numberOfProducts <- xmlSize(xmltop[[index]][["products"]])
    
    if (numberOfProducts == 0){
      marketingDrugData$drugName[[rowIndex]] <- drug
      marketingDrugData$MarketingStartDate[[rowIndex]] <- NA
      marketingDrugData$Country[[rowIndex]] <- ""
    }
    else {
      knownCount <- 0
      knownDate <- NULL
      knownCountries <- NULL
      
      #  print(paste0(drug, " has ",numberOfProducts, " products"))
      for (productNum in 1: numberOfProducts){
        productDetails <- xmlToList(xmltop[[index]][["products"]][[productNum]])
        #if (productDetails$country != "US") next
        knownCount <- knownCount + 1
        knownCountries <- c(knownCountries, productDetails$country)
        
        if (is.null(productDetails$`started-marketing-on`)){
          knownDate <- c(knownDate,NA)
        } else {
          knownDate <- c(knownDate,productDetails$`started-marketing-on`)
        }
        
      }
      print(drug)
      drugProducts <- data.frame(marketingDate = as.Date(knownDate), 
                                 country = knownCountries, 
                                 stringsAsFactors = FALSE)
      browser()
      checkThese <- drugProducts %>% filter(country == "US")
      if (nrow(checkThese)==0){
        checkThese <- drugProducts
      }
      firstMarketingData <- arrange(checkThese, marketingDate)
      
      marketingDrugData$drugName[[rowIndex]] <- drug
      marketingDrugData$MarketingStartDate[[rowIndex]] <- as.character(firstMarketingData$marketingDate[[1]])
      marketingDrugData$Country[[rowIndex]] <- firstMarketingData$country[[1]]
      
    }
  }
  
  # in case the original spreadsheet had other columns, combine all:
  marketingDrugData <- marketingDrugData %>% left_join(drugList, by = "drugName")
  
  filename <- paste0(outputfile, Sys.Date(),".csv")
  write_csv(marketingDrugData, filename)
}

# Example use of getMarketingDetails:
# ApprovedDrugsSheet contains a list of approved drugs of interest
# This list was determined by Drug Repurposing investigators
# The column heading of drug names is drugName


#getMarketingDetails("ApprovedDrugsSheet.csv", outputfile = "approvedDrugsMarketing")

# Investigators identified another list of drugs of interest, listed in the file
# targetpairs_MarketingStartSheet.csv
# The drug name column heading is drugName

#getMarketingDetails("targetpairs_MarketingStartSheet.csv", outputfile = "targetPairsMarketing")



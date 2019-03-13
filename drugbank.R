# drugbank.R
# Judy Lewis, Ph.D.
# Vanderbilt Institute for Clinical and Translational Research
# November 2017
# 
# Logic to extract desired drug details from drugbank.ca drug database
# for drug repurposing research.
#
# First visit drugbank.ca, create an account, select the Downloads tab
# and click "Download (XML)" to download the full XML file of drug information. 
# Unzip the file and make sure that the resulting file, "full database.xml",
# is in your working directory.


library(XML)
library(plyr)

# set up the spreadsheet with enough columns for the maximum possible number of drug targets
# as of Feb 2018, no drug has more than 25 targets
maxNumberOfTargets <- 25
targetRelatedColumnNames <- paste(c("target","action","geneName"),
                                  unlist(lapply(1:maxNumberOfTargets,function(x){rep(x,3)})), sep = "")

print("File full database.xml must be in your working directory")
xmlfile <- xmlParse("full database.xml")
xmltop <- xmlRoot(xmlfile)

columnNames <- c(
  "drugName",
  "type",
  "status",
  "numberOfEnzymes",
  "listOfEnzymes",
  "numberOfTransporters",
  "listOfTransporters",
  "numberOfTargets",
  "numberOfTargetsWithKnownAction",
  targetRelatedColumnNames
)

numberOfColumns <- length(columnNames)

numberOfDrugs <- xmlSize(xmltop)
n <- numberOfDrugs

drugData <- data.frame(matrix(ncol = numberOfColumns, nrow = n),
  stringsAsFactors = FALSE
)
colnames(drugData) <- c(columnNames)

for (index in 1:numberOfDrugs){
  drug <- xmlToList(xmltop[[index]][["name"]])
  print(drug)
  numberOfTargets <- xmlSize(xmltop[[index]][["targets"]])
  knownCount <- 0
  knownList <- NULL
  
  if (numberOfTargets > 0){
    
    for (targetNum in 1:numberOfTargets){
      targetDetails <- xmlToList(xmltop[[index]][["targets"]][[targetNum]])
      if (targetDetails$'known-action'=="yes"){

        knownCount <- knownCount + 1
        drugData[index,paste0("target",knownCount)] <- targetDetails$name
        
        actions <- targetDetails$actions
        if (is.null(actions)){
          actions <- "NA"
        }
        drugData[index,paste0("action",knownCount)] <- paste(actions, collapse = ",")
        
        geneName <- targetDetails$polypeptide$`gene-name`
        if (is.null(geneName)){
          geneName <- "NA"
        }
        drugData[index,paste0("geneName",knownCount)] <- geneName

        knownList <- c(knownList,paste0(targetDetails$name,"(action = ",
                                        paste(actions, collapse = ","),
                                        ", Gene Name = ",geneName,
                                        ")"))
      }
    }
  }
  numberOfTargetsWithKnownAction <- knownCount
  listOfTargets <- paste(knownList, collapse=",")
  
  numberOfGroups <- xmlSize(xmltop[[index]][["groups"]])
  groupDetails <- xmlToList(xmltop[[index]][["groups"]])
  status <- NULL
  for (groupNum in 1:numberOfGroups){
    status <- c(status, groupDetails[[groupNum]])
  }
  groupStatus <- paste(status, collapse = "/") 
  type <- unname(xmlToList(xmltop[[index]])$.attrs["type"])
  
  numberOfEnzymes <- xmlSize(xmltop[[index]][["enzymes"]])
  knownCount <- 0
  knownList <- NULL
  
  if (numberOfEnzymes > 0){
    for (enzymeNum in 1:numberOfEnzymes){
      enzymeDetails <- xmlToList(xmltop[[index]][["enzymes"]][[enzymeNum]])
      knownCount <- knownCount + 1
      knownList <- c(knownList,enzymeDetails$name)
    }
  }
  listOfEnzymes <- paste(knownList, collapse=",")
  
  numberOfTransporters <- xmlSize(xmltop[[index]][["transporters"]])
  knownCount <- 0
  knownList <- NULL
  
  if (numberOfTransporters > 0){
    for (transporterNum in 1:numberOfTransporters){
      transporterDetails <- xmlToList(xmltop[[index]][["transporters"]][[transporterNum]])
      knownCount <- knownCount + 1
      knownList <- c(knownList,transporterDetails$name)
    }
  }
  listOfTransporters <- paste(knownList, collapse=",")
  
  drugData$drugName[[index]] <- drug
  drugData$type[[index]] <- type
  drugData$status[[index]] <- groupStatus
  drugData$numberOfEnzymes[[index]] <- numberOfEnzymes
  drugData$listOfEnzymes[[index]] <- listOfEnzymes
  drugData$numberOfTransporters[[index]] <- numberOfTransporters
  drugData$listOfTransporters[[index]] <-  listOfTransporters
  drugData$numberOfTargets[[index]] <- numberOfTargets
  drugData$numberOfTargetsWithKnownAction[[index]] <- numberOfTargetsWithKnownAction

  }
filename <- paste0("drugBankData",Sys.Date(),".csv")
write.csv(drugData, filename)




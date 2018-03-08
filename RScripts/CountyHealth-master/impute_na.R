## read data
healthData <- read.csv('clean_data_lung_new.csv', header = TRUE)
countyData <- read.csv('counties.csv', na.strings = c('-1111.1'), header = TRUE)

## discretie the Cancer Incidence
library(dplyr)
healthData['Cancer_Incidence'] <- as.factor(ntile(healthData['Cancer_Incidence'], 5))
countyData['Cancer_Incidence'] <- as.factor(ntile(countyData['Cancer_Incidence'], 5))

## add missing values into healthData from countyData
for (row in 1:nrow(healthData)) {
    if (is.na(healthData[row,'Cancer_Incidence'])) {
        fips <- as.integer(healthData[row,'FIPS'])
        otherRow = countyData[countyData$FIPS == fips,]
        ## if this is non-empty and Cancer_Incidence is not NA
        if (nrow(otherRow) == 1 && ! is.na(otherRow$Cancer_Incidence)) {
            healthData[row,'Cancer_Incidence'] = otherRow$Cancer_Incidence
        }
    }
}

## save the cancer incidence column
cancerCol = healthData[,'Cancer_Incidence']
## first remove columns with 60 or over NAs rows
bestColData <- healthData[,colSums(is.na(healthData)) < 60]
## now remove rows with 6 or over NAs
rowsToKeep <- rowSums(is.na(bestColData)) < 6
bestData <- bestColData[rowsToKeep,]
cancerCol <- cancerCol[rowsToKeep]

## bin all except FIPS and Cancer_Incidence
nbins <- 8
for (col in names(bestData)) {
    ## skip Cancer_Incidence and FIPS
    if (col == 'Cancer_Incidence' || col == 'FIPS' ) { next }
    bestData[col] <- as.factor(ntile(bestData[col], nbins))
}

## data without NA and without FIPS
completeData <- na.omit(bestData[,!names(bestData) %in% c('FIPS')])

library(bnlearn)
## for every row
for (row in 1:nrow(bestData)) {
    ## remove FIPS
    thisRow <- bestData[row,!names(bestData) %in% c('FIPS')]
    ## skip comlete rows
    if (all(!is.na(thisRow))) { next }
    ## namas of bad columns
    badCols <- names(which(sapply(thisRow,is.na)))
    ## names of the good columns
    goodCols <- setdiff(names(completeData),badCols)
    ## iterate over the bad columns
    for (col in badCols) {
        fitCols = append(goodCols, col)
        ## make a TAN for this col using only the good columns
        tan <- tree.bayes(completeData[,fitCols], col, goodCols)
        fitted <- bn.fit(tan, completeData[,fitCols], method = 'bayes')
        ## predict the variable
        bestData[row,col] <- predict(fitted,thisRow[goodCols])
    }
}

## add the Cancer_Incidence back into the bestData data frame
bestData[,'Cancer_Incidence'] = cancerCol
## write bestData to a csv
write.csv(bestData, 'imputed_data.csv', row.names = FALSE)

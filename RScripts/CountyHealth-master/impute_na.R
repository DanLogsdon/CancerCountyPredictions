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

## save the cance incidence column
cancerCol = healthData[,'Cancer_Incidence']

## first remove columns with 60 or over NAs rows
bestColData <- healthData[,colSums(is.na(healthData)) < 60]
## now remove rows with 6 or over NAs
bestData <- bestColData[rowSums(is.na(bestColData)) < 6,]

## bin all except FIPS and Cancer_Incidence
nbins <- 8
for (col in names(bestData)) {
    ## skip Cancer_Incidence and FIPS
    if (col == 'Cancer_Incidence' || col == 'FIPS' ) { next }
    bestData[col] <- as.factor(ntile(bestData[col], nbins))
}

## copy data
imputedData <- bestData

## data without NA and without FIPS
completeData <- na.omit(bestData[,!names(bestData) %in% c('FIPS')])

library(bnlearn)
## for every row
for (row in 1:nrow(bestData)) {
    ## indices of the good columns in this row
    goodCols = which(!is.na(bestData[row,]))
    ## iterate over the bad columns
    for (col in which(is.na(bestData[row,]))) {
        ## make a TAN for this col using only the good columns
        tan <- tree.bayes(completeData[,goodCols], col)
        fitted <- bn.fit(tan,completeData[,goodCols], method = 'bayes')
        ## predict the variable
        pred = predict(fitted,na.omit(bestData[row,]))
        ## set the cell to the predicted
        bestData[row,col] = pred
    }
}

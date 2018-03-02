library(dplyr)
healthData <- read.csv('clean_data.csv',
                       na.strings = c('-2222', '-1111.1'),
                       header = TRUE)

## scale Uninsured, Unemployed, Major_Depression, Recent_Drug_Use,
## *_Rpt, Toxic_Chem by population size
for (i in c('Uninsured', 'Unemployed', 'Major_Depression',
            'Recent_Drug_Use', 'Ecol_Rpt', 'Salm_Rpt', 'Shig_Rpt')) {
    healthData[[i]] <- healthData[[i]]/healthData['Population_Size']
}
    
## factorize the columns that are not indicators and bin using ntiles
## with nbins levels for continuously varying columns
nbins <- 7
for (i in c('Cancer_Incidence',
            'Population_Size',
            'Population_Density',
            'Poverty',
            'White',
            'Black',
            'Hispanic',
            'Native_American',
            'Asian',
            'No_Exercise',
            'Few_Fruit_Veg',
            'Obesity',
            'High_Blood_Pres',
            'Smoker',
            'Diabetes',
            'Uninsured',
            'Prim_Care_Phys_Rate',
            'Dentist_Rate',
            'Unemployed',
            'Major_Depression',
            'Recent_Drug_Use',
            'Ecol_Rpt',
            'Salm_Rpt',
            'Shig_Rpt',
            'Toxic_Chem')) {
    healthData[[i]] <- as.factor(ntile(healthData[[i]], nbins))
}

## convert indicators to factors
for (i in c('Sulfur_Dioxide_Ind',
            'Ozone_Ind',
            'Particulate_Matter_Ind',
            'Lead_Ind')) {
    healthData[[i]] <- as.factor(healthData[[i]])
}
## drop useless columns
data <- healthData[,!(names(healthData) %in% c('FIPS', 'Sulfur_Dioxide_Ind'))]

## bnlearn
library(bnlearn)
## bn = hc(na.omit(data))
cleanData = na.omit(data)
## naive Bayes
## nb <- naive.bayes(cleanData, 'Cancer_Incidence')
## pred <- predict(nb, cleanData)
## tab <- table(pred,cleanData[,'Cancer_Incidence'])

## tree augmented naive Bayes
tan <- tree.bayes(cleanData, 'Cancer_Incidence')
fitted <- bn.fit(tan, cleanData, method = "bayes")
pred = predict(fitted, cleanData)
tab <- table(pred, cleanData[, 'Cancer_Incidence'])

sum <- 0
num <- 0
for (i in 1:5) {
    for (j in 1:5) {
        sum <- sum + abs(i-j)*tab[i,j]
        num <- num + tab[i,j]
    }
}
err <- sum/num/nbins


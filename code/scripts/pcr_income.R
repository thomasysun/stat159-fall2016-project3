##regression models
library("glmnet")
library('pls')
#load mse function
source("../functions/function_mse.R")
#pre-modeling data processing
clean_2012 = readRDS("data/clean_2012.rds")
clean_2012_public = readRDS("data/clean_2012_public.rds")

#delete na values
clean_2012 = na.omit(clean_2012[,-14])

#scale data
clean_2012 = scale(as.matrix(clean_2012[,c(3:21)]), center = TRUE, scale = TRUE)

#split into train and test
set.seed(5)
train_set = sample(c(1:1740), size = 1220)
predictors = clean_2012[,c(1:11,16:19)]
response = clean_2012[,c(12)]
test=(-train_set)
response_test=response[test]


## Principal Components Regression
pcr_fit_i = pcr(response~predictors, subset = train_set, scale = FALSE, validation ="CV")
pcr_bestpara_i = which(pcr_fit_i$validation$PRESS == min(pcr_fit_i$validation$PRESS))
validationplot(pcr_fit_i, val.type="MSEP")
# choose best model
set.seed(5)
pcr_pred = predict(pcr_fit_i, predictors[-train_set,],ncomp=pcr_bestpara_i)
pcr_test_MSE_i = mse(pcr_pred, response_test)
# PCR on full dataset
pcr = pcr(response~predictors, scale = FALSE, ncomp=pcr_bestpara_i)
pcr_coef_i = coef(pcr)

save(pcr_fit_i,
     pcr_bestpara_i,
     pcr_test_MSE_i,
     pcr_coef_i,
     file = "./data/pcr_results_income.Rdata")
sink(file ="./data/pcr_results_income.txt")
cat("PCR Model")
cat("\n")
pcr_fit_i
cat("\n")
cat("Best Parameter")
cat("\n")
pcr_bestpara_i
cat("\n")
cat("PCR Test MSE")
cat("\n")
pcr_test_MSE_i
cat("\n")
cat("PCR Official Coefficients for Income")
cat("\n")
pcr_coef_i
sink()
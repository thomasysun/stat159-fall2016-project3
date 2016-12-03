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


## Partial Least Squares Regression
pls_fit = plsr(response~as.matrix(predictors), subset = train_set, scale = FALSE, validation ="CV")
summary(pls_fit)
best_para = which(pls_fit$validation$PRESS == min(pls_fit$validation$PRESS))
validationplot(pls_fit, val.type="MSEP")
# choose best model
pls_pred = predict(pls_fit,as.matrix(predictors[-train_set,]),ncomp=9)
pls_test_MSE = mse(pls_pred, response_test)
# PLS on full dataset
pls = plsr(response~as.matrix(predictors), scale = FALSE, ncomp=9)
summary(pls)
pls_official_coefficients = as.numeric(pls$coefficients[,,9])
save(pls_fit,
     best_para,
     pls_test_MSE,
     file = "./data/pls_results_income.Rdata")
sink(file ="./data/pls_results_income.txt")
cat("PLS Model")
cat("\n")
pls_fit
cat("\n")
cat("Best Parameter")
cat("\n")
best_para
cat("\n")
cat("PLS Test MSE")
cat("\n")
pls_test_MSE
sink()


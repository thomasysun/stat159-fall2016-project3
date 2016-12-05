##regression models
library("glmnet")
library('pls')
#load mse function
source("code/functions/function_mse.R")
#pre-modeling data processing
clean_2012 = readRDS("data/clean_2012.rds")
clean_2012_public = readRDS("data/clean_2012_public.rds")

#delete na values
clean_2012 = na.omit(clean_2012)

#scale data
clean_2012 = scale(as.matrix(clean_2012[,c(3:17)]), center = TRUE, scale = TRUE)

#split into train and test
set.seed(5)
train_set = sample(c(1:1334), size = 1000)
predictors = clean_2012[,c(1:7,9:15)]
response = clean_2012[,c(8)]
test=(-train_set)
response_test=response[test]


## Partial Least Squares Regression
pls_fit_c = plsr(response~predictors, subset = train_set, scale = FALSE, validation ="CV")
pls_bestpara_c = which(pls_fit_c$validation$PRESS == min(pls_fit_c$validation$PRESS))
validationplot(pls_fit_c, val.type="MSEP")
# choose best model
set.seed(5)
pls_pred = predict(pls_fit_c,predictors[-train_set,],ncomp=pls_bestpara_c)
pls_test_MSE_c = mse(pls_pred, response_test)
# PLS on full dataset
pls = plsr(response~predictors, scale = FALSE, ncomp=pls_bestpara_c)
pls_coef_c = coef(pls)

save(pls_fit_c,
     pls_bestpara_c,
     pls_test_MSE_c,
     pls_coef_c,
     file = "./data/pls_results_completion.Rdata")
sink(file ="./data/pls_results_completion.txt")
cat("PLS Model")
cat("\n")
pls_fit_c
cat("\n")
cat("Best Parameter")
cat("\n")
pls_bestpara_c
cat("\n")
cat("PLS Test MSE")
cat("\n")
pls_test_MSE_c
cat("\n")
cat("PLS Official Coefficients for Completion Rates")
cat("\n")
pls_coef_c
sink()


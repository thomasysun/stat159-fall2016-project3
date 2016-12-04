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


##OLS
ols_income = lm(response~as.matrix(predictors))
ols_income_summary = summary(ols_income)
ols_income_coeffs = as.numeric(ols_income$coefficients)[-1]

# Save results in binary file
save(ols_income, ols_income_summary, ols_income_coeffs,
     file = "data/ols_results_income.RData")

# Save results to a text file
sink("data/ols_results_income.txt")
cat("Threshold income results of multiple linear regression model via Ordinary Least Square", "\n")
ols_income_summary
sink()

##Ridge regression
grid = 10^seq(10, -2, length = 100)
ridge_train_i = cv.glmnet(as.matrix(predictors[train_set, ]), response[train_set], intercept = FALSE, 
                          standardize = FALSE, lambda = grid, alpha = 0)
plot(ridge_train_i)
#lambda min
ridge_bestlam_i = ridge_train_i$lambda.min

# choose best model
ridge_pred = predict(ridge_train_i,s=ridge_bestlam_i,newx=as.matrix(predictors[-train_set,]))
ridge_test_MSE_i = mse(ridge_pred, response_test)

#ridge on full dataset
ridge = glmnet(predictors,response, intercept = FALSE, 
               standardize = FALSE, lambda = grid, alpha = 0)
ridge_coef_i = predict(ridge,type="coefficients",s=bestlam_1)

save(ridge_train_i,
     ridge_bestlam_1_i,
     ridge_test_MSE_i,
     ridge_coef_i,
     file = "./data/ridge_results_income.Rdata")
sink(file ="./data/ridge_results_income.txt")
cat("Ridge Model")
cat("\n")
ridge_train
cat("\n")
cat("Best Lambda")
cat("\n")
bestlam_1
cat("\n")
cat("Ridge Test MSE")
cat("\n")
ridge_test_MSE
cat("\n")
cat("Ridge Official Coefficients for Income")
cat("\n")
ridge_coef_i
sink()


## Lasso Regression
grid = 10^seq(10, -2, length = 100)
lasso_train_i = cv.glmnet(as.matrix(predictors[train_set,]), response[train_set], intercept = FALSE, 
                          lambda = grid, standardize = FALSE)

plot(lasso_train_i)
lasso_bestlam_i = lasso_train_i$lambda.min
# choose best model
lasso_pred = predict(lasso_train_i,s=lasso_bestlam_i ,newx=as.matrix(predictors[-train_set,]))
lasso_test_MSE_i = mse(lasso_pred, response_test)
# lasso on full dataset
lasso = glmnet(predictors,response,lambda=grid, intercept = FALSE)
lasso_coef_i = predict(lasso,type="coefficients",s=lasso_bestlam_i)

save(lasso_train_i,
     lasso_bestlam_i,
     lasso_test_MSE_i,
     lasso_coef_i,
     file = "./data/lasso_results_income.Rdata")
sink(file ="./data/lasso_results_income.txt")
cat("Lasso Model")
cat("\n")
lasso_train_i
cat("\n")
cat("Best Lambda")
cat("\n")
lasso_bestlam_i
cat("\n")
cat("Lasso Test MSE")
cat("\n")
lasso_test_MSE_i
cat("\n")
cat("Lasso Official Coefficients for Income")
cat("\n")
lasso_coef_i
sink()


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

## Partial Least Squares Regression
pls_fit_i = plsr(response~predictors, subset = train_set, scale = FALSE, validation ="CV")
pls_bestpara_i = which(pls_fit_i$validation$PRESS == min(pls_fit_i$validation$PRESS))
validationplot(pls_fit_i, val.type="MSEP")
# choose best model
set.seed(5)
pls_pred = predict(pls_fit_i,predictors[-train_set,],ncomp=pls_bestpara_i)
pls_test_MSE_i = mse(pls_pred, response_test)
# PLS on full dataset
pls = plsr(response~predictors, scale = FALSE, ncomp=pls_bestpara_i)
pls_coef_i = coef(pls)

save(pls_fit_i,
     pls_bestpara_i,
     pls_test_MSE_i,
     pls_coef_i,
     file = "./data/pls_results_income.Rdata")
sink(file ="./data/pls_results_income.txt")
cat("PLS Model")
cat("\n")
pls_fit_i
cat("\n")
cat("Best Parameter")
cat("\n")
pls_bestpara_i
cat("\n")
cat("PLS Test MSE")
cat("\n")
pls_test_MSE_i
cat("\n")
cat("PLS Official Coefficients for Income")
cat("\n")
pls_coef_i
sink()



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
predictors = clean_2012[,c(1:10,12,16:19)]
response = clean_2012[,c(11)]
test=(-train_set)
response_test=response[test]


##OLS
ols_completion = lm(response~as.matrix(predictors))
ols_completion_summary = summary(ols_completion)
ols_completion_coeffs = as.numeric(ols_completion$coefficients)[-1]

# Save results in binary file
save(ols_completion, ols_completion_summary, ols_completion_coeffs,
     file = "data/ols_results_completion.RData")

# Save results to a text file
sink("data/ols_results_completion.txt")
cat("4-year completion results of multiple linear regression model via Ordinary Least Square", "\n")
ols_completion_summary
sink()


##Ridge regression
grid = 10^seq(10, -2, length = 100)
ridge_train_c = cv.glmnet(as.matrix(predictors[train_set, ]), response[train_set], intercept = FALSE, 
                          standardize = FALSE, lambda = grid, alpha = 0)
plot(ridge_train_c)
#lambda min
ridge_bestlam_c = ridge_train$lambda.min

# choose best model
ridge_pred = predict(ridge_train_c,s=ridge_bestlam_c,newx=as.matrix(predictors[-train_set,]))
ridge_test_MSE_c = mse(ridge_pred, response_test)

#ridge on full dataset
ridge = glmnet(predictors,response, intercept = FALSE, 
               standardize = FALSE, lambda = grid, alpha = 0)
ridge_coef_c = predict(ridge,type="coefficients",s=ridge_bestlam_c)

save(ridge_train_c,
     ridge_bestlam_c,
     ridge_test_MSE_c,
     ridge_coef_c,
     file = "./data/ridge_results_completion.Rdata")
sink(file ="./data/ridge_results_completion.txt")
cat("Ridge Model")
cat("\n")
ridge_train_c
cat("\n")
cat("Best Lambda")
cat("\n")
ridge_bestlam_c
cat("\n")
cat("Ridge Test MSE")
cat("\n")
ridge_test_MSE_c
cat("\n")
cat("Ridge Official Coefficients for Completion Rates")
cat("\n")
ridge_coef_c
sink()

## Lasso Regression
grid = 10^seq(10, -2, length = 100)
lasso_train_c = cv.glmnet(as.matrix(predictors[train_set,]), response[train_set], intercept = FALSE, 
                          lambda = grid, standardize = FALSE)

plot(lasso_train_c)
lasso_bestlam_c = lasso_train_c$lambda.min
# choose best model
lasso_pred = predict(lasso_train_c,s=lasso_bestlam_c ,newx=as.matrix(predictors[-train_set,]))
lasso_test_MSE_c = mse(lasso_pred,response_test)
# lasso on full dataset
lasso = glmnet(predictors,response,lambda=grid, intercept = FALSE)
lasso_coef_c = predict(lasso,type="coefficients",s=lasso_bestlam_c)
save(lasso_train_c,
     lasso_bestlam_c,
     lasso_test_MSE_c,
     lasso_coef_c,
     file = "./data/lasso_results_completion.Rdata")
sink(file ="./data/lasso_results_completion.txt")
cat("Lasso Model")
cat("\n")
lasso_train_c
cat("\n")
cat("Best Lambda")
cat("\n")
lasso_bestlam_c
cat("\n")
cat("Lasso Test MSE")
cat("\n")
lasso_test_MSE_c
cat("\n")
cat("Lasso Official Coefficients for Completion Rates")
cat("\n")
lasso_coef_c
sink()

## Principal Components Regression
pcr_fit_c = pcr(response~predictors, subset = train_set, scale = FALSE, validation ="CV")
pcr_bestpara_c = which(pcr_fit_c$validation$PRESS == min(pcr_fit_c$validation$PRESS))
validationplot(pcr_fit_c, val.type="MSEP")
# choose best model
set.seed(5)
pcr_pred = predict(pcr_fit_c, predictors[-train_set,],ncomp=pcr_bestpara_c)
pcr_test_MSE_c = mse(pcr_pred, response_test)
# PCR on full dataset
pcr = pcr(response~predictors, scale = FALSE, ncomp=pcr_bestpara_c)
pcr_coef_c = coef(pcr)

save(pcr_fit_c,
     pcr_bestpara_c,
     pcr_test_MSE_c,
     pcr_coef_c,
     file = "./data/pcr_results_completion.Rdata")
sink(file ="./data/pcr_results_completion.txt")
cat("PCR Model")
cat("\n")
pcr_fit_c
cat("\n")
cat("Best Parameter")
cat("\n")
pcr_bestpara_c
cat("\n")
cat("PCR Test MSE")
cat("\n")
pcr_test_MSE_c
cat("\n")
cat("PCR Official Coefficients for Completion Rates")
cat("\n")
pcr_coef_c
sink()


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

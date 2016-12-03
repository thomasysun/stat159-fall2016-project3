##regression models
library("glmnet")
library('pls')
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
ols = lm(response~as.matrix(predictors))
ols_coeffs = as.numeric(ols$coefficients)[-1]

##Ridge regression
grid = 10^seq(10, -2, length = 100)
ridge_train = cv.glmnet(as.matrix(predictors[train_set, ]), response[train_set], intercept = FALSE, 
                        standardize = FALSE, lambda = grid, alpha = 0)
plot(ridge_train)
#lambda min
bestlam_1 = ridge_train$lambda.min

# choose best model
ridge_pred = predict(ridge_train,s=bestlam_1,newx=as.matrix(predictors[-train_set,]))
ridge_test_MSE = mean((ridge_pred-response_test)^2)

#ridge on full dataset
ridge = glmnet(as.matrix(predictors),response, intercept = FALSE, 
               standardize = FALSE, lambda = grid, alpha = 0)
ridge_coef = predict(ridge,type="coefficients",s=bestlam_1)
ridge_official_coef = as.numeric(ridge_coef)[-1]

save(ridge_train,
     bestlam_1,
     ridge_test_MSE,
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
sink()

## Lasso Regression
grid = 10^seq(10, -2, length = 100)
lasso_train = cv.glmnet(as.matrix(predictors[train_set,]), response[train_set], intercept = FALSE, 
                        lambda = grid, standardize = FALSE)

plot(lasso_train)
bestlam_2 = lasso_train$lambda.min
# choose best model
lasso_pred = predict(lasso_train,s=bestlam_2 ,newx=as.matrix(predictors[-train_set,]))
lasso_test_MSE = mean((lasso_pred-response_test)^2)
# lasso on full dataset
lasso = glmnet(as.matrix(predictors),response,lambda=grid, intercept = FALSE)
lasso_coef = predict(lasso,type="coefficients",s=bestlam_2)
lasso_coef[lasso_coef!=0]
lasso_official_coef = as.numeric(lasso_coef)[-1]
save(lasso_train,
     bestlam_2,
     lasso_test_MSE,
     file = "./data/lasso_results_income.Rdata")
sink(file ="./data/lasso_results_income.txt")
cat("Lasso Model")
cat("\n")
lasso_train
cat("\n")
cat("Best Lambda")
cat("\n")
bestlam_2
cat("\n")
cat("Lasso Test MSE")
cat("\n")
lasso_test_MSE
sink()

## Principal Components Regression
library(pls)
pcr_fit = pcr(response~as.matrix(predictors), subset = train_set, scale = FALSE, validation ="CV")
summary(pcr_fit)
best_para_1 = which(pcr_fit$validation$PRESS == min(pcr_fit$validation$PRESS))
validationplot(pcr_fit, val.type="MSEP")
# choose best model
pcr_pred = predict(pcr_fit, as.matrix(predictors[-train_set,]),ncomp=14)
pcr_test_MSE = mean((pcr_pred-response_test)^2)
# PCR on full dataset
pcr = pcr(response~as.matrix(predictors), scale = FALSE, ncomp=14)
summary(pcr)
pcr_official_coefficients = as.numeric(pcr$coefficients[,,14])
save(pcr_fit,
     best_para_1,
     pcr_test_MSE,
     file = "./data/pcr_results_income.Rdata")
sink(file ="./data/pcr_results_income.txt")
cat("PCR Model")
cat("\n")
pcr_fit
cat("\n")
cat("Best Parameter")
cat("\n")
best_para_1
cat("\n")
cat("PCR Test MSE")
cat("\n")
pcr_test_MSE
sink()

## Partial Least Squares Regression
library(pls)
pls_fit = plsr(response~as.matrix(predictors), subset = train_set, scale = FALSE, validation ="CV")
summary(pls_fit)
best_para = which(pls_fit$validation$PRESS == min(pls_fit$validation$PRESS))
validationplot(pls_fit, val.type="MSEP")
# choose best model
pls_pred = predict(pls_fit,as.matrix(predictors[-train_set,]),ncomp=9)
pls_test_MSE = mean((pls_pred-response_test)^2)
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


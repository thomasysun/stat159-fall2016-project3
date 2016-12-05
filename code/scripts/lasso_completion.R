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

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
predictors = clean_2012[,c(1:8,10:15)]
response = clean_2012[,c(9)]
test=(-train_set)
response_test=response[test]


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

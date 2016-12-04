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
     ridge_bestlam_i,
     ridge_test_MSE_i,
     ridge_coef_i,
     file = "./data/ridge_results_income.Rdata")
sink(file ="./data/ridge_results_income.txt")
cat("Ridge Model")
cat("\n")
ridge_train_i
cat("\n")
cat("Best Lambda")
cat("\n")
ridge_bestlam_i
cat("\n")
cat("Ridge Test MSE")
cat("\n")
ridge_test_MSE_i
cat("\n")
cat("Ridge Official Coefficients for Income")
cat("\n")
ridge_coef_i
sink()

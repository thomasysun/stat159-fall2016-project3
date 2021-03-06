##regression models
library("glmnet")
library('pls')
#load mse function
source("../../code/functions/function_mse.R")
#pre-modeling data processing
clean_2012 = readRDS("../../data/clean_2012.rds")


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


##Ridge regression
grid = 10^seq(10, -2, length = 100)
ridge_train_c = cv.glmnet(as.matrix(predictors[train_set, ]), response[train_set], intercept = FALSE, 
                        standardize = FALSE, lambda = grid, alpha = 0)
plot(ridge_train_c)
#lambda min
ridge_bestlam_c = ridge_train_c$lambda.min

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
     file = "../../data/ridge_results_completion.Rdata")
sink(file ="../../data/ridge_results_completion.txt")
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

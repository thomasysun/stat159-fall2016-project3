##regression models
library("glmnet")
library('pls')
#pre-modeling data processing
clean_2012 = readRDS("data/clean_2012.rds")
clean_2012_public = readRDS("data/clean_2012_public.rds")

#delete na values
clean_2012 = na.omit(clean_2012[,-14])

#scale data
clean_2012 = scale(as.matrix(clean_2012[,c(3:23)]), center = TRUE, scale = TRUE)

#split into train and test
set.seed(5)
train_set = sample(c(1:1236), size = 866)
predictors = clean_2012[,c(1:13,15:21)]
response = clean_2012[,c(14)]
test=(-train_set)
response_test=response[test]


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

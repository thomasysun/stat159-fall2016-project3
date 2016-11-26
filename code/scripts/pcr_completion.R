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
predictors = clean_2012[,c(1:10,12:21)]
response = clean_2012[,c(11)]
test=(-train_set)
response_test=response[test]


## Principal Components Regression
library(pls)
pcr_fit = pcr(response~as.matrix(predictors), subset = train_set, scale = FALSE, validation ="CV")
summary(pcr_fit)
best_para_1 = which(pcr_fit$validation$PRESS == min(pcr_fit$validation$PRESS))
validationplot(pcr_fit, val.type="MSEP")
# choose best model
pcr_pred = predict(pcr_fit, as.matrix(predictors[-train_set,]),ncomp=18)
pcr_test_MSE = mean((pcr_pred-response_test)^2)
# PCR on full dataset
pcr = pcr(response~as.matrix(predictors), scale = FALSE, ncomp=18)
summary(pcr)
pcr_official_coefficients = as.numeric(pcr$coefficients[,,18])
save(pcr_fit,
     best_para_1,
     pcr_test_MSE,
     file = "./data/pcr_results.Rdata")
sink(file ="./data/pcr_results.txt")
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

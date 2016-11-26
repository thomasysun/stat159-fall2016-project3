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


##OLS
ols = lm(response~as.matrix(predictors))
ols_coeffs = as.numeric(ols$coefficients)[-1]

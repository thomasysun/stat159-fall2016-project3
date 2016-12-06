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
predictors = clean_2012[,c(1:8,10:15)]
response = clean_2012[,c(9)]
test=(-train_set)
response_test=response[test]

##OLS
ols_income = lm(response~predictors)
ols_income_summary = summary(ols_income)
ols_coef_i = coef(ols_income_summary)
rownames(ols_coef_i) = sub("^predictors", "", rownames(ols_coef_i))

# Save results in binary file
save(ols_income, ols_income_summary, ols_coef_i,
     file = "../../data/ols_results_income.RData")

# Save results to a text file
sink("../../data/ols_results_income.txt")
cat("Threshold income results of multiple linear regression model via Ordinary Least Square", "\n")
ols_income_summary
sink()



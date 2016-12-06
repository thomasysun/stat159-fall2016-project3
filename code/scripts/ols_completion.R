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


##OLS
ols_completion = lm(response~predictors)
ols_completion_summary = summary(ols_completion)
ols_coef_c = coef(ols_completion_summary)
rownames(ols_coef_c) = sub("^predictors", "", rownames(ols_coef_c))

# Save results in binary file
save(ols_completion, ols_completion_summary, ols_coef_c,
     file = "../../data/ols_results_completion.RData")

# Save results to a text file
sink("../../data/ols_results_completion.txt")
cat("4-year completion results of multiple linear regression model via Ordinary Least Square", "\n")
ols_completion_summary
sink()


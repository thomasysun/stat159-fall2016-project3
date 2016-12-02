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

##OLS
ols_income = lm(response~as.matrix(predictors))
ols_income_summary = summary(ols_income)
ols_income_coeffs = as.numeric(ols_income$coefficients)[-1]

# Save results in binary file
save(ols_income, ols_income_summary, ols_income_coeffs,
     file = "data/ols_results_income.RData")

# Save results to a text file
sink("data/ols_results_income.txt")
cat("Threshold income results of multiple linear regression model via Ordinary Least Square", "\n")
ols_income_summary
sink()



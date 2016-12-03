# Title: MSE function
# Description: Compute Mean Square Error
# Input: fitted values of a numeric vector or matrix 
# Input: testing values of a numeric vector or matrix
# Output: Mean sqaure error for the model 


mse <- function(fitted_values, test_value) {
  mse = mean((as.numeric(fitted_values) - as.numeric(test_value)) ^ 2)
  return(mse)
}
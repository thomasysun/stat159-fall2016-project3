library(devtools)
library(knitr)
library(rmarkdown)
library(xtable)
library(ggplot2)


sink("../../session-info.txt", append = TRUE)
cat("Session Information\n\n")
print(sessionInfo())
devtools::session_info()
sink()
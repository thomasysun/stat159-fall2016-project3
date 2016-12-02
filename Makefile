
# Variables
credit = data/Credit.csv
quant = eda-quantitative-script.R
qual = eda-qualitative-script.R
mse = code/functions/mse-function.R
clean_data = data/train-and-test-set.RData
ols = ols-regression-script.R
ridge = ridge-regression-script.R
lasso = lasso-regression-script.R
pcr = PCR-script.R
plsr = PLSR-script.R
sections = report/sections/*.Rmd

#declare phony targets
.PHONY: all data tests eda pre ols ridge lasso pcr plsr regressions report slides session clean

# ------------------------------------------------------------------------------------------
# default targets
# ------------------------------------------------------------------------------------------
all: eda regressions report


# ------------------------------------------------------------------------------------------
# download data
# ------------------------------------------------------------------------------------------
data:
	curl "http://www-bcf.usc.edu/~gareth/ISL/Credit.csv" > $(credit)


# ------------------------------------------------------------------------------------------
# unit tests
# ------------------------------------------------------------------------------------------
tests: code/test-that.R code/functions/mse-function.R
	cd code && Rscript test-that.R


# ------------------------------------------------------------------------------------------
# run eda-qualitative-script.R and eda-quantitative-script.R
# ------------------------------------------------------------------------------------------
eda: code/scripts/$(qual) code/scripts/$(quant) $(credit)
	cd code/scripts && Rscript $(qual)
	cd code/scripts && Rscript $(quant)


# ------------------------------------------------------------------------------------------
# pre-process data
# ------------------------------------------------------------------------------------------
pre: code/scripts/pre-process-script.R $(credit)
	cd code/scripts && Rscript pre-process-script.R


# ------------------------------------------------------------------------------------------
# run OLS regression
# ------------------------------------------------------------------------------------------
ols: code/scripts/$(ols) $(clean_data) $(mse)
	cd code/scripts && Rscript $(ols)


# ------------------------------------------------------------------------------------------
# run ridge regression
# ------------------------------------------------------------------------------------------
ridge: code/scripts/$(ridge) $(clean_data) $(mse) 
	cd code/scripts && Rscript $(ridge)


# ------------------------------------------------------------------------------------------
# run lasso regression
# ------------------------------------------------------------------------------------------
lasso: code/scripts/$(lasso) $(clean_data) $(mse)
	cd code/scripts && Rscript $(lasso)	


# ------------------------------------------------------------------------------------------
# run PCR regression
# ------------------------------------------------------------------------------------------
pcr: code/scripts/$(pcr) $(clean_data) $(mse)
	cd code/scripts && Rscript $(pcr)


# ------------------------------------------------------------------------------------------
# run PLSR regression
# ------------------------------------------------------------------------------------------
plsr: code/scripts/$(plsr) $(clean_data) $(mse)
	cd code/scripts && Rscript $(plsr)


# ------------------------------------------------------------------------------------------
# run all five types of regressions
# ------------------------------------------------------------------------------------------
regressions:
	make ols
	make ridge
	make lasso
	make pcr
	make plsr


# ------------------------------------------------------------------------------------------
# generate Rmd and PDF report
# ------------------------------------------------------------------------------------------
report: $(sections) $(clean_data) $(mse)
	cat $(sections) > report/report.Rmd
	cd report && Rscript -e 'library(rmarkdown); render("report.Rmd","pdf_document")'


# ------------------------------------------------------------------------------------------
# Rmd to HTML slides
# ------------------------------------------------------------------------------------------
slides: $(clean_data) $(mse)
	cd slides && Rscript -e 'library(rmarkdown); render("predictive-modeling-slides.Rmd")'


# ------------------------------------------------------------------------------------------
# generate session-info.txt
# ------------------------------------------------------------------------------------------
session: 
	bash session.sh

	
# ------------------------------------------------------------------------------------------
# clean the target
# ------------------------------------------------------------------------------------------
clean:
	rm -f report/report.pdf 

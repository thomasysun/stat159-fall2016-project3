
# Variables
clean_data = data/clean_2012.rds
eda = exploratory_data_analysis.R
mse = code/functions/function_mse.R
completion = regression_completion.R
income = regression_income.R
sections = report/sections/*.Rnw

#declare phony targets
.PHONY: all tests eda completion income regressions report slides shinyapp session clean

# ------------------------------------------------------------------------------------------
# default targets
# ------------------------------------------------------------------------------------------
all: eda regressions report


# ------------------------------------------------------------------------------------------
# unit tests
# ------------------------------------------------------------------------------------------
tests: code/test_that.R code/functions/function_mse.R
	cd code && Rscript test_that.R


# ------------------------------------------------------------------------------------------
# run eda
# ------------------------------------------------------------------------------------------
eda: code/scripts/$(eda) $(clean_data)
	cd code/scripts && Rscript $(eda)


# ------------------------------------------------------------------------------------------
# run completion rate regression
# ------------------------------------------------------------------------------------------
ols: code/scripts/$(completion) $(clean_data) $(mse)
	cd code/scripts && Rscript $(completion)

	
# ------------------------------------------------------------------------------------------
# run income regression
# ------------------------------------------------------------------------------------------
ridge: code/scripts/$(income) $(clean_data) $(mse)
	cd code/scripts && Rscript $(income)

	
# ------------------------------------------------------------------------------------------
# run both regressions
# ------------------------------------------------------------------------------------------
regressions:
	make completion
	make income


# ------------------------------------------------------------------------------------------
# generate Rmw and PDF report
# ------------------------------------------------------------------------------------------
report: $(sections) $(clean_data) $(mse)
	cd report && R CMD Sweave report.Rnw
	cd report && Rscript -e "library(knitr); knit2pdf('report.tex')"


# ------------------------------------------------------------------------------------------
# Rmd to HTML slides
# ------------------------------------------------------------------------------------------
slides: $(clean_data) $(mse)
	cd slides && Rscript -e 'library(rmarkdown); render("slides.Rmd")'
	
# ------------------------------------------------------------------------------------------
# Deploy shinyapp
# ------------------------------------------------------------------------------------------
shinyapp: $(clean_data)
	Rscript -e "shiny::runApp('shinyapp')"


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

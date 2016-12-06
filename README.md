# Statistics 159 Project 3

## Overview
In this project, we assess the performance of publicly funded schools to determine the allocation of grant money for policymakers. Specifically, we attempt to identify the best schools in the US in terms of their demographic, academic, and socioeconomic characteristics in order to help increase equity and graduation rates for underserved populations. Additionally, we use predictive modeling techniques to find the determinants for graduation rates and post-graduation income. Models including ridge regression, lasso regression, principal components regression, and partial least squares regression are applied to data on US universities from College Scorecard provided by the US department of education. The best fitting model is then used to make accurate predictons on graduation and income. We find that coming from a low-income bracket family, having federal loans, and being a first-generation student has a strong negative relationship with income. On the other hand, cost of attendance and SAT scores heavily influence completion rates positively. Based on these factors, seven of the most urgent schools are selected for allocation of grant money. 


## Project Structure

The main directories of this repository are:
* `data`, which stores the clean College Scorecard data set `clean_2012.rds`, and the RData and text outputs from our analysis
* `code`, which contains code from R for analysis/computations and contains three directories: 
   * functions, which contains a mean-squared error function
   * scripts, which all code for data processing and model analysis
   * tests, which holds unit tests for the function
* `images`, which stores the graphic output including correlation matrix and scatterplots
* `report`, which is sectioned into its separate parts, which is combined into the official project report
* `slides`, which represents the findings in the report in a formal presentation
* `shinyapp`, which contains an interactive app to visualize the data and results

Not in seperate folders are the .gitignore, the Makefile, the README.md, LICENSE, and session-info.txt.

Specifically, the detailed structure of this project is as following:

```
stat159-fall2016-project3/
    .gitignore
    README.md
    LICENSE
    Makefile
    session-info.txt
    session.sh
    code/
      README.md
      functions/
        ...
      scripts/
        ...
      tests/
        ...
    data/
      README.md
        ...
    images/
      README.md
        ...
    report/
      report.Rnw
      report.pdf
      sections/
        ...
    shinyapp/
	  app.R
	slides/
	  slides.html
	  slides.Rmd
```


## Reproduction Procedure


To reproduce the project:

1. Clone this project in terminal using git clone https://github.com/thomasysun/stat159-fall2016-project3.git

2. Navigate to the folder stat159-fall2016-project3

3. Run `make` in the terminal to regenerate the report, the graphs, and data files 


## Contributors
Ziao Liu

Lydia Maher

Thomas Sun


## License

In this project, we use Apache License Version 2.0
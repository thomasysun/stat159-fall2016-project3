# Statistics 159 Project 3

## Overview
In this project, we assess the performance of publicly funded schools to determine the allocation of grant money for policymakers. Specifically, we attempt to identify the best schools in the US in terms of their demographic, academic, and socioeconomic characteristics in order to help increase equity and graduation rates for underserved populations. Additionally, we use predictive modeling techniques to find the determinants for graduation rates and post-graduation income. Models including ridge regression, lasso regression, principal components regression, and partial least squares regression are applied to data on US universities from College Scorecard provided by the US department of education. The best fitting model is then used to make accurate predictons on graduation and income. We find that coming from a low-income bracket family, having federal loans, and being a first-generation student has a strong negative relationship with income. On the other hand, cost of attendance and SAT scores heavily influence completion rates positively. Based on these factors, seven of the most urgent schools are selected for allocation of grant money. 


## Project Structure
Not in seperate folders are the .gitignore, the Makefile, the README.md, LICENSE, and session-info.txt.
In subfolders, there exists a data folder (where the original dataset and the R analysis is),
a code folder (where the code for the analysis is),
an images folder (where pdfs and pngs of all the histogram and scatterplots are)
and a report folder (where the report was typed up and the all the information collected together).

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
	  slides/
	    slides.html
	    slides.Rmd
    report/
      report.Rnw
      report.pdf
      sections/
        ...
       
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
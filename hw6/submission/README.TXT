================================================================================
                           ASSIGNMENT 6 - README
================================================================================

Authors: Daniel Campos, Èric Gutiérrez & Samuel Fraley

This README provides instructions for running the code and locating the 
outputs (figures and tables) for Assignment 6.

================================================================================
                           DIRECTORY STRUCTURE
================================================================================

submission/
│
├── Assignment6.pdf          # Written assignment with answers
├── README.txt               # This file
│
├── data/                    # Data files (input)
│   ├── ps1_q1.csv          # Question 1 data
│   ├── ps1_q2.dta          # Question 2 data
│   └── ps1_q3.dta          # Question 3 data
│
├── scripts/                 # Code files
│   ├── Assig6_Q1.R         # Question 1 (R script)
│   ├── q2.do               # Question 2 (Stata script)
│   ├── q3_1.do             # Question 3, Part 1 (Stata script)
│   ├── q3_2.do             # Question 3, Part 2 (Stata script)
│   └── q3_3.do             # Question 3, Part 3 (Stata script)
│
└── figures/                 # Output files (tables and figures)
    ├── ols.tex             # Question 3.1: OLS regression table
    ├── probit.tex          # Question 3.1: Probit regression table
    ├── ivprobit_pr_kidcount.png  # Question 3.3: Probability plot
    └── pr_kidcount.tex     # Question 3.3: Predicted probabilities table

================================================================================
                      SYSTEM REQUIREMENTS
================================================================================

To run the code, you will need:

QUESTION 1:
- R (version 4.0 or higher recommended)
- R packages: tidyverse

QUESTIONS 2 & 3:
- Stata (version 14 or higher recommended)
- Stata packages: pscore, psmatch2, estout

================================================================================
                      HOW TO RUN THE CODE
================================================================================

IMPORTANT: The scripts use relative paths. Always run them from the 
submission/ directory to ensure proper file paths.

----------------------------------------------------------------------------
QUESTION 1: Teacher Attendance Analysis (R)
----------------------------------------------------------------------------

From the submission/ directory:

    1. Open R or RStudio
    2. Set working directory to submission/scripts/
       setwd("path/to/submission/scripts")
    
    3. Run the script:
       source("Assig6_Q1.R")

OUTPUTS: 
- Results are printed to the console
- No figure files are generated for Question 1

----------------------------------------------------------------------------
QUESTION 2: Job Displacement & Propensity Score Matching (Stata)
----------------------------------------------------------------------------

From the submission/ directory:

    METHOD A - Run from Stata console:
    
    1. Open Stata
    2. Set working directory:
       cd "path/to/submission/scripts"
    
    3. Run the script:
       do q2.do

    METHOD B - Run by double-clicking:
    
    1. Double-click q2.do in Windows Explorer
    2. The script will automatically set the correct directory

OUTPUTS:
- figures/att_estimates_by_treatment_plot.png  (Figure for Q2.3)
- data/att_estimates_by_treatment.dta          (Intermediate data)
- data/att_estimates_by_treatment.csv          (Intermediate data)
- Console output showing ATT estimates

----------------------------------------------------------------------------
QUESTION 3: Fertility & Female Labor Supply (Stata)
----------------------------------------------------------------------------

There are three separate scripts for Question 3:

** Part 1: OLS and Probit Models **

From the submission/scripts/ directory:

    1. Open Stata
    2. Set working directory:
       cd "path/to/submission/scripts"
    
    3. Run the script:
       do q3_1.do

OUTPUTS:
- figures/ols.tex     (Table: OLS regression results)
- figures/probit.tex  (Table: Probit regression results)

** Part 2: IV Probit First Stage **

From the submission/scripts/ directory:

    1. Open Stata
    2. Set working directory:
       cd "path/to/submission/scripts"
    
    3. Run the script:
       do q3_2.do

OUTPUTS:
- figures/firststage.tex  (Table: First stage regression)
- figures/ivprobit.tex    (Table: IV Probit results)

** Part 3: Predicted Probabilities **

From the submission/scripts/ directory:

PREREQUISITE: You must define the global variable $X before running this
              script. This is done in q3_2.do. Either:
              a) Run q3_2.do first, then run q3_3.do in the same session, OR
              b) Manually define: global X "sexk agem blackm hispm othracem"

    1. Open Stata and run q3_2.do (or define $X manually)
    2. Run the script:
       do q3_3.do

OUTPUTS:
- figures/ivprobit_pr_kidcount.png  (Figure: Predicted probabilities)
- figures/pr_kidcount.tex           (Table: Predicted probabilities by # kids)

================================================================================
                      OUTPUT FILE LOCATIONS
================================================================================

All output files are located in the figures/ subdirectory:

TABLES (LaTeX format):
--------------------
figures/ols.tex                     Question 3.1 - OLS regression
figures/probit.tex                  Question 3.1 - Probit regression
figures/firststage.tex              Question 3.2 - First stage regression
figures/ivprobit.tex                Question 3.2 - IV Probit regression
figures/pr_kidcount.tex             Question 3.3 - Predicted probabilities

FIGURES (PNG format):
--------------------
figures/att_estimates_by_treatment_plot.png   Question 2.3 - ATT plot
figures/ivprobit_pr_kidcount.png              Question 3.3 - Probability plot

================================================================================
                      TROUBLESHOOTING
================================================================================

COMMON ISSUES:

1. "File not found" errors:
   - Ensure you are running scripts from the correct directory
   - Check that relative paths ../data/ and ../figures/ are accessible

2. R package errors:
   - Install tidyverse: install.packages("tidyverse")

3. Stata package errors:
   - Install pscore: ssc install pscore
   - Install psmatch2: ssc install psmatch2
   - Install estout: ssc install estout

4. q3_3.do "$X not found" error:
   - Run q3_2.do first, or manually define:
     global X "sexk agem blackm hispm othracem"

================================================================================
                      ADDITIONAL NOTES
================================================================================

- All tables are exported in LaTeX format (.tex) for easy inclusion in 
  the PDF report
  
- Scripts q2.do, q3_1.do, and q3_3.do use dynamic path detection and will
  automatically set the correct working directory. Only q3_2.do requires
  manual path editing.
  
- Question 2 generates intermediate datasets in data/ directory that are
  used for creating the final plot

- The q2.do script uses a small number of bootstrap replications (3) for 
  demonstration purposes. In production, this should be increased.

- Question 1 outputs are displayed in the R console and are also included
  in the written assignment (Assignment6.pdf)

================================================================================
                              END OF README
================================================================================
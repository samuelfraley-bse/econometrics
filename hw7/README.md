================================================================================
ASSIGNMENT 7: REGRESSION DISCONTINUITY DESIGN
================================================================================

AUTHORS:
Jorge Daniel Campos
Èric Gutiérrez
Samuel Fraley

================================================================================
PROJECT STRUCTURE
================================================================================

This assignment contains the following files:

1. assignment7.dta           - Stata dataset with UK education and earnings data
2. Assig7_Q1_Q2.ipynb        - Jupyter notebook for Questions 1 and 2 (Python)
3. Assig7_Q3.do              - Stata script for Question 3
4. outputs/                  - Folder containing all generated figures and tables

================================================================================
REQUIREMENTS
================================================================================

Python Requirements:
- Python 3.7+
- pandas
- numpy
- matplotlib
- statsmodels

Stata Requirements:
- Stata (any recent version)

To install Python dependencies:
pip install pandas numpy matplotlib statsmodels

================================================================================
HOW TO RUN THE CODE
================================================================================

QUESTIONS 1 & 2 (Python):
-------------------------
1. Open Assig7_Q1_Q2.ipynb in Jupyter Notebook or JupyterLab
2. Run all cells sequentially (Cell -> Run All)
3. Outputs will be generated in the outputs/ folder

QUESTION 3 (Stata):
-------------------
1. Open Stata
2. Set working directory to this folder
3. Run: do Assig7_Q3.do
4. Tables will be displayed in Stata output window

================================================================================
OUTPUTS AND WHERE TO FIND THEM
================================================================================

All outputs are located in the outputs/ folder:

QUESTION 1:
-----------
- figure4.png    - Avg. Age Left Full-Time Education vs Year Age 14
                   (Local averages and parametric fit with RD cutoff at 1947)

- figure6.png    - Log of Annual Earnings vs Year Age 14
                   (Local averages and parametric fit with RD cutoff at 1947)

QUESTION 2:
-----------
- table1.tex     - First Stage and Reduced Form regression results
                   Columns (1)-(3): Effect on Age Left Education
                   Columns (4)-(6): Effect on Log Earnings
                   Shows coefficients and standard errors for Great Britain
                   with various polynomial and age controls

QUESTION 3:
-----------
- Results displayed in Stata console (not saved to file)
- TABLE 1: Effect of Minimum School-Leaving Age
- TABLE 2: Returns to Schooling (OLS & RD-IV)

================================================================================
NOTES
================================================================================

- All regressions use weighted least squares with survey weights
- Standard errors are clustered at the year-age-14 level
- The regression discontinuity design exploits the 1947 UK education reform
- Polynomial controls are quartic (4th degree) where specified
- Sample restricted to: Great Britain (no N. Ireland), ages 32-64,
  non-missing earnings data

================================================================================
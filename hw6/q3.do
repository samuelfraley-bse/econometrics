use "ps1_q3.dta", clear

eststo clear

* OLS
reg workedm kidcount agem blackm hispm othracem
eststo ols

* Probit
probit workedm kidcount agem blackm hispm othracem, nolog
eststo probit


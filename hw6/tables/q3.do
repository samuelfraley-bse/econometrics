use "ps1_q3.dta", clear

eststo clear

* OLS
reg workedm kidcount agem blackm hispm othracem, robust
eststo ols

* Probit
probit workedm kidcount agem blackm hispm othracem
eststo probit

esttab ols probit using ps1_q3.tex, ///
    replace se label ///
    title("Effect of fertility on employment") ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)

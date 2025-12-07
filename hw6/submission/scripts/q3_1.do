* Get the directory where this script is located
local script_dir = "`c(pwd)'"

* If Stata opened the script directly, use that path
if "`c(filename)'" != "" {
    local script_dir = subinstr("`c(filename)'", "\q2.do", "", .)
}

* Change to submission folder (one level up from scripts)
cd "`script_dir'\.."

use "data/ps1_q3.dta", clear

eststo clear

* OLS
reg workedm kidcount agem blackm hispm othracem
eststo ols

esttab ols using "figures/ols.tex", replace booktabs label ///
    nomtitles nonumber ///
    cells("b(fmt(%9.7f)) se(fmt(%9.7f)) t(fmt(%9.2f)) p(fmt(%9.3f)) ci_l(fmt(%9.7f)) ci_u(fmt(%9.7f))") ///
    collabels("Coefficient" "Std. err." "t" "P>|t|" "95% conf. low" "95% conf. high") ///
    stats(N r2 r2_a F rmse, ///
          labels("Number of obs" "R-squared" "Adj R-squared" "F-statistic" "Root MSE"))

* Probit
probit workedm kidcount agem blackm hispm othracem, nolog
eststo probit

esttab probit using "figures/probit.tex", replace booktabs label ///
    nomtitles nonumber ///
    cells("b(fmt(%9.7f)) se(fmt(%9.7f)) z(fmt(%9.2f)) p(fmt(%9.3f)) ci_l(fmt(%9.7f)) ci_u(fmt(%9.7f))") ///
    collabels("Coefficient" "Std. err." "z-stat" "p-value" "95 conf. low" "95 conf. high") ///
    stats(N ll chi2 p r2_p, ///
          labels("Number of obs" "Log likelihood" "LR chi2(5)" "Prob > chi2" "Pseudo R2"))
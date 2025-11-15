cd "C:\Users\sffra\Downloads\BSE 2025-2026\econometrics\hw6"

use "data/ps1_q3.dta", clear

eststo clear

* Define controls
global X "sexk agem blackm hispm othracem"

* ===============================
*  FIRST STAGE: OLS (kidcount)
* ===============================
regress kidcount twin_latest $X
eststo firststage

esttab firststage using "figures/firststage.tex", replace booktabs label ///
    nomtitles nonumber ///
    cells("b(fmt(%9.7f)) se(fmt(%9.7f)) t(fmt(%9.2f)) p(fmt(%9.3f)) ci_l(fmt(%9.7f)) ci_u(fmt(%9.7f))") ///
    collabels("Coefficient" "Std. err." "t" "P>|t|" "95% conf. low" "95% conf. high") ///
    stats(N r2 r2_a F rmse, ///
          labels("Number of obs" "R-squared" "Adj R-squared" "F-statistic" "Root MSE"))

* ==================================
*  SECOND STAGE: IV PROBIT (workedm)
* ==================================
ivprobit workedm $X (kidcount = twin_latest), vce(robust) nolog
eststo ivprobit

esttab ivprobit using "figures/ivprobit.tex", replace booktabs label ///
    nomtitles nonumber ///
    cells("b(fmt(%9.7f)) se(fmt(%9.7f)) z(fmt(%9.2f)) p(fmt(%9.3f)) ci_l(fmt(%9.7f)) ci_u(fmt(%9.7f))") ///
    collabels("Coefficient" "Std. err." "z-stat" "p-value" "95% conf. low" "95% conf. high") ///
    stats(N ll chi2 p r2_p, ///
          labels("Number of obs" "Log likelihood" "Wald chi2" "Prob > chi2" "Pseudo R2"))

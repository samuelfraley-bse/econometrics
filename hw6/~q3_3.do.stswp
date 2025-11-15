* ==================================
*  SECOND STAGE: IV PROBIT (workedm)
* ==================================
ivprobit workedm $X (kidcount = twin_latest), vce(robust) nolog
eststo ivprobit

* IV probit (already in your file)
ivprobit workedm $X (kidcount = twin_latest), vce(robust) nolog

* Predicted probability of employment for each number of kids 0–5
margins, at(kidcount = (0(1)5)) predict(pr)

* Plot probabilities vs. number of children
marginsplot, ///
    ytitle("Predicted probability of employment") ///
    xtitle("Number of children") ///
    title("Effect of number of children on prob. of employment")

graph export "figures/ivprobit_pr_kidcount.png", replace

* -------------------------------------------------
* Predicted probabilities by number of children
* (table to go with the graph)
* -------------------------------------------------

* Predicted probabilities for kidcount = 0,1,2,3,4,5
eststo clear
estpost margins, at(kidcount = (0(1)5)) predict(pr)

esttab using "figures/pr_kidcount.tex", replace booktabs label ///
    nomtitles nonumber ///
    cells("b(fmt(%9.4f)) se(fmt(%9.4f)) ci_l(fmt(%9.4f)) ci_u(fmt(%9.4f))") ///
    collabels("Pred. prob." "Std. err." "95% conf. low" "95% conf. high") ///
    coeflabels(1._at "0 children" ///
               2._at "1 child"   ///
               3._at "2 children" ///
               4._at "3 children" ///
               5._at "4 children" ///
               6._at "5 children") ///
    stats(N, labels("Observations"))


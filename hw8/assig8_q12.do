********************************************************************************
* Assignment 8 - Question 1.2
* CORRECT VERSION - FTE with ADDITION
********************************************************************************

clear all
use assignment8.dta, clear

********************************************************************************
* Step 1: Create FTE (Full-Time Equivalent) employment
* FTE = full-time + 0.5 × part-time (ADDITION, not subtraction!)
********************************************************************************
keep store state chain co_owned time empft emppt
gen fte = empft + 0.5*emppt
label variable fte "Full-time equivalent employment"

********************************************************************************
* Step 2: Reshape to wide format (creates 391 observations)
********************************************************************************
reshape wide empft emppt fte, i(store) j(time)

* Verify sample size
display "Number of observations: " _N
* Should be 391

********************************************************************************
* Step 3: Calculate change in FTE employment
********************************************************************************
gen delta_fte = fte1 - fte0
label variable delta_fte "Change in FTE (after - before)"

********************************************************************************
* Step 4: Create variables
********************************************************************************
rename state NJ
label variable NJ "1 if New Jersey, 0 if Pennsylvania"
label variable chain "Chain type (1=BK, 2=KFC, 3=Roys, 4=Wendys)"
label variable co_owned "1 if company owned"

********************************************************************************
* Step 5: COLUMN 1 - WITH controls
********************************************************************************
display ""
display "=========================================================================="
display "COLUMN 1: Δ Employment ($) WITH controls"
display "=========================================================================="

regress delta_fte NJ chain co_owned, robust

estimates store col1

********************************************************************************
* Step 6: COLUMN 2 - WITHOUT controls
********************************************************************************
display ""
display "=========================================================================="
display "COLUMN 2: Δ Employment ($) WITHOUT controls"
display "=========================================================================="

regress delta_fte NJ, robust

estimates store col2

********************************************************************************
* Step 7: Display results table
********************************************************************************
display ""
display "=========================================================================="
display "TABLE 1: Effect of Minimum Wage on Employment"
display "=========================================================================="

estimates table col1 col2, ///
    b(%9.4f) se(%9.4f) ///
    keep(NJ chain co_owned _cons) ///
    stats(N r2) ///
    title("Effect of Minimum Wage on Employment")

********************************************************************************
* Expected Results:
* Column 1: NJ ≈ 2.9356*** (SE ≈ 1.124), N = 391, R² ≈ 0.017
* Column 2: NJ ≈ 2.9425*** (SE ≈ 1.123), N = 391, R² ≈ 0.031
*           Constant ≈ -2.4901** (SE ≈ 0.014)
********************************************************************************

********************************************************************************
* Step 8: Manual DiD verification
********************************************************************************
display ""
display "=========================================================================="
display "MANUAL DiD CALCULATION:"
display "=========================================================================="

quietly summarize delta_fte if NJ == 1
display "Mean change in NJ: " %6.3f r(mean)
local mean_nj = r(mean)

quietly summarize delta_fte if NJ == 0
display "Mean change in PA: " %6.3f r(mean)
local mean_pa = r(mean)

local did = `mean_nj' - `mean_pa'
display ""
display "Difference-in-Differences: " %6.3f `did'
display "(Should be close to NJ coefficient in Column 2)"

********************************************************************************
* Step 9: Summary statistics
********************************************************************************
display ""
display "=========================================================================="
display "SUMMARY STATISTICS"
display "=========================================================================="

display ""
display "Pre-treatment FTE employment:"
tabstat fte0, by(NJ) statistics(mean sd n) nototal

display ""
display "Post-treatment FTE employment:"
tabstat fte1, by(NJ) statistics(mean sd n) nototal

display ""
display "Change in FTE employment:"
tabstat delta_fte, by(NJ) statistics(mean sd n) nototal

********************************************************************************
* INTERPRETATION
********************************************************************************
display ""
display "=========================================================================="
display "INTERPRETATION:"
display "=========================================================================="
display ""
display "The DiD estimate (coefficient on NJ) ≈ 2.94 indicates:"
display ""
display "- Employment in NJ INCREASED by ~2.94 FTE workers relative to PA"
display "- This is statistically significant at the 1% level (***)"
display "- Effect is robust to inclusion of control variables"
display ""
display "Economic Implications:"
display "- CONTRADICTS standard competitive model (which predicts job losses)"
display "- Suggests fast-food labor market is NOT perfectly competitive"
display ""
display "Possible explanations:"
display "  1. Monopsony power: Employers had wage-setting power"
display "  2. Product market power: Firms can pass costs to consumers"  
display "  3. Efficiency wages: Higher wages reduce turnover costs"
display "  4. Search frictions: Adjustment takes time"
display ""
display "Card & Krueger's key contribution:"
display "- Challenged conventional wisdom on minimum wage effects"
display "- Used natural experiment with diff-in-diff methodology"
display "- One of the most influential labor economics papers"
display "=========================================================================="

********************************************************************************
* End of code
********************************************************************************

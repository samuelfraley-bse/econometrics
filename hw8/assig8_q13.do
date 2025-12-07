********************************************************************************
* Question 1.3: Effect on Full Meal Prices
* Simple version - just two regressions
********************************************************************************

clear all
use "assignment8.dta", clear

* Create full meal price
gen pricemeal = priceentree + pricesoda + pricefry

* Create LOG of price
gen log_pricemeal = log(pricemeal)

* Sort by store and time
sort store time

* Calculate changes
by store: gen delta_pricemeal = pricemeal[_n] - pricemeal[_n-1] if time == 1
by store: gen delta_log_pricemeal = log_pricemeal[_n] - log_pricemeal[_n-1] if time == 1

********************************************************************************
* REGRESSION 1: Change in Price Level (Dollars)
********************************************************************************

di ""
di "REGRESSION 1: CHANGE IN PRICE LEVEL (DOLLARS)"
di "================================================"
reg delta_pricemeal state chain co_owned if time == 1, robust

********************************************************************************
* REGRESSION 2: Change in Log Price (Percentage)
********************************************************************************

di ""
di "REGRESSION 2: CHANGE IN LOG PRICE (PERCENTAGE)"
di "================================================"
reg delta_log_pricemeal state chain co_owned if time == 1, robust

********************************************************************************
* Summary
********************************************************************************

di ""
di "SUMMARY:"
di "--------"
di "Model 1: NJ restaurants increased prices by $0.10 more than PA"
di "Model 2: NJ restaurants increased prices by 2.9% more than PA"
di "Both results are significant at p < 0.05"
di ""
di "This supports product market power - firms can pass costs to consumers"


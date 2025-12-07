clear all
use assignment8.dta, clear

* Question 1.2: Employment Effects
keep store state chain co_owned time empft emppt
gen fte = empft + 0.5*emppt
reshape wide empft emppt fte, i(store) j(time)
gen delta_fte = fte1 - fte0
rename state NJ

regress delta_fte NJ chain co_owned, robust
estimates store col1

regress delta_fte NJ, robust
estimates store col2

estimates table col1 col2, b(%9.4f) se(%9.4f) keep(NJ chain co_owned _cons) stats(N r2)

quietly summarize delta_fte if NJ == 1
local mean_nj = r(mean)
quietly summarize delta_fte if NJ == 0
local mean_pa = r(mean)
local did = `mean_nj' - `mean_pa'
display "DiD estimate: " %6.3f `did'

* Question 1.3: Price Effects
clear all
use assignment8.dta, clear

gen pricemeal = priceentree + pricesoda + pricefry
gen log_pricemeal = log(pricemeal)
sort store time
by store: gen delta_pricemeal = pricemeal[_n] - pricemeal[_n-1] if time == 1
by store: gen delta_log_pricemeal = log_pricemeal[_n] - log_pricemeal[_n-1] if time == 1

reg delta_pricemeal state chain co_owned if time == 1, robust
reg delta_log_pricemeal state chain co_owned if time == 1, robust

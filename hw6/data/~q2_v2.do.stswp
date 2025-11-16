clear all

use "ps1_q2.dta", clear
keep if year == 1995
xtile earn_decile = annual_salary, n(10)
keep id earn_decile
tempfile deciles
save `deciles'

// Ex 2.1
use "ps1_q2.dta", clear

keep if year == 1999
xtile earn_decile = annual_salary, n(10)
gen birth_decade = floor(year_brth/10)*10
gen displaced = (separation == 1 | mass_layoff == 1)
pscore displaced female earn_decile birth_decade, pscore(pscore) blockid(block) comsup

// Ex 2.2
tempname results
tempfile att_results
postfile `results' int(year) double(att_nn) double(se_nn) double(att_kernel) double(se_kernel) using `att_results'

forvalues y = 1996/2001 {
    di ""
    di "===== Processing Year `y' ====="
    
    use "ps1_q2.dta", clear
    keep if year == `y'
    
    merge 1:1 id using `deciles', nogenerate keep(match)
    
    gen birth_decade = floor(year_brth/10)*10
    gen displaced = (separation == 1 | mass_layoff == 1)
    
    quietly psmatch2 displaced female earn_decile birth_decade, ///
        out(annual_salary) neighbor(1) common
    local nn_att = r(att)
    local nn_se = r(seatt)
    
    di "  NN ATT: " %9.2f `nn_att' " (SE: " %9.2f `nn_se' ")"

    quietly bootstrap att=r(att), reps(3) seed(44): ///
        psmatch2 displaced female earn_decile birth_decade, ///
        out(annual_salary) kernel common
    
    matrix b = e(b)
    matrix V = e(V)
    local kernel_att = b[1,1]
    local kernel_se = sqrt(V[1,1])
    
    di "  Kernel ATT: " %9.2f `kernel_att' " (SE: " %9.2f `kernel_se' ")"
    
    post `results' (`y') (`nn_att') (`nn_se') (`kernel_att') (`kernel_se')
}

postclose `results'
use `att_results', clear

list, clean noobs

save "att_estimates.dta", replace


// Ex 2.3

use "att_estimates.dta", clear

reshape long att_ se_, i(year) j(method) string
rename att_ att
rename se_ se

twoway ///
    (line att year if method == "nn", ///
        lcolor(blue) lpattern(solid) lwidth(medium)) ///
    (scatter att year if method == "nn", ///
        mcolor(blue) msymbol(o) msize(medium)) ///
    (line att year if method == "kernel", ///
        lcolor(red) lpattern(dash) lwidth(medium)) ///
    (scatter att year if method == "kernel", ///
        mcolor(red) msymbol(x) msize(medium)), ///
    legend(order(1 "NN Estimate" ///
                 3 "Kernel Estimate") ///
           rows(2) position(6)) ///
    title("ATT Estimates of Job Displacement on Annual Salary", size(medium)) ///
    subtitle("Veneto Workers Histories Data, 1996-2001") ///
    ytitle("ATT Estimate (Annual Salary)") ///
    xtitle("Year") ///
    xlabel(1996(1)2001) ///
    yline(0, lpattern(dash) lcolor(gray)) ///
    scheme(s2color) ///
    name(att_plot, replace)

graph export "att_estimates_plot.png", replace width(2000)

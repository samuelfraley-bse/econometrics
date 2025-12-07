* Get the directory where this script is located
local script_dir = "`c(pwd)'"

* If Stata opened the script directly, use that path
if "`c(filename)'" != "" {
    local script_dir = subinstr("`c(filename)'", "\q2.do", "", .)
}

* Change to submission folder (one level up from scripts)
cd "`script_dir'\.."

clear all
set more off

use "data/ps1_q2.dta", clear
keep if year == 1995
xtile earn_decile = annual_salary, n(10)
keep id earn_decile
tempfile deciles
save `deciles'

// Ex 2.1
use "data/ps1_q2.dta", clear
keep if year == 1999
merge 1:1 id using `deciles', nogenerate keep(match)
gen birth_decade = floor(year_brth/10)*10
gen displaced_all = (separation == 1 | mass_layoff == 1)
pscore displaced_all female earn_decile birth_decade, pscore(pscore) blockid(block) comsup

preserve
keep if pscore != .
keep id pscore block
tempfile ps_matched
save `ps_matched'
restore

// Ex 2.2
use "data/ps1_q2.dta", clear
merge m:1 id using `deciles', nogenerate keep(match)

gen byte displaced_all = .
gen byte displaced_mass = .
gen byte displaced_sep = .

bysort id (year): egen temp_sep_1999 = max((year==1999) & (separation==1))
bysort id (year): egen temp_mass_1999 = max((year==1999) & (mass_layoff==1))

replace displaced_all = (temp_sep_1999 == 1 | temp_mass_1999 == 1)
replace displaced_mass = (temp_mass_1999 == 1)
replace displaced_sep = (temp_sep_1999 == 1 & temp_mass_1999 == 0)

drop temp_*

gen birth_decade = floor(year_brth/10)*10

tempfile fullpanel
save `fullpanel'

tempfile att_master
tempname results
postfile `results' str6(treat) int(year) str6(method) ///
    double(att) double(se) double(n_treat) double(n_control) ///
    using `att_master', replace

local treatments "all mass sep"
local treat_labels `" "all" "All Displacement" "mass" "Mass Layoff Only" "sep" "Separation (Non-Mass)" "'

foreach tr of local treatments {
    di as txt _n "=============================================="
    di as txt "Treatment Type: `tr'"
    di as txt "=============================================="
    
    forvalues y = 1996/2001 {
        use `fullpanel', clear
        keep if year == `y'
		if "`tr'" == "all" {
            gen displaced = displaced_all
        }
        else if "`tr'" == "mass" {
            gen displaced = displaced_mass
        }
        else if "`tr'" == "sep" {
            gen displaced = displaced_sep
        }        
        quietly count if displaced==1
        local n_treat = r(N)
        quietly count if displaced==0
        local n_control = r(N)
        
        if (`n_treat' == 0 | `n_control' == 0) {
            di as error "  Year `y': Insufficient observations (T=`n_treat', C=`n_control')"
            continue
        }
        
        di as txt _n "  Year `y' (N_treated=`n_treat', N_control=`n_control')"
        
        capture {
            quietly psmatch2 displaced female earn_decile birth_decade, ///
                out(annual_salary) neighbor(1) common quietly
            local nn_att = r(att)
            local nn_se  = r(seatt)
            
            di as txt "    NN:     ATT = " as result %10.2f `nn_att' ///
                as txt "  (SE = " as result %8.2f `nn_se' as txt ")"
            
            post `results' ("`tr'") (`y') ("nn") ///
                (`nn_att') (`nn_se') (`n_treat') (`n_control')
        }
        if _rc {
            di as error "    NN matching failed for year `y'"
        }
        
        local reps = 3
        di as txt "    Kernel: Running bootstrap (`reps' reps)..."
        
        capture {
            quietly bootstrap att=r(att), reps(`reps') seed(23) nodots: ///
                psmatch2 displaced female earn_decile birth_decade, ///
                out(annual_salary) kernel common quietly
            
            matrix b = e(b)
            matrix V = e(V)
            local kernel_att = b[1,1]
            local kernel_se  = sqrt(V[1,1])
            
            di as txt "    Kernel: ATT = " as result %10.2f `kernel_att' ///
                as txt "  (SE = " as result %8.2f `kernel_se' as txt ")"
            
            post `results' ("`tr'") (`y') ("kernel") ///
                (`kernel_att') (`kernel_se') (`n_treat') (`n_control')
        }
        if _rc {
            di as error "    Kernel matching failed for year `y'"
        }
    }
}

postclose `results'

use `att_master', clear
list, clean noobs sep(0)

save "data/att_estimates_by_treatment.dta", replace
export delimited "data/att_estimates_by_treatment.csv", replace


// Ex 2.3

di as txt _n "========================================="
di as txt "Exercise 2.3: Creating Plot"
di as txt "=========================================" _n

use "data/att_estimates_by_treatment.dta", clear

twoway ///
    (connected att year if treat=="mass" & method=="nn", ///
        lpattern(solid) lwidth(medthick) lcolor(maroon) ///
        msymbol(D) mcolor(maroon) msize(medium)) ///
    (connected att year if treat=="mass" & method=="kernel", ///
        lpattern(dash) lwidth(medthick) lcolor(maroon) ///
        msymbol(Dh) mcolor(maroon) msize(medium)) ///
    (connected att year if treat=="sep" & method=="nn", ///
        lpattern(solid) lwidth(medthick) lcolor(forest_green) ///
        msymbol(T) mcolor(forest_green) msize(medium)) ///
    (connected att year if treat=="sep" & method=="kernel", ///
        lpattern(dash) lwidth(medthick) lcolor(forest_green) ///
        msymbol(Th) mcolor(forest_green) msize(medium)) ///
    , ///
    title("Average Treatment Effect on Treated: Job Displacement on Annual Salary", ///
        size(medium) color(black)) ///
    subtitle("Veneto Workers Histories, 1996-2001" ///
        "(1999 = Displacement Year)", size(small)) ///
    ytitle("ATT Estimate (Annual Salary)", size(medium)) ///
    xtitle("Year", size(medium)) ///
    xlabel(1996(1)2001, labsize(medium)) ///
    yline(0, lpattern(solid) lcolor(gs10) lwidth(thin)) ///
    xline(1999, lpattern(dash) lcolor(gs8) lwidth(thin)) ///
    legend(order( ///
        1 "Mass Layoff (NN)" ///
        2 "Mass Layoff (Kernel)" ///
        3 "Separation Only (NN)" ///
        4 "Separation Only (Kernel)") ///
        size(small) cols(2) region(lcolor(gs12)) position(6)) ///
    graphregion(color(white)) plotregion(color(white)) ///
    scheme(s2color) ///
    name(att_combined, replace)

graph export "figures/att_estimates_by_treatment_plot.png", replace width(2400) height(1600)
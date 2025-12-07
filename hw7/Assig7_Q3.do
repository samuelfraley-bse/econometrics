***** Question 3 *****

use "/Users/daniel/Documents/dsdm_25-26/term_1/foundations_of_econometrics/assignment_7/assignment7.dta", clear

* Imposition of the sample restrictions *
keep if nireland == 0
keep if age >= 25 & age <= 64

* Generation of the fuzzy RD instrument *
gen instr = yearat14 >= 47

* Centering the quartic polynomial in the running variable *
gen c1 = yearat14 - 47
gen c2 = c1^2
gen c3 = c1^3
gen c4 = c1^4

* Generation of the age dummy variable *
tab age, gen(agedummy_)

*** Column (1) ***
reg learn agelfted c1 c2 c3 c4 [pweight=wght], cluster(yearat14)

*** Column (2) ***
reg learn agelfted c1 c2 c3 c4 age age2 age3 age4 [pweight=wght], cluster(yearat14)

*** Column (3) ***
reg learn agelfted c1 c2 c3 c4 agedummy_* [pweight=wght], cluster(yearat14)

*** Column (4) ***
ivregress 2sls learn (agelfted = instr) c1 c2 c3 c4 [pweight=wght], cluster(yearat14)

*** Column (5) ***
ivregress 2sls learn (agelfted = instr) c1 c2 c3 c4 age age2 age3 age4 [pweight=wght], cluster(yearat14)

*** Column (6) ***
ivregress 2sls learn (agelfted = instr) c1 c2 c3 c4 agedummy_* [pweight=wght], cluster(yearat14)


cd "C:\Users\sffra\Downloads\BSE 2025-2026\econometrics\hw6"

use "data/ps1_q3.dta", clear

eststo clear

* Define controls (adjust to match your variable names)
global X "sexk agem blackm hispm othracem"

* ---------- FIRST STAGE ----------
regress kidcount twin_latest $X
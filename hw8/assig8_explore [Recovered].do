* Inspect_assignment8.do
* Do-file to inspect /mnt/data/assignment8.dta and produce a quick data dictionary/log

set more off
cap log close
log using "inspect_assignment8.log", text replace

// Load dataset (adjust path if needed)
use "C:\Users\sffra\Downloads\BSE 2025-2026\econometrics\hw8\assignment8.dta", clear

// Quick overview
display "\n*** OVERVIEW ***"
describe

ds

display "\n*** SUMMARY STATISTICS (numeric) ***"
summarize

// Compact codebook for quick look at variable labels, types, and value labels
display "\n*** CODEBOOK (compact) ***"
codebook, compact

// Show first 20 observations to eyeball the data
display "\n*** FIRST 20 OBSERVATIONS ***"
list in 1/20

// Show missing-data summary
display "\n*** MISSING DATA SUMMARY ***"
misstable summarize

// Produce a variable-by-variable breakdown: storage type, variable label, value label
display "\n*** VARIABLE DETAILS ***"
describe, fullnames

foreach v of varlist _all {
    di "--------------------------------------------------"
    di "Variable: `v'"
    di "  Storage type: `: type `v''"
    di "  Variable label: `: variable label `v''"
    di "  Value label name (if any): `: value label `v''"
}

// For each variable, either give a detailed numeric summary or frequency table for categorical
display "\n*** DETAILED PER-VARIABLE OUTPUT ***"
foreach v of varlist _all {
    capture confirm numeric variable `v'
    if _rc==0 {
        di "\n-- Numeric summary for `v' --"
        quietly summarize `v', detail
        quietly return list
    }
    else {
        di "\n-- Frequency table for `v' --"
        capture noisily tabulate `v', missing
    }
}

// List defined value labels (useful when variables reference labels)
display "\n*** VALUE LABEL DEFINITIONS ***"
label list

log close

display "\nDone. Log saved as inspect_assignment8.log in the working directory."

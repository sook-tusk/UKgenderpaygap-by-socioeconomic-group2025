
* Last updated on 27 June 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************

*============================================
* > RECAP:
*============================================

** launch Reg table Html file.
view browse file:///$gpgsocioecnomicgrp/5_Output/3_Reg_decomp_html_csv/Table2and3.html

** launch Oaxaca Decom Html file.
view browse file:///$gpgsocioecnomicgrp/5_Output/3_Reg_decomp_html_csv/TableA4_Oaxaca_decom_M4.html
*====================================

cdgpgsocioeconomicgrp
do "./6_Code/3a_OaxacaDecom.do"

** Ensure where unexplained starts.
** read in and edit in Stata.

cdgpgsocioeconomicgrp
cd ./5_Output/3_Reg_decomp_html_csv
insheet using "TableA4_Oaxaca_decom_M4.csv", clear
replace v1 = trim(v1)

gen seq0 = _n
// For unexplained part, assign numbers from 100
** manual check Line number 62. necessary here.
gen seq = cond(seq0 > 62, 100 + seq, seq0)

save "temp", replace
keep if inrange(seq, 1, 8)
drop seq

replace v1 = "Overall" if v1 == "overall"
replace v1 = "Men"   if v1 == "group_1"
replace v1 = "Women" if v1 == "group_2"
replace v1 = "Difference" if v1 == "difference"
replace v1 = "Explained" if v1 == "explained"
replace v1 = "Unexplained" if v1 == "unexplained"
save "temp_overview", replace
list

use "temp", clear
keep if seq > 100
replace seq0 = 9 + _n
drop seq
//Drop last three rows
drop if v3 == ""
rename (v2-v7)(b1 _b1 b2 _b2 b3 _b3)
save "temp_unexplained", replace

use "temp", clear
keep if inrange(seq, 10, 100)
replace v1 = cond(v1 == "unexplained", "Constant", v1)
drop seq

merge 1:1 seq0 using "temp_unexplained"
drop _merge
append using "temp_overview"
// replace seq0 = 9.5 if v1 == "Constant"
replace v1 = "Unobserved" if v1 == "Constant"
sort seq
rename (v2-v7)(a1 _a1 a2 _a2 a3 _a3)
order seq v1 a1 _a1 b1 _b1 a2 _a2 b2 _b2 a3 _a3 b3 _b3
save "temp1", replace

keep if inrange(seq, 1, 9)
save "temp_overview", replace

use "temp1", clear
keep if inrange(seq, 9.5, 100)
replace v1 = trim(v1)
save "temp_beforegrp", replace

*====================================
// > grouping, condensed
*====================================
insheet using "TableA4_OaxacadecomM4_grp.csv", clear
replace v1 = trim(v1)
keep if v1 == "Full-time" |v1 == "Part-time" | v1 == "Occupational sex-segregation"| v1 == "Education" | v1 == "Presence of children" | v1 == "Region" |v1 == "Industry"| v1 == "Firm size"

//need to squeeze these categories in the main table.
//assign seq0 according to the order
gen seq0 = _n
//Repeat seq by the number of grouping
seq seq1, from(1) to(8)
rename seq1 seq

order seq0 seq, first
replace seq0 =  9.9  if v1 == "Full-time"
replace seq0 =  11.5 if v1 == "Part-time"
replace seq0 =  17.5 if v1 == "Occupational sex-segregation"
replace seq0 =  22.5 if v1 == "Education"
replace seq0 =  25.5 if v1 == "Presence of children"
replace seq0 =  28.5 if v1 == "Region"
replace seq0 =  39.5 if v1 == "Industry"
replace seq0 =  54.5 if v1 == "Firm size"

save "temp0", replace
// Remove the unexplained part, > grp number.
// convert to wide form
keep if _n > 8
rename (v2-v7)(b1 _b1 b2 _b2 b3 _b3)
save "temp_grp2", replace

use "temp0", clear
keep if inrange(_n, 1, 8)  // first part
merge 1:1 seq0 using "temp_grp2"
drop _merge seq
rename (v2-v7)(a1 _a1 a2 _a2 a3 _a3)
order seq0 v1 a1 _a1 b1 _b1 a2 _a2 b2 _b2 a3 _a3 b3 _b3
save "temp_grp", replace

*====================================
// > grouping, condensed 2
// Cumulative Work History in Years
*====================================
insheet using "TableA4_OaxacadecomM4_grp2.csv", clear
replace v1 = trim(v1)
keep if v1 == "Cumulative Work History in Years"

//need to squeeze these categories in the main table.
//assign seq0 according to the order
gen seq0 = _n
//Repeat seq by the number of grouping
seq seq1, from(1) to(1)
rename seq1 seq

order seq0 seq, first
replace seq0 =  9.1  if v1 == "Cumulative Work History in Years"

save "temp2", replace
// Remove the unexplained part, > grp number.
keep if _n > 1
rename (v2-v7)(b1 _b1 b2 _b2 b3 _b3)
save "temp_grp2", replace

use "temp2", clear
keep if inrange(_n, 1, 1)  // first part
merge 1:1 seq0 using "temp_grp2"
drop _merge seq
rename (v2-v7)(a1 _a1 a2 _a2 a3 _a3)
order seq0 v1 a1 _a1 b1 _b1 a2 _a2 b2 _b2 a3 _a3 b3 _b3
save "temp_grp2", replace

*====================================
*> merge to the main table
*====================================
append using "temp_grp"

append using "temp_beforegrp"
sort seq0

*====================================
// add proportions
foreach k of varlist a1 b1 a2 b2 a3 b3 {
  gen `k'_temp = subinstr(`k', "*", "", .)
  gen `k'_n = real(`k'_temp)
  drop `k'_temp
}

replace a1_n = 0 if v1 == "Unobserved"
replace a2_n = 0 if v1 == "Unobserved"
replace a3_n = 0 if v1 == "Unobserved"
gen effect1 = a1_n + b1_n
gen effect2 = a2_n + b2_n
gen effect3 = a3_n + b3_n
drop *_n

gen p_1 = effect1 / 0.204
gen p_2 = effect2 / 0.032
gen p_3 = effect3 / 0.288

gen p1 = string(100 * effect1 / 0.204, "%8.1f") + "%"
gen p2 = string(100 * effect2 / 0.032, "%8.1f") + "%"
gen p3 = string(100 * effect3 / 0.288, "%8.1f") + "%"

append using "temp_overview"
sort seq0
drop p_*

//formatting
insobs 1, after(8)
replace seq0 = 9 if _n == 9
foreach k of varlist a1  a2  a3  {
 replace `k' = "Characteristics" if seq0 == 9
}

foreach k of varlist  b1  b2  b3 {
 replace `k' = "Coefficient" if seq0 == 9
}

foreach k of varlist _a1 _b1 _a2 _b2 _a3 _b3 {
 replace `k' = "(SE)" if seq0 == 9
}

forvalues k = 1/3 {
 gen t_effect`k' = string(effect`k')
 replace t_effect`k' = "Total effect" if seq0 == 9
 replace t_effect`k' = "" if inrange(seq0, 1, 8)
 replace p`k' = "% Contributor" if seq0 == 9
}

order t_effect1 p1, before(a2)
order t_effect2 p2, before(a3)
order t_effect3, before(p3)
drop effect*

replace a1 = "All sample" if v1 == "Overall"
replace a2 = "Poor" if v1 == "Overall"
replace _a2 = "Households" if v1 == "Overall"
replace a3 = "Wealthy" if v1 == "Overall"
replace _a3 = "Households" if v1 == "Overall"

*====================================
*> Rename rows Summary at the top
*====================================
// Add an additional heading
insobs 1, after(20)
replace seq0 = 17.1 if _n == 21

replace v1 =  "Key Work Indicators" if _n == 21

replace v1 =  "Mean hourly pay - Men (a)" if v1 == "Men"
replace v1 =  "Mean hourly pay - Women (b)" if v1 == "Women"

replace v1 =  "Difference [GPG = (a - b) = (e + f)]" ///
 if v1 == "Difference"

replace v1 =  "Characteristics effect (e)" if v1 == "Explained"

replace v1 =  "Coefficient effect (f)" if v1 == "Unexplained"

// tidy ----------------------------
dir

local datafiles: dir . files "temp*.dta"
foreach filename of local datafiles {
        rm "`filename'"
}

** 4. Check
dir

*====================================
*> Save
*====================================
cdgpgsocioeconomicgrp
cd ./5_Output/3_Reg_decomp_html_csv
save "Oaxaca_decom_table", replace
use "Oaxaca_decom_table", clear

*====================================
*> export to Word
*====================================
drop if inlist(_n, 1, 2)

cdgpgsocioeconomicgrp
cd ./5_Output/4_Word

global asdoctable1 "Table_A4_OaxacaDecom_A"

asdoc list v1 a1 _a1 b1 _b1 t_effect1 p1, replace ///
  save($asdoctable1)  font(Times) fs(10)  ///
  title(Table A4. KOB decomposition of the Gender Pay Gap at the Mean)

winexec "$word" "$asdoctable1.doc"

global asdoctable2 "Table_A5_OaxacaDecom_B"
asdoc list v1 a2 _a2 b2 _b2 t_effect2 p2 ///
a3 _a3 b3 _b3 t_effect3 p3, replace ///
  save($asdoctable2)  font(Times) fs(10)  ///
  title(Table A5. KOB decomposition of the Gender Pay Gap by Household Type)

winexec "$word" "$asdoctable2.doc"

/* End */

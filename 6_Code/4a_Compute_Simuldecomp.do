
* Last updated on 27 June 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************


clear all
macro drop _all

*============================================
* > RECAP: View the results first
*============================================
** launch Oaxaca Decom Html file.
// view browse file:///$gpgsocioecnomicgrp/5_Output/3_Simdecomp/SimDecom.html

*-------------------------------------
cdgpgsocioeconomicgrp

do "./6_Code/2a_Regression.do"
tab retrodata   /* kept retrodata only */

*==========================================
***** Declare variables  *****
*==========================================
tab hhtype, nol

svyset [pw = xsecweight]
global y lnhourlyrealpay
//M4
global x female  ///
 fullyears fullyears2 partyears partyears2 ///
 famyears matyear unempyear sickyear     ///
 segcat1 segcat3 public inunion bonus    ///
  edu_2-edu_4 toddler ch515 nonWhiteUK  ///
  gor_1-gor_8 gor_10-gor_12             ///
  sic16gr_1-sic16gr_15 firm1-firm3      ///
  ot insider outsider temp

*==========================================
*****>  M4: RUN simdecomp  *****
*==========================================
//M4
cdgpgsocioeconomicgrp
do "./6_Code/4b_OPTIONAL_simdecomp_prep.do"

mat list simdecomp

//Rename matrix
mat simdecomp_m4 = simdecomp_all
mat colnames simdecomp_m4 = Men1 Women1 xdiff1 b1 ///
 Men2 Women2 xdiff2 b2  Men3 Women3 xdiff3 b3
mat list simdecomp_m4

*==========================================
*****>  M5: RUN simdecomp  *****
*==========================================
//M5, with interactions
global x0 $x
global x1 partyearsF partyears2F inunionF bonusF
global x  $x0 $x1
do "./6_Code/4b_Optional_simdecomp_prep.do"

//Rename matrix(3 groups)
mat simdecomp_m5 = simdecomp_all
mat colnames simdecomp_m5 = Men4 Women4 xdiff4 b4 ///
 Men5 Women5 xdiff5 b5  Men6 Women6 xdiff6 b6

*==========================================
***** > Get labels  *****
*==========================================

cdgpgsocioeconomicgrp
import delimited "6_Code/0_Labels/Labels.txt", delimiter(tab) clear
gen seq = _n
save  "5_Output/3_Simdecomp/Labels.dta", replace

// view browse file:///$gpgsocioecnomicgrp/6_Code/0_Notes/Labels.txt

*==========================================
*****>  Save  *****
*==========================================
cls
mat list simdecomp_m4
mat list simdecomp_m5

//save matrix to Stata file.
cdgpgsocioeconomicgrp
cd ./5_Output/3_Simdecomp
capture erase simdecomp_m4.dta
capture erase simdecomp_m5.dta
svmatf, mat(simdecomp_m4) fil(simdecomp_m4.dta)
svmatf, mat(simdecomp_m5) fil(simdecomp_m5.dta)

*====================================
* Merge Simdecom
*====================================
cdgpgsocioeconomicgrp
cd ./5_Output/3_Simdecomp

use "simdecomp_m4", clear
set obs 61
gen seq = _n
// drop *1 *2
save "SimDecom", replace

use "simdecomp_m5", clear
gen seq = _n

merge 1:1 seq row using "SimDecom"
gen seq0 = _n
keep if inrange(seq0, 1, 62)

//Fix _cons
forvalues k = 1/3 {
  sum b`k' if seq0 == _N
  replace b`k' = cond(seq ==  _N-1, r(mean), b`k')
  replace   Men`k' = 0 if seq ==  _N-1 & Men`k' == .
  replace Women`k' = 0 if seq ==  _N-1 & Women`k' == .
  replace xdiff`k' = 0 if seq ==  _N-1 & xdiff`k' == .
}

drop if row == "_cons" & seq0 ==  _N
drop seq0 _merge
order row seq *1 *2 *3 *4 *5 , first

*====================================
* > Merge Labels, heading
*====================================
cdgpgsocioeconomicgrp
merge 1:1 seq using "5_Output/3_Simdecomp/Labels.dta"
replace v1 = trim(v1)
order v1, first

*====================================
* Heading
*====================================
//See 2b_Table_Reg.do
//need to squeeze these categories in the main table.

replace seq =  4.5 if v1 == "Cumulative Work History in Years"
replace seq =  4.6 if v1 == "Full-time"
replace seq =  6.5 if v1 == "Part-time"
replace seq =  12.5 if v1 == "Key Work Indicators"
replace seq =  12.6 if v1 == "Occupational sex-segregation"
replace seq =  17.5 if v1 == "Education"
replace seq =  20.5 if v1 == "Presence of children"
replace seq =  23.5 if v1 == "Region"
replace seq =  34.5 if v1 == "Industry"
replace seq =  49.5 if v1 == "Firm size"

sort seq
order seq, first

insobs 3, before(1)
replace v1 =  "Overall" if _n == 1
replace v1 =  "Differences excluding Female (a)" if _n == 2
replace seq =  0.5 if v1 == "Overall"
replace seq =  3.1 if v1 == "Differences excluding Female (a)"
replace row =  "excl_female" if v1 == "Differences excluding Female (a)"
replace v1 =  "Difference (a + b)" if row == "Difference"
replace v1 =  "Female 'Residual' (b)" if row == "female"
replace seq =  3.2 if row == "female"
replace seq =  4 if _n == 3
sort seq
order xdiff*, last

replace seq = 7.5 if row == "partyearsF"
replace seq = 8.5 if row == "partyears2F"
sort seq

//group id
gen catgrp = .
// order catgrp, after(row)
replace catgrp = 1 if v1 == "Full-time" |row == "fullyears" | row == "fullyears2"
replace catgrp = 2 if v1 == "Part-time" | row == "partyears" | row == "partyearsF" | row == "partyears2" | row == "partyears2F"
replace catgrp = 3 if v1 == "Occupational sex-segregation" | row == "segcat1" | row == "segcat3"
replace catgrp = 4 if v1 == "Education" | row == "edu_2" | row == "edu_3"| row == "edu_4"
replace catgrp = 5 if v1 == "Presence of children" | row == "toddler" | row == "ch515"
replace catgrp = 6 if v1 == "Region"
replace catgrp = 6 if inrange(seq, 24, 34)
replace catgrp = 7 if v1 == "Industry"
replace catgrp = 7 if inrange(seq, 35, 49)
replace catgrp = 8 if v1 == "Firm size" | row == "firm1" | row == "firm2"| row == "firm3"

*====================================
* > Compute Simdecom
*====================================

forvalues k = 1/6 {
    gen xb`k' = xdiff`k'  * b`k' if _n > 9
    replace xb`k' = xdiff`k'  * b`k' if row == "female"
}

//group sum
forvalues k = 1/6 {
    bysort catgrp : egen gsum`k' = total(xb`k')
}

sort seq
order catgrp v1 row, last

//fill in now
forvalues k = 1/6 {
  replace xb`k' = gsum`k' if v1 == "Full-time"
  replace xb`k' = gsum`k' if v1 == "Part-time"
  replace xb`k' = gsum`k' if v1 == "Occupational sex-segregation"
  replace xb`k' = gsum`k' if v1 == "Education"
  replace xb`k' = gsum`k' if v1 == "Presence of children"
  replace xb`k' = gsum`k' if v1 == "Region"
  replace xb`k' = gsum`k' if v1 == "Industry"
  replace xb`k' = gsum`k' if v1 == "Firm size"
}

//group sum summary
// tabdisp catgrp, cell(gsum*)

//group sum
sort seq

//% Contributor
gen p1 = string(100 * xb1 / 0.204, "%8.1f") + "%"
gen p2 = string(100 * xb2 / 0.032, "%8.1f") + "%"
gen p3 = string(100 * xb3 / 0.288, "%8.1f") + "%"

gen p4 = string(100 * xb4 / 0.204, "%8.1f") + "%"
gen p5 = string(100 * xb5 / 0.032, "%8.1f") + "%"
gen p6 = string(100 * xb6 / 0.288, "%8.1f") + "%"

forvalues k = 1/6 {
  replace p`k' = "% Contributor" if seq == 4
}


order xb1 p1, after(b1)
order xb2 p2, after(b2)
order xb3 p3, after(b3)
order xb4 p4, after(b4)
order xb5 p5, after(b5)
order xb6 p6, after(b6)
order catgrp, after(row)

//Check %
  gen p_1 = xb1 / 0.204
  gen p_2 = xb2 / 0.032
  gen p_3 = xb3 / 0.288

  gen p_4 = xb4 / 0.204
  gen p_5 = xb5 / 0.032
  gen p_6 = xb6 / 0.288
  // drop p_* gsum* _merge

order catgrp v1 row, after(seq)

//title
insobs 1, before(1)
replace seq = .1 if _n == 1
replace p1 = "M4" if _n == 1
replace p2 = "M4_Poor" if _n == 1
replace p3 = "M4_Wealthy" if _n == 1
replace p4 = "M5" if _n == 1
replace p5 = "Poor" if _n == 1
replace p6 = "Wealthy" if _n == 1

//add duplicate female at the end
expand 2 if row == "female", gen(dupfemale)
replace seq = _N if _n == _N
replace v1 = "Female 'Residual'" if _n == _N

*====================================
*> Overall, Differences excluding Female
*====================================

forvalues k = 1/6 {
    replace xb`k' = Men`k' if inrange(seq, 1, 3)
    replace xb`k' = xb`k'[_n-1] - xb`k'[_n+1] if row == "excl_female"
 }

  //Check
  di .2041909 - .08831444
  di .287881 - .12605825
  di .11568556 +.08831444

*====================================
*> tidy
*====================================

forvalues k = 1/6 {
  replace Men`k' = xb`k' if row == "excl_female"
  replace Men`k' = xb`k' if row == "female" & inrange(seq,1,4)
  replace Women`k' = .   if row == "female" & inrange(seq,1,4)
  replace b`k' = .   if inrange(seq, 1, 4)
  replace p`k' = ""  if p`k' == ".%"
}

*====================================
*> Rename rows Summary at the top
*====================================
replace v1 =  "Mean hourly pay - Men (a)" if row == "Men"
replace v1 =  "Mean hourly pay - Women (b)" if row == "Women"

replace v1 =  "Difference [GPG = (a - b) = (c + d)]" ///
 if row == "Difference"

replace v1 =  "Measured Differences, excluding Female (c)" ///
 if row == "excl_female"

replace v1 =  "Measured Female 'Residual' (d)" ///
 if row == "female"

*====================================
*> Save
*====================================

cdgpgsocioeconomicgrp
save "./5_Output/3_Simdecomp/SimDecom_messy", replace
use  "./5_Output/3_Simdecomp/SimDecom_messy", replace


*====================================
*> export to Html (for inspection only)
*====================================
cdgpgsocioeconomicgrp
cd ./5_Output/3_Simdecomp
format xb1 xb4 xb5 xb6 %4.3f
global logfile "SimDecom"
set linesize 200

capture log using "SimDecom", replace smcl

  di as text "{title:Simulation Decomposition results}"

  list v1 xb1 p1 xb4 p4 xb5 p5 xb6 p6, clean noobs

capture log close
log2html "SimDecom", replace // use later.
erase SimDecom.smcl

** launch Oaxaca Decom Html file.
view browse file:///$gpgsocioecnomicgrp/5_Output/3_Simdecomp/SimDecom.html

*====================================
*> export to Excel (for inspection only)
*====================================
cdgpgsocioeconomicgrp
cd ./5_Output/3_Simdecomp
global simdecom "SimDecom_M4all_M5all"

export excel catgrp v1 xb1 p1 xb2 p2 xb3 p3 ///
                       xb4 p4 xb5 p5 xb6 p6 ///
using "SimDecom_M4all_M5all.xls", firstrow(variables) replace

global simdecom "SimDecom"
export excel catgrp v1 xb1 p1 xb4 p4 xb5 p5 xb6 p6 ///
using "SimDecom.xls", firstrow(variables) replace
di as smcl "output written to {browse  " `"$simdecom.xls}"'

winexec "$excel" "$simdecom.xls"

*====================================
*> export to Word, M4 mean only
*====================================
cdgpgsocioeconomicgrp
use  "./5_Output/3_Simdecomp/SimDecom_messy", replace

/* drop interactions*/
drop if row=="partyearsF" | row == "partyears2F" | ///
        row == "inunionF" | row == "bonusF"
keep seq catgrp v1  row *1 *2 *3
drop xdiff* gsum* p_*
save "./5_Output/3_Simdecomp/SimDecom_tidy_M4", replace
use  "./5_Output/3_Simdecomp/SimDecom_tidy_M4", replace

//*mean only
cdgpgsocioeconomicgrp
cd ./5_Output/4_Word
global asdoctable1 "Table_A6_SimDecom_M4"

asdoc list v1  Men1 Women1 b1 xb1 p1, replace ///
  save($asdoctable1) font(Times) fs(10)  ///
  title(Table A6. Simulation decomposition of the Gender Pay Gap at the Mean (based on M4) )

winexec "$word" "$asdoctable1.doc"

*====================================
*> export to Word, M4 all
*====================================
cdgpgsocioeconomicgrp
use  "./5_Output/3_Simdecomp/SimDecom_tidy_M4", replace

cdgpgsocioeconomicgrp
cd ./5_Output/4_Word
global asdoctable2 "Table_4_SimDecom_M4_all"

// title(Table 4. Simulation decomposition of the Gender Pay Gap at the Mean and by Household Type (M4))
asdoc list v1 xb1 p1 xb2 p2 xb3 p3, replace ///
  save($asdoctable2) font(Times) fs(9)  ///
  title(Table 4. Table A3. Simulation decomposition of the gender pay gap at the mean (all) and for poor and wealthy sub-samples (based on the wage regression model 4) )

winexec "$word" "$asdoctable2.doc"


*====================================
*> tidy
*====================================
//Back to the proj folder
cdgpgsocioeconomicgrp

/* End */

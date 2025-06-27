
* Last updated on 27 June 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************

cdgpgsocioeconomicgrp
do "./6_Code/0_Setup/2_Custom_Path.do"

*====================================
//model-fitting and Print results in Stata.
//FOR PUBLICATION TABLES, SEE NEXT FILE.
*====================================

cdgpgsocioeconomicgrp
use "./7_Input/Readonly/Cleaned.dta", clear

**> TABLE 2 Prep - **

di _N

mark fullregsamp
markout fullregsamp female ///
 fullyears fullyears2 partyears partyears2 ///
 famyears matyear unempyear sickyear       ///
 segcat public inunion bonus               ///
 edu toddler ch515 nonWhiteUK              ///
 gor sic16gr firmsize                      ///
 ot insider outsider temp

keep if fullregsamp==1
di _N

global x1 female

global x2 female                           ///
  fullyears fullyears2 partyears partyears2 ///
  famyears matyear unempyear sickyear

global x3 female segcat1 segcat3

** M4: fully-fitted model**
global x4 $x2                             ///
  segcat1 segcat3 public inunion bonus    ///
  i.edu toddler ch515 nonWhiteUK    ///
  ib8.gor ib15.sic16gr i.firmsize   ///
  ot insider outsider temp

**M5: 4 interaction terms**
global x5 $x4                   ///
  partyearsF partyears2F inunionF bonusF

**all interactions**
global x09 $x4                           ///
  fullyearsF fullyears2F               ///
  partyearsF partyears2F               ///
  famyearsF unempyearF sickyearF       ///
  segcat1F segcat3F publicF inunionF bonusF

global y lnhourlyrealpay
di _N  /*  10206 */


*-------------------------------------
* > Fit regression models
*-------------------------------------
tab retrodata /* confirms all have retrodata */
// keep if code to be explicit

svy: regress $y $x1 if retrodata==1
  eststo M1
  esttab M1, wide b(3) r2 nobase label not nose
svy: regress $y $x2 if retrodata==1
  eststo M2
  esttab M2, wide b(3) r2 nobase label not nose
svy: regress $y $x3 if retrodata==1
  eststo M3
  esttab M3, wide b(3) r2 nobase label not nose
svy: regress $y $x4 if retrodata==1
  eststo M4
  esttab M4, b(3) r2 nobase label not nose
svy: regress $y $x5 if retrodata==1
  eststo M5
  esttab M5, wide b(3) r2 nobase label not nose

*-------------------------------------
* >> Print Table 2 in Stata
*-------------------------------------

cls
esttab M1 M2 M3 M4 M5,  ///
   b(3) se r2 nobase label not nodepvars ///
   varwidth(55) nonumbers ///
   title("Table 2. Wage Regressions, at the mean. ")

*============================================
**> Fit models: rich and poor subsamples
*============================================

** M4 and M5 (full model, with 4 interactions)
  svy: regress $y $x4 if retrodata==1 & poor==1
  eststo M4poor
  esttab M4poor, wide b(3) r2 nobase label not nose

  svy: regress $y $x5 if retrodata==1 & poor==1
  eststo M5poor
  esttab M5poor, wide b(3) r2 nobase label not nose

  svy: regress $y $x4 if retrodata==1 & rich==1
  eststo M4rich
  esttab M4rich, wide b(3) r2 nobase label not nose

  svy: regress $y $x5 if retrodata==1 & rich==1
  eststo M5rich
  esttab M5rich, wide b(3) r2 nobase label not nose

*-------------------------------------
**>> Print Table 3 in Stata
*-------------------------------------
cls
esttab M4poor M5poor M4rich M5rich, ///
  b(3) se r2 nobase label not nodepvars   ///
  nonumbers varwidth(55)  ///
  title("Table 3. Wage Regressions, final model with and without interactions, for poor and wealthy subsamples.")

*============================================
**> Possible Appendix Table **
*============================================

**all interactions - SEE ABOVE**
svy: regress $y $x09 if retrodata==1
eststo regapp

*-------------------------------------
**>> Print Appendix Table in Stata
*-------------------------------------

esttab regapp, wide b(3) se r2 nobase label   ///
  nodepvars varwidth(55) nonumbers ///
  title("Appendix Table. Wage Regressions, full-fitted model with all interactions.")

****  End ****




* Last updated on 27 June 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************
cd

clear
set more off
capture log close

do "./6_Code/0_Setup/2_Custom_Path.do"

// Relative path
use "./7_Input/Readonly/Cleaned.dta", clear

keep if retrodata==1
di _N

mark fullregsamp
markout fullregsamp female ///
 fullyears fullyears2 partyears partyears2 ///
 famyears matyear unempyear sickyear       ///
 segcat public inunion bonus               ///
 edu toddler ch515 nonWhiteUK              ///
 gor sic16gr firmsize                      ///
 ot insider outsider temp

keep if fullregsamp == 1
di _N

svyset [pw = xsecweight]


// In paper, median men £13.47, women £10.50
// Men
epctile hourlyrealpay, percentiles(5 10 20 30 40 50 60 70 80 90 95) subpop(male) svy

mat mendecile = r(table)'

// Women
epctile hourlyrealpay, percentiles(5 10 20 30 40 50 60 70 80 90 95) subpop(female) svy
mat womendecile = r(table)'

mat list womendecile

// Create an indicator:
// all rows, one column, fill with 0/1
mat sex0 = J(rowsof(mendecile), 1, 0)
mat sex1 = J(rowsof(womendecile), 1, 1)

mat sex = sex0 \ sex1
mat colnames sex = sex
mat list sex

mat p = mendecile \ womendecile

mat list p

mat paydecile = p[1..., "b"],  p[1..., "se"], ///
  p[1..., "ll"],p[1..., "ul"], sex

mat list paydecile

// wide form

*--------------------------------
//save matrix to Stata file.
cd

cd ./5_Output/2_Desc_Tables

capture erase pay_deciles_bygender.dta
svmatf, mat(paydecile) fil(pay_deciles_bygender.dta)

*-------------------------------------
** > Back to the proj folder
*-------------------------------------
cd ../../
cd

*=================================
** > Visualisation prep
*=================================

use 5_Output/2_Desc_Tables/pay_deciles_bygender, clear


*-----------------------------------------
** generate the percentile var
*-----------------------------------------
destring row, ignore("p") gen(percentile)
order percentile sex

*=================================
** > GPG by deciles
*=================================

// calc GPG by deciles
sort row sex

gen gpgbydec = 1 - (b[_n+1]/b) if sex == 0
di (6.095294 - 5.468492)/6.095294

// avoid reshape unless producing a table.
// keep b sex percentile
// reshape wide b, i(sex) j(percentile)

sort sex row


save 5_Output/2_Desc_Tables/pay_deciles_bygender_tidy, replace

*====================================
** Figure
*====================================

use 5_Output/2_Desc_Tables/pay_deciles_bygender_tidy, clear //check

list in 1/10, clean

//50th percentile: men 13.4719, women 10.49506

twoway                            ///
 (rarea ll ul percentile if sex == 0, color(gs12) ) ///
 (rarea ll ul percentile if sex == 1, color(gs12) ) ///
 (line b percentile if sex == 0, lpatt(solid) ) ///
 (line b percentile if sex == 1, ///
    lpatt(dash) lcolor(grey) )   ///
 (scatteri 13.5 50 10.5 50 )  ///
, name(fig1, replace)  ///
 text(16 50 "£13.47" 8 50 "£10.50")  ///
 xlabel(10(10)100, nogrid labsize(medium) ) ///
 xtitle(Percentile, size(medium))  ///
 ylabel(, labsize(medium))  ///
 ytitle("Gross Hourly Real Pay (£)", size(medium) ) ///
 legend(order(3 "Men" 4 "Women" 2 "95% CI" 1 "95% CI") ///
    size(small) ring(1) pos(4) col(1) )  ///
 ysize(3) xsize(5.0)

graph export "5_Output/4_Figures/Fig1_GrossHourlyRealPayPercentiles.png", ///
 replace


** View in browser
view browse file:///$gpgsocioecnomicgrp/5_Output/4_Figures/Fig1_GrossHourlyRealPayPercentiles.png

cd

****  End ****

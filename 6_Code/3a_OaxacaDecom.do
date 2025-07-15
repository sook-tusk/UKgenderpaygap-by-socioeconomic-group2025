
* Last updated on 15 July 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************

*============================================
* > Run earlier 0_Regression_Prep.do
*============================================

do "./6_Code/2a_Regression.do"
di _N

//"No interactions"
//"Run Oaxaca M4 mean,rich,poor,simdecomp mean"

**>> Oaxaca M4 (individual entry)
global xdecom ///
 fullyears fullyears2 partyears partyears2 ///
 famyears matyear unempyear sickyear       ///
 segcat1 segcat3 public inunion bonus      ///
  edu_2-edu_4 toddler ch515  nonWhiteUK   ///
  gor_1-gor_8 gor_10-gor_12          ///
  sic16gr_1-sic16gr_15 firm1-firm3   ///
  ot insider outsider temp

// CONDENSED = using grouping
global grouping ///
 detail(                                ///
 "Full-time": fullyears fullyears2,     ///
 "Part-time": partyears partyears2,     ///
 "Occupational sex-segregation": segcat1 segcat3, ///
 "Education": edu*,                     ///
 "Presence of children": toddler ch515, ///
 "Region ": gor*,                       ///
 "Industry": sic16*,                    ///
 "Firm size": firm*)

// CONDENSED = using grouping2
global grouping2 ///
 detail(                                ///
 "Cumulative Work History in Years":  ///
  fullyears fullyears2 partyears partyears2 ///
  famyears matyear unempyear sickyear)

*====================================
**>> Oaxaca - Full -
*====================================

eststo decom_M4: oaxaca lnhourlyrealpay ///
  $xdecom if retrodata == 1,  ///
  svy weight(0) by(sex) noisily

eststo decom_M4_poor: oaxaca lnhourlyrealpay ///
  $xdecom if retrodata == 1 & poor == 1,  ///
  svy weight(0) by(sex) noisily relax

eststo decom_M4_rich: oaxaca lnhourlyrealpay ///
  $xdecom if retrodata == 1 & rich == 1,  ///
  svy weight(0) by(sex) noisily relax

cls
*esttab decom_M4, wide b(3)  //test

*====================================
**>> Oaxaca - CONDENSED -
*====================================

eststo decom_M4_grp: oaxaca lnhourlyrealpay ///
  $xdecom if retrodata == 1,  ///
  svy weight(0) by(sex) noisily $grouping

eststo decomM4poor_grp: oaxaca lnhourlyrealpay ///
  $xdecom if retrodata == 1 & poor == 1,  ///
  svy weight(0) by(sex) noisily relax $grouping

eststo decomM4rich_grp: oaxaca lnhourlyrealpay ///
  $xdecom if retrodata == 1 & rich == 1,  ///
  svy weight(0) by(sex) noisily relax $grouping

*====================================
**>> Oaxaca - CONDENSED 2 -
// Cumulative Work History in Years
*====================================
// .0456349 .0666186 Sig.
eststo decom_M4_grp2: oaxaca lnhourlyrealpay ///
  $xdecom if retrodata == 1,  ///
  svy weight(0) by(sex) noisily $grouping2

// -.0421433 Sig  .0922815  NS
eststo decomM4poor_grp2: oaxaca lnhourlyrealpay ///
  $xdecom if retrodata == 1 & poor == 1,  ///
  svy weight(0) by(sex) noisily relax $grouping2

 // .0449364 Sig -.0546055 NS
eststo decomM4rich_grp2: oaxaca lnhourlyrealpay ///
  $xdecom if retrodata == 1 & rich == 1,  ///
  svy weight(0) by(sex) noisily relax $grouping2

*-------------------------------------
** > Change the path
*-------------------------------------
cd ./5_Output/3_Reg_decomp_html_csv

*-------------------------------------
** > Intermediate outputs in html
*-------------------------------------

esttab decom_M4 decom_M4_poor decom_M4_rich ///
 using "TableA4_Oaxaca_decom_M4.html", replace ///
 wide b(3) se label nodepvars varwidth(55)

view browse file:///$gpgsocioecnomicgrp/5_Output/3_Reg_decomp_html_csv/TableA4_Oaxaca_decom_M4.html

*====================================
**>> EXPORT TO CSV, FOR FURTHER EDITS Full
*====================================

esttab decom_M4 decom_M4_poor decom_M4_rich ///
 using "TableA4_Oaxaca_decom_M4.csv", replace  ///
  wide b(3) se label nodepvars varwidth(55)

*====================================
**>> EXPORT TO CSV, FOR FURTHER EDITS CONDENSED
*====================================

cls
esttab decom_M4_grp decomM4poor_grp decomM4rich_grp ///
 using "TableA4_OaxacadecomM4_grp.csv", replace  ///
  wide b(3) se nodepvars varwidth(55)

*====================================
**>> EXPORT TO CSV, FOR FURTHER EDITS CONDENSED2
*====================================

cls
esttab decom_M4_grp2 decomM4poor_grp2 decomM4rich_grp2 ///
 using "TableA4_OaxacadecomM4_grp2.csv", replace  ///
  wide b(3) se nodepvars varwidth(55)

*-------------------------------------
** > Back to the proj folder
*-------------------------------------
cd ../../
cd

/* End */


* Last updated on 15 July 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************

*====================================
//Run earlier model-fitting code.
//Use this file to PRINT AND REPORT FOR PUBLICATION
*====================================

*-------------------------------------
* > Run an earlier do file
*-------------------------------------
cd
do "./6_Code/0_Setup/2_Custom_Path.do"

do "./6_Code/2a_Regression.do"

*============================================
** > FOR PUBLICATION: REPORT Table A2 - WORD
*============================================

esttab M4 M5 M4poor M5poor M4rich M5rich ///
 using "5_Output/4_Word/Regression/Table_A2_Regression_M4_M5_all.rtf", replace ///
 b(3) se r2 nobase label not nodepvars nogap onecell ///
 stats(r2 N, fmt(3 0) labels("R{\super 2}" Observations)) ///
   title({\b "Table A2. Full wage regression models with (M4) and without interactions (M5), at the mean and for poor and wealthy sub-samples  " })

winexec "$word" "5_Output/4_Word/Regression/Table_A2_Regression_M4_M5_all.rtf"

*============================================
** > FOR PUBLICATION: REPORT Table 2 - WORD
*============================================

esttab M1 M2 M3 M4 M5 ///
 using "5_Output/4_Word/Regression/Table_2_Regression_M1_thru_M5.rtf", replace ///
 b(3) se r2 nobase label not nodepvars nogap onecell ///
 stats(r2 N, fmt(3 0) labels("R{\super 2}" Observations)) ///
   title({\b "Table 2. Wage Regressions, at the mean" })

winexec "$word" "5_Output/4_Word/Regression/Table_2_Regression_M1_thru_M5.rtf"

*
*============================================
** > FOR PUBLICATION: REPORT Table 2 csv
*============================================

//Simple models, with and without F interactions for reviewer

cls
esttab M1 M2 M3 M4 M5  ///
  using "5_Output/3_Reg_decomp_html_csv/Table2.csv", replace ///
   b(3) se r2 nobase label not nodepvars ///
   title("Table 2. Wage Regressions, at the mean. ")


*============================================
**> FOR PUBLICATION: REPORT Table 3 csv
** - rich and poor subsamples
** M4 and M5 (full model, with 4 interactions)
*============================================

//Simple models, with and without F interactions for reviewer

esttab M4poor M5poor M4rich M5rich ///
 using "5_Output/3_Reg_decomp_html_csv/Table3.csv", replace ///
  b(3) se r2 nobase label not nodepvars   ///
  nonumbers varwidth(55)  ///
  title("Table 3. Wage Regressions, final model with and without interactions, for poor and wealthy subsamples.")

*============================================
**> Possible Appendix Table ** csv
**> ALL Interactions**
*============================================
/// Intermediate outputs in html

esttab regapp using ///
 "5_Output/3_Reg_decomp_html_csv/Appendix.html", replace ///
  wide b(3) se r2 nobase label not nodepvars   ///
  nonumbers varwidth(55)  ///
  mtitles("Full interactions")  ///
  title("Appendix Table. Wage Regressions, fully-fitted model with all interactions.")

view browse file:///$gpgsocioecnomicgrp/5_Output/3_Reg_decomp_html_csv/Appendix.html


// csv
esttab regapp using ///
"5_Output/3_Reg_decomp_html_csv/Appendix_Reg_all_interactions.csv", replace ///
  wide b(3) se r2 nobase label not nodepvars   ///
  nonumbers varwidth(55)  ///
  title("Appendix Table. Wage Regressions, fully-fitted model with all interactions.")


****  End ****

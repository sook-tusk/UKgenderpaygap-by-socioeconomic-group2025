
* Last updated on 27 June 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************

* To be run once to create subfolders.
* Once installed, no need to run again.

cdgpgsocioeconomicgrp

capture mkdir 5_Output

capture cd ./5_Output

capture mkdir 2_Desc_Tables

capture mkdir 3_Reg_decomp_html_csv
capture mkdir 3_Reg_decomp_html_csv/html

capture mkdir 3_Simdecomp
capture mkdir 4_Figures

capture mkdir 4_Word
capture mkdir 4_Word/Regression

*------------------------------
* Check
*------------------------------
cd
dir

*------------------------------
* Return to the proj folder
*------------------------------

cdgpgsocioeconomicgrp


****  End ****

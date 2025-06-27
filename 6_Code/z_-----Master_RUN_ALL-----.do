
* Last updated on 27 June 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************

// This file runs all previous main do files
// in the given sequence.

cdgpgsocioeconomicgrp
cd ./6_Code

* check the list of Do files first to run
	dir

* Run all main do files to replicate
    cdgpgsocioeconomicgrp
do "6_Code/1_EarningsDecile.do"

    cdgpgsocioeconomicgrp
do "6_Code/2a_Regression.do"
    cdgpgsocioeconomicgrp
do "6_Code/2b_Table_Reg.do"

    cdgpgsocioeconomicgrp
do "6_Code/3a_OaxacaDecom.do"
    cdgpgsocioeconomicgrp
do "6_Code/3b_Table_OaxacaDecom.do"

    cdgpgsocioeconomicgrp
do "6_Code/4a_Compute_Simuldecomp.do"


/* End of -----Master_RUN_ALL----- */

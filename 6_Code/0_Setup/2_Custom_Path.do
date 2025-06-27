
* Last updated on 27 June 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************

*------------------------------
* Define user-specific path
*------------------------------

// Starting path (CUSTOMISE THIS PLEASE)
global startingpath "F:/yourpath/Research"


*------------------------------
* Declare the project path (USE AS IT IS)
*------------------------------

global folder  ///
 "UKgenderpaygap-by-socioeconomic-group2025"

global gpgsocioeconomicgrp "$startingpath/$folder"

cd "$startingpath/$folder"

*------------------------------
* > Save (user-specific) project path.
* The workingdir must be installed.
*------------------------------

savecd gpgsocioeconomicgrp, replace

*------------------------------
* > Jump to the current project
*------------------------------
cdgpgsocioeconomicgrp

// Check
pwd

*------------------------------
* > For Launching software (Windows)
*------------------------------
* Choose an appropriate path

// WINDOWS, Installed under Program Files

// global word "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"

// global excel "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"


// WINDOWS, Installed under Program Files (x86)

global word "C:\Program Files (x86)\Microsoft Office\root\Office16\WINWORD.EXE"

global excel "C:\Program Files (x86)\Microsoft Office\root\Office16\EXCEL.EXE"


****  End ****

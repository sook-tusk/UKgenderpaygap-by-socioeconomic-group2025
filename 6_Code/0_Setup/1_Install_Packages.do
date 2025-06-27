
* Last updated on 27 June 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************

* To be run once to install.
* Once installed, no need to run again.

* Update all packages
// adoupdate

*-------------------------------------
* Examine directory for user-written packages
*-------------------------------------
sysdir

*-------------------------------------
* CUSTOMISE sysdir to save user-written packages
* Skip the customisation as necessary
*-------------------------------------
// Check your Stata version and its ado path.
// Ensure the PLUS and PERSONAL folders exist.
// If necessary, create these two folders.


sysdir set PLUS     "C:\Installed_PG\Stata18\ado\plus"
sysdir set PERSONAL "C:\Installed_PG\Stata18\ado\personal"

// For more information, visit here (https://github.com/sook-tusk/Tech_Integrate_Stata_R_with_Editors) and consult the "System directory" section.

*-------------------------------------
* Define user-specific path,
* move directories easily
*-------------------------------------

// search workingdir
net describe workingdir, from(https://jslsoc.sitehost.iu.edu/stata)
net install workingdir

*-------------------------------------
* KOB (oaxaca decomposition)
*-------------------------------------
ssc install oaxaca

*-------------------------------------
* Weighted percentiles
*-------------------------------------
// epctile: install s2s to use epctile,
// requires Stata 16 but Stata14 can install s2s

// search epctile
net describe s2s, from(http://fmwww.bc.edu/RePEc/bocode/s)
net install s2s

// epctile: may not work due to security issues
// findit epctile
// net describe epctile, from(https://staskolenikov.net/stata)
// net install epctile, replace

*-------------------------------------
** saves a matrix as a Stata dataset
** (after running margins)
*-------------------------------------
** svmatf uses svmat2

// search svmat2
net describe dm79, from(http://www.stata.com/stb/stb56)
net install dm79
ssc install svmatf


*-------------------------------------
* convert numeric to string vars
*-------------------------------------
ssc inst sdecode

*-------------------------------------
* seq, to create sequential numbers
*-------------------------------------
// seq is contained in the STB-37 dm44 package.

// search dm44
net describe dm44, from(http://www.stata.com/stb/stb37)
net install dm44

*-------------------------------------
* translates smcl to html,
* view log outputs in a web browser
*-------------------------------------
ssc inst log2html

*-------------------------------------
* Automation
*-------------------------------------

ssc inst estout  // export reg tables to csv

ssc inst asdoc   // export tables to Word



****  End ****

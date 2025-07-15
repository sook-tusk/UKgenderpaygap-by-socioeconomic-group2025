
* Last updated on 15 July 2025

*********************************************
* This analysis file replicates results in
* Gash et al. (2025).

* Reference:
di "Gash, V., Olsen, W., Kim, S., & Zwiener-Collins, N. (2025). Decomposing the barriers to equal pay: Examining differential predictors of the gender pay gap by socio-economic group. Cambridge Journal of Economics, 1–23. https://doi.org/10.1093/cje/beaf025"

*********************************************

// There is no need to run
// "4b_OPTIONAL_simdecomp_prep.do" separately.

// The "4a_Compute_Simuldecomp.do" reads in
// "4b_OPTIONAL_simdecomp_prep.do" as part of computation.


*==========================================
***** Declare variables  *****
*==========================================
// Defined earlier.

*==========================================
*****> Beta coefficients (all sample)  *****
*==========================================
** M4: fully-fitted model**
svy: reg $y $x if retrodata==1
mat b =  e(b)'
capture drop esample
gen esample = e(sample) == 1
tab esample

*==========================================
*****> Means (all sample) *****
*==========================================
* In matrix,
* to add columns use , to append rows use \

* Overall
svy, over(female): mean $y if esample == 1
mat p1 = e(b)'
mat p1 = p1 \ p1[1,1] - p1[2,1]

svy, over(female): mean hourlyrealpay if esample == 1
mat p2 = e(b)'
mat gap = 1 - (p2[2,1] / p2[1,1])
mat p2 = p2 \ gap
mat c = 0\0\0

mat overall = p1, p2, c, c
mat rownames overall = Men Women Difference
    mat list overall

* By sex
svy, subpop(male):   mean $x if esample == 1
mat men = e(b)'
mat add =  0
matname add _cons, rows(1) explicit
mat men =  men \ add

svy, subpop(female): mean $x if esample == 1
mat women = e(b)'
mat women = women \ add

*==========================================
*****> Combine all (all sample)   *****
*==========================================

mat xdiff = men - women
mat temp = (men, women, xdiff, b)
mat temp = overall \ temp
mat colnames temp = Men Women xdiff B
mat simdecomp =  temp

mat list simdecomp

*>#######################################
di "Sub-samples"
*#######################################

forvalues k = 1/2 {

    *==========================================
    *****> Beta coefficients (sub-sample)  *****
    *==========================================
    ** M4: fully-fitted model**
    svy: reg $y $x if group == `k'
    mat b =  e(b)'      /* return list */
    replace esample = e(sample) == 1
    eststo M4
    esttab M4, label varwidth(55)

    *==========================================
    *****> Means (sub-sample) *****
    *==========================================
    * Overall
    svy, over(female): mean $y if group == `k' & esample == 1
    mat p1 = e(b)'
    mat p1 = p1 \ p1[1,1] - p1[2,1]

    svy, over(female): mean hourlyrealpay if group == `k'  & esample == 1
    mat p2 = e(b)'
    mat gap = 1 - (p2[2,1] / p2[1,1])
    mat p2 = p2 \ gap
    mat c = 0\0\0
    mat overall = p1, p2, c, c
    mat rownames overall = Men Women Difference
        mat list overall

    * By sex
    svy, subpop(male): mean $x if group == `k' & esample == 1
    mat men = e(b)'
    mat add =  0
    matname add _cons, rows(1) explicit
    mat men =  men \ add

    svy, subpop(female):mean $x if group == `k' & esample == 1
    mat women = e(b)'
    mat women = women \ add

    *==========================================
    *****> Combine all (sub-sample)   *****
    *==========================================
    mat xdiff = men - women
    mat temp = (men, women, xdiff, b)
    mat temp = overall \ temp
    mat colnames temp = Men`k' Women`k' xdiff`k' B`k'
    mat simdec_temp =  temp
    mat simdecomp_group`k' = simdec_temp

}

//tidy
mat simdecomp_all = (simdecomp, simdecomp_group1, simdecomp_group2)

/* End */

********************************************************************************
** Anika Nerella, Replication of - Maley, Landon, Stevens (2020), JAMA Network Open
* https://doi.org/10.1001/jamanetworkopen.2020.10810
* Data page: https://data.dartmouthatlas.org/eol-chronic/

* STAT5200 Final Project
* 1 of 2 - Pull raw data, clean.
********************************************************************************

* Pull data from Dartmouth Atlas.
* 1 - longitudinal data.
cd $root
copy "https://data.dartmouthatlas.org/downloads/research_files/hrr_eolchronic_dead6699ffs.dta.zip" "$root/hrr_eolchronic_dead6699ffs.dta.zip", replace
copy "https://data.dartmouthatlas.org/downloads/research_files/hrr_eolchronic_dead6699ffs.dta.zip" "$rawdir/hrr_eolchronic_dead6699ffs.dta.zip", replace
unzipfile "$root/hrr_eolchronic_dead6699ffs.dta.zip", replace
copy "$root/hrr_eolchronic_dead6699ffs.dta" "$wddir/chronic_hosp_2008_2019.dta", replace
rm "$root/hrr_eolchronic_dead6699ffs.dta" 
rm "$root/hrr_eolchronic_dead6699ffs.dta.zip"

* 2 - 2010 data with names of HRRs.
* 2014 Care for Chronically Ill by HRR
copy "https://data.dartmouthatlas.org/downloads/tables/DAP_hrr_data_2014.xls" "$rawdir/chronic_ill_2014.xls", replace
import excel using "$rawdir/chronic_ill_2014.xls", clear firstrow case(l) allstring
keep hrr hrrname state
ren hrr geo_code
drop if mi(geo_code) | geo_code == "999"
tempfile hrrnames
save `hrrnames', replace

use $wddir/chronic_hosp_2008_2019, clear
ren *, lower
* Keep only 2010-2016.
keep if inrange(year, 2010, 2016)

* Drop entries for the whole US.
drop if geo_code == "999"

* Merge in HRR names using 2010 file.
merge m:1 geo_code using `hrrnames' // All geocodes merged in successfully.
g concatgeo = hrrname + ", " + state

drop geo_label cohort o_e_ratio uppercl lowercl percentile geo_name cohort_web_label short_label

* Reshape data.
encode eventname, gen(eventid)
reshape wide adjusted_rate eventname crude_rate observed population event_label, i(geo_code year) j(eventid)

ren population1 totpopulation
drop population*
order geo_code hrrname state concatgeo

* Total chronically ill from 2010 - 2016.
qui sum totpopulation
di `r(sum)' // Consistent with paper.
unique geo_code // 306 HRRs.

** Variable crosswalk - 
** hosptalization rate: 34 == percent of deaths occurring in hospital
** hospital with ICU admission: 32 == percent of deaths that included an ICU admission
** hospice: 54 == percent of decedents enrolled in hospice during last two years of life

** Replicate # for entire US.
sum adjusted_rate34 if year == 2010, d
sum adjusted_rate32 if year == 2010, d
sum adjusted_rate54 if year == 2010, d

** Flag highest/lowest hospitalization rates HRRs across all years.
g table1flag = 0
* Lowest 6 -
gsort year adjusted_rate34
replace table1flag = 1 if _n <=6

* Highest 6 -
gsort year -adjusted_rate34
replace table1flag = 1 if _n <=6

* Replace flag for HRR to be included in Table 1 across years.
bys concatgeo: egen fortable1 = max(table1flag)
levelsof concatgeo if fortable1 == 1 // Verifying that HRRs match with table.

qui compress *
save $wddir/cleanhrr_chronic, replace


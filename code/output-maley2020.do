********************************************************************************
** Anika Nerella, Replication of - Maley, Landon, Stevens (2020), JAMA Network Open
* https://doi.org/10.1001/jamanetworkopen.2020.10810
* Data page: https://data.dartmouthatlas.org/eol-chronic/

* STAT5200 Final Project
* 2 of 2 - Replicate tables & figures from paper.
********************************************************************************

local table1 1
local figure1 1

if `figure1' {
	use $wddir/cleanhrr_chronic, clear
	
	* Figure 1 only uses 20 HRRs from 2016 data.
	keep if year == 2016
	
	rename adjusted_rate34 hosp_pct
	rename adjusted_rate53 hospice_pct
	rename totpopulation decedents

* Keep the 20 HRRs with the largest number of decedents
gsort -decedents
keep in 1/20

gen id = _n

* Create color list.
colorpalette tableau, n(20) nograph

* Fixed size categories based on decedent counts
gen decedent_group = .

replace decedent_group = 1 if decedents < 10000
replace decedent_group = 2 if decedents >= 10000  & decedents < 12500
replace decedent_group = 3 if decedents >= 12500  & decedents < 15000
replace decedent_group = 4 if decedents >= 15000 & decedents < 17500
replace decedent_group = 5 if decedents >= 17500

label define decedent_size ///
    1 "<10,000" ///
    2 "12,500" ///
    3 "15,000" ///
    4 "17,500" ///
    5 "20,000" 

label values decedent_group decedent_size

gen marker_size = .

replace marker_size = 1 if decedent_group == 1
replace marker_size = 2 if decedent_group == 2
replace marker_size = 3 if decedent_group == 3
replace marker_size = 4 if decedent_group == 4
replace marker_size = 5 if decedent_group == 5

local plots
local city_legend
local i = 0

* Create one scatter layer for each HRR
forvalues n = 1/20 {

    local ++i

    quietly levelsof hrrname if id == `n', local(city)
    quietly levelsof state if id == `n', local(st)
    local city_label "`city', `st'"

    quietly summarize marker_size if id == `n', meanonly
local ms = r(mean)

if `ms' == 1 local marker "vsmall"
if `ms' == 2 local marker "small"
if `ms' == 3 local marker "medium"
if `ms' == 4 local marker "large"
if `ms' == 5 local marker "vlarge"

	local color `r(p`i')'
	if `n' == 1 local color gs8 // Manually adjust for Boston scatter marker color.

    local plots `plots' ///
        (scatter hosp_pct hospice_pct  if id == `n', ///
            msymbol(circle) ///
            mcolor(`color') ///
            msize(`marker'))

}


* Use the first observation as a harmless location for legend-only markers
gen legend_marker = id == 1

local plots `plots' ///
    (scatter hosp_pct hospice_pct if id == 1, ///
        msymbol(circle) mcolor(gs8) msize(vsmall)) ///
    (scatter hosp_pct hospice_pct if id == 1, ///
        msymbol(circle) mcolor(gs8) msize(small)) ///
    (scatter hosp_pct hospice_pct if id == 1, ///
        msymbol(circle) mcolor(gs8) msize(medium)) ///
    (scatter hosp_pct hospice_pct if id == 1, ///
        msymbol(circle) mcolor(gs8) msize(large)) ///
    (scatter hosp_pct hospice_pct if id == 1, ///
        msymbol(circle) mcolor(gs8) msize(vlarge))
		
	
	twoway `plots', ///
    xlabel(30(10)70, ///
        labsize(vsmall) ///
        format(%2.0f) ///
        grid) ///
    ylabel(10(10)40, ///
        labsize(vsmall) ///
        format(%2.0f) ///
        grid) ///
    ytitle("End-of-life hospitalization rate, %", ///
        size(vsmall)) ///
    xtitle("End-of-life hospice enrollment rate, %", ///
        size(vsmall)) ///
    title("Hospital Referral Region (HRR)–Level Rates of Hospitalization and Hospice Use", ///
        size(small) ///
        span) ///
    subtitle("At the End of Life in the US, 2016", ///
        size(vsmall) ///
        span) ///
		legend(order( ///
		- "HRR" ///
		2 "Atlanta, GA" ///
		12 "Baltimore, MD" ///
		15 "Birmingham, AL" ///
		1 "Boston, MA" ///
		4 "Camden, NJ" ///
		19 "Charlotte, NC" ///
		18 "Columbus, OH" ///
		10 "Dallas, TX" ///
		3 "East Long Island, NY" ///
		13 "Fort Lauderdale, FL" ///
		6 "Houston, TX" ///
		11 "Indianapolis, IA" ///
		9 "Los Angeles, CA" ///
		16 "Manhattan, NY" ///
        14 "Nashville, TN" ///
        20 "Orlando, FL"   ///
		7 "Philadelphia, PA" ///
        5 "Phoenix, AZ" ///
        8 "St. Louis, MO" ///
		17 "Washington, DC" ///
        - "No. of deaths" ///
        21 "<10,000" ///
        22 "12,500" ///
        23 "15,000" ///
        24 "17,500" ///
        25 "20,000") ///
        cols(1) ///
        position(3) ///
        ring(1) ///
        size(vsmall) ///
        region(lcolor(none)))
	
	graph export $outdir/figure1_replication.png, as(png) replace 
	
	
}



if `table1' {

use $wddir/cleanhrr_chronic, clear

* Calculate 2010 all-HRR summary statistics
preserve

keep if year == 2010

centile adjusted_rate34, centile(25 50 75)
local hosp_p25 = r(c_1)
local hosp_p50 = r(c_2)
local hosp_p75 = r(c_3)

centile adjusted_rate32, centile(25 50 75)
local icu_p25 = r(c_1)
local icu_p50 = r(c_2)
local icu_p75 = r(c_3)

centile adjusted_rate54, centile(25 50 75)
local hospice_p25 = r(c_1)
local hospice_p50 = r(c_2)
local hospice_p75 = r(c_3)

restore

* 2016 all-HRR summary statistics
preserve

keep if year == 2016

centile adjusted_rate34, centile(25 50 75)
local hosp16_p25 = r(c_1)
local hosp16_p50 = r(c_2)
local hosp16_p75 = r(c_3)

centile adjusted_rate32, centile(25 50 75)
local icu16_p25 = r(c_1)
local icu16_p50 = r(c_2)
local icu16_p75 = r(c_3)

centile adjusted_rate54, centile(25 50 75)
local hospice16_p25 = r(c_1)
local hospice16_p50 = r(c_2)
local hospice16_p75 = r(c_3)

restore

* Keep only top/bottom highest/lowest.
keep if fortable1 == 1
gsort year -adjusted_rate34 
g rank_high = _n if year == 2010

gsort year adjusted_rate34 
g rank_low = _n if year == 2010

recode rank_high (. = 0)
recode rank_low (. = 0)

* Replace within HRR over years.
bys geo_code: ereplace rank_high = max(rank_high)
bys geo_code: ereplace rank_low = max(rank_low)

* Initialize putexcel.
putexcel set "$outdir/table1_replication.xlsx", ///
    replace sheet("Table 1")

* Title
putexcel A1:I1 = ///
    ("Table 1. Health Care Resource Use From 2010 to 2016 Among HRRs With the Highest and Lowest 2010 End-of-Life Hospitalization Rates"), ///
    merge

putexcel A1:I1, bold font("Arial", 11) ///
    hcenter vcenter

* Column headers
putexcel A3 = ("HRR")
putexcel B3 = ("No. of decedents")
putexcel D3 = ("Hospitalization, %")
putexcel F3 = ("Hospitalization with ICU admission, %")
putexcel H3 = ("Hospice enrollment, %")

putexcel B4 = ("2010")
putexcel C4 = ("2016")
putexcel D4 = ("2010")
putexcel E4 = ("2016")
putexcel F4 = ("2010")
putexcel G4 = ("2016")
putexcel H4 = ("2010")
putexcel I4 = ("2016")

putexcel A3:I4, bold border(bottom) ///
    hcenter vcenter txtwrap
	
* All-HRR row - 
putexcel A5 = ("All HRRs, median (IQR)")
putexcel B5 = (1107702)
putexcel C5 = (1058187)

putexcel D5 = ///
    (string(`hosp_p50', "%9.1f") + " (" + ///
     string(`hosp_p25', "%9.1f") + "-" + ///
     string(`hosp_p75', "%9.1f") + ")")

putexcel E5 = ///
    (string(`hosp16_p50', "%9.1f") + " (" + ///
     string(`hosp16_p25', "%9.1f") + "-" + ///
     string(`hosp16_p75', "%9.1f") + ")")

putexcel F5 = ///
    (string(`icu_p50', "%9.1f") + " (" + ///
     string(`icu_p25', "%9.1f") + "-" + ///
     string(`icu_p75', "%9.1f") + ")")

putexcel G5 = ///
    (string(`icu16_p50', "%9.1f") + " (" + ///
     string(`icu16_p25', "%9.1f") + "-" + ///
     string(`icu16_p75', "%9.1f") + ")")

putexcel H5 = ///
    (string(`hospice_p50', "%9.1f") + " (" + ///
     string(`hospice_p25', "%9.1f") + "-" + ///
     string(`hospice_p75', "%9.1f") + ")")

putexcel I5 = ///
    (string(`hospice16_p50', "%9.1f") + " (" + ///
     string(`hospice16_p25', "%9.1f") + "-" + ///
     string(`hospice16_p75', "%9.1f") + ")")
	 
	 	
	
local row = 7

putexcel A`row' = ("HRRs with highest end-of-life hospitalization rate"), bold
local row = `row' + 1

sort rank_high

forvalues i = 1/6 {

    quietly summarize rank_high if rank_high == `i', meanonly
    if r(N) == 0 continue

    quietly levelsof concatgeo if rank_high == `i', local(hrr)

    quietly summarize totpopulation if rank_high == `i' & year == 2010, meanonly
    local d10 = r(mean)

    quietly summarize totpopulation if rank_high == `i' & year == 2016, meanonly
    local d16 = r(mean)

    quietly summarize adjusted_rate34 if rank_high == `i' & year == 2010, meanonly
    local h10 = r(mean)

    quietly summarize adjusted_rate34 if rank_high == `i' & year == 2016, meanonly
    local h16 = r(mean)

    quietly summarize adjusted_rate32 if rank_high == `i' & year == 2010, meanonly
    local i10 = r(mean)

    quietly summarize adjusted_rate32 if rank_high == `i' & year == 2016, meanonly
    local i16 = r(mean)

    quietly summarize adjusted_rate54 if rank_high == `i' & year == 2010, meanonly
    local s10 = r(mean)

    quietly summarize adjusted_rate54 if rank_high == `i' & year == 2016, meanonly
    local s16 = r(mean)

		
putexcel  A`row' = (`hrr')  ///
    B`row' = (`d10') ///
    C`row' = (`d16') ///
    D`row' = (`h10') ///
    E`row' = (`h16') ///
    F`row' = (`i10') ///
    G`row' = (`i16') ///
    H`row' = (`s10') ///
    I`row' = (`s16')

    local row = `row' + 1
}

local row = `row' + 1

putexcel A`row' = ("HRRs with lowest end-of-life hospitalization rate"), bold
local row = `row' + 1

sort rank_low

forvalues i = 1/6 {

    quietly summarize rank_low if rank_low == `i', meanonly
    if r(N) == 0 continue

    quietly levelsof concatgeo if rank_low == `i', local(hrr)

    quietly summarize totpopulation if rank_low == `i' & year == 2010, meanonly
    local d10 = r(mean)

    quietly summarize totpopulation if rank_low == `i' & year == 2016, meanonly
    local d16 = r(mean)

    quietly summarize adjusted_rate34 if rank_low == `i' & year == 2010, meanonly
    local h10 = r(mean)

    quietly summarize adjusted_rate34 if rank_low == `i' & year == 2016, meanonly
    local h16 = r(mean)

    quietly summarize adjusted_rate32 if rank_low == `i' & year == 2010, meanonly
    local i10 = r(mean)

    quietly summarize adjusted_rate32 if rank_low == `i' & year == 2016, meanonly
    local i16 = r(mean)

    quietly summarize adjusted_rate54 if rank_low == `i' & year == 2010, meanonly
    local s10 = r(mean)

    quietly summarize adjusted_rate54 if rank_low == `i' & year == 2016, meanonly
    local s16 = r(mean)

    putexcel A`row' = (`hrr') ///
    B`row' = (`d10') ///
    C`row' = (`d16') ///
    D`row' = (`h10') ///
    E`row' = (`h16') ///
    F`row' = (`i10') ///
    G`row' = (`i16') ///
    H`row' = (`s10') ///
    I`row' = (`s16')

    local row = `row' + 1
}	


* Final table formatting - 
putexcel A1:I30, font("Arial", 10) txtwrap vcenter

putexcel A3:I4, border(bottom, thin)
putexcel A5:I5, border(bottom, thin)

putexcel B5:C30, nformat("#,##0")
putexcel D5:I30, nformat("0.0")

putexcel save

* Change column widths.
mata: xl = xl()
mata: xl.load_book("$outdir\table1_replication.xlsx")
* widen column 1
foreach col of numlist 1 {
    mata: xl.set_column_width(`col',`col',29)
}

* widen other columns
foreach col of numlist 2/9 {
    mata: xl.set_column_width(`col',`col',20)
}
mata: xl.close_book()


}






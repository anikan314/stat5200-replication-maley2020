********************************************************************************
** Anika Nerella, Replication of - Maley, Landon, Stevens (2020), JAMA Network Open
* https://doi.org/10.1001/jamanetworkopen.2020.10810
* Data page: https://data.dartmouthatlas.org/eol-chronic/

* STAT5200 Final Project
* 0 of 2 - MASTER - run this file to run entire project.
********************************************************************************

clear all
set more off
set seed 12345
cap ssc install unique
cap ssc install gtools
cap ssc install ereplace
ssc install palettes, replace
ssc install colrspace, replace

* Filepaths.
global root "C:\Users\anerella\Downloads"
global rawdir "$root/rawdata"
global wddir "$root/workingdata"
global outdir "$root/output"
capture mkdir "${outdir}"
capture mkdir "${rawdir}"
capture mkdir "${wddir}"

* Run data pull and cleaning.
do $root/replication-maley2020.do

* Run replication of tables and figures.
do $root/output-maley2020.do
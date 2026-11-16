# Nerella - STAT5200 - Final Replication.
Replication of Maley, Landon, Stevens (2020) - Regional Variation in Use of End-of-Life Care

This repository contains a Stata replication of selected results from:

> Maley A, Landon BE, Stevens R. Regional Variation in Use of End-of-Life Care at Hospitals, Intensive Care Units, and Hospices Among Older Adults With Chronic Illness in the US, 2010 to 2016. *JAMA Network Open*. 2020;3(7):e2010896.

**DOI:** [10.1001/jamanetworkopen.2020.10810](https://doi.org/10.1001/jamanetworkopen.2020.10810)<br>
**Article:** [JAMA Network Open](https://jamanetwork.com/journals/jamanetworkopen/fullarticle/2768393)<br>
**Dartmouth Atlas data page:** [Care of the Chronically Ill](https://data.dartmouthatlas.org/eol-chronic/)

# Overview

The project uses Dartmouth Atlas Hospital Referral Region (HRR) data to reproduce all of the descriptive results from the paper for 2010–2016, including:

- HRR-level end-of-life hospitalization rates;
- HRR-level rates of hospitalization involving an ICU admission;
- HRR-level hospice-enrollment rates;
- the all-HRR median and interquartile range comparisons between 2010 and 2016;
- the HRRs with the highest and lowest 2010 end-of-life hospitalization rates; and
- a 2016 scatterplot for the 20 HRRs with the largest numbers of decedents.

# Repository Structure

```text
.
├── code/
│   ├── master-maley2020.do       # Runs the complete workflow
│   ├── setup-maley2020.do  # Downloads, imports, cleans, and reshapes data
│   └── output-maley2020.do       # Creates the replication table and figure
├── rawdata/
│   └── hrr_eolchronic_dead6699ffs.dta.zip
├── output/
│   └── figure1_replication.png
└── README.md
```

An intermediate cleaned dataset and the output files are generated in a `workingdata/` and `output/` directory when the code is run.

# Data

The main data source is the Dartmouth Atlas Research Data file - Care for the Chronically Ill (Last Two Years of Life) - aggregate from 2008-2019. The cleaning script also downloads the Dartmouth Atlas 2014 HRR file to obtain HRR names and states. The code verifies the 7,425,913 Medicare beneficiaries diagnosed with at least 1 of 9 chronic illnesses most commonly associated with death in the Medicare-eligible population who died from 2010 through 2016 as stated in the paper.

# Software Requirements
Stata, with all necessary package installations specified in the code.

# To execute:
Download this repository and open the master-maley2020.do. Adjust the root directory and run the master script, which runs the setup and output files.


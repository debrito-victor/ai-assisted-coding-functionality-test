# App Functionality Test

Data and code for the functionality test described in:

de Brito, V. Using AI-Assisted Coding to Build Digital Tools for Natural History Collections. Submitted to Natural History Collections and Museomics

---

## Overview

Repository with the data exports and R code used to test the functionality of two web applications developed with AI-assisted coding described in the paper.

---

## Repository Structure

README.md – README file

app_portal.zip – CSV exports from the AI App Portal https://debrito-victor.github.io/cornell-specimen-explorer/ (50 files)  
  filtered_specimens_01.csv  
  filtered_specimens_02.csv  
  ...  
  filtered_specimens_50.csv  

specify_portal.zip – CSV exports from the CUMV Specify Portal https://webportal.specifycloud.org/cornellfishes/ (50 files)  
  01.csv  
  02.csv  
  ...  
  50.csv  

compare_cumv.R – R script for the comparison analysis
  
fish_collection.csv – Copy from the fish database to pick a random genus/species combination from  

random_taxon.csv – List of taxon in the queries  

cumv_comparison_results.csv – Appendix 1: per-query comparison summary  

cumv_maps.pdf – Appendix 2: PDF files with maps generated from the AI Portal https://debrito-victor.github.io/cumv-map/ (Appendix 2A) and from the localities exported from the CUMV Specify 7 database (Appendix 2B)

## Output

### `cumv_comparison_results.csv`

Summary table produced by `compare_cumv.R` with one row per query:

| Column | Description |
|---|---|
| `Query` | Query number (01–50) |
| `Status` | `MATCH` or `MISMATCH` |
| `Unique_App` | Number of unique CUMV numbers in the AI App Portal result |
| `Unique_Specify` | Number of unique CUMV numbers in the Specify Portal result |
| `Only_In_App` | CUMV numbers present in the AI App Portal but absent in Specify |
| `Only_In_Specify` | CUMV numbers present in Specify but absent in the AI App Portal |

---

## License

Data are from the Cornell University Museum of Vertebrates (CUMV) fish collection and are subject to the collection's data use policies.
Code in this repository is released under the [MIT License](https://opensource.org/licenses/MIT).

---

## Contact

Victor de Brito
Cornell University
victordebrito@cornell.edu

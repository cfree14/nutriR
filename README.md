nutriR: Nutritional intake functions for R
======================================================================

Installation
------------

The "nutriR" R package can be installed from GitHub with:

``` r
# Run if you don't already have devtools installed
install.packages("devtools")

# Run once devtools is successfully installed
devtools::install_github("cfree14/nutriR", force=T, build_vignettes=T)
library(nutriR)
```

Overview
---------
Knowledge of human diets and nutrient intakes is critical to understanding and improving human nutrition, food security, and many other public health outcomes, but research in this area has been limited by a lack of centralized, standardized, and publicly available dietary intake data. We fill this gap by developing a comprehensive and publicly available database of global dietary data and using it to derive habitual nutrient intake distributions for more than 50 micronutrients and macronutrients spanning 40 subnational populations (sex-age groups) in 30 countries. 

These data are critical to research and policy related to public health. For example, these data can be used to: (1) determine the risk of nutrient deficiency, nutrient overload, or chronic disease risk within subpopulations and to identify vulnerable groups; (2) estimate the magnitude of dietary shifts required to reduce adverse health impacts; (3) evaluate and design interventions for achieving these shifts; and (4) optimize sustainable food systems to simultaneously consider the environmental impact and nutrient supply of dietary intake patterns. 

This package provides the parameters describing the habitual intake distributions estimated by Passarelli et al. (in prep) as well as various reference values datasets that can be used to estimate prevalence of nutrient intakes that are either too low or too high. It also includes functions for estimating (1) properties of these distributions, (2) prevalence of inadequate intakes or intakes that are too high, and (3) magnitudes of shifts required to close nutrient gaps. Additionally, it includes functions for visualizing habitual intake distributions and for shifting habitual intake distributions in response to a simulated intervention (or recalibration).

Datasets
---------

The package includes the following datasets:

- Dietary reference intakes (DRIs) from NAS (2020): `?dris`
- Dietary reference values (DRVs) from EFSA (2019): `?drvs`
- Nutrient reference values (NRVs) from Allen et al. (2020): `?nrvs`
- Subnational habitual intake distribution parameters from Passarelli et al. (in prep): `?dists_full`

Allen, L.H., Carriquiry, A.L., Murphy, S.P. (2020) Perspective: proposed harmonized nutrient reference values for populations. Advances in Nutrition 11(3): 469-483.

EFSA (2019) Dietary Reference Values for Nutrients Summary Report. European Food Safety Authority (EFSA) Supporting Publication 2017:e15121. doi:10.2903/sp.efsa.2017.e15121

EFSA (2018) Overview on Tolerable Upper Intake Levels as derived by the Scientific Committee on Food (SCF) and the EFSA Panel on Dietetic Products, Nutrition and Allergies (NDA). European Food Safety Authority (EFSA).

Food and Nutrition Board, National Academy of Sciences, Institute of Medicine (2020) Dietary Reference intakes: Estimated Average requirements and recommended intakes. Accessed at https://www.nal.usda.gov/sites/default/files/fnic_uploads//recommended_intakes_individuals.pdf.

Functions
---------

The package includes the following functions:

- Extract subnational intake distributions of interest: `?get_dists`
- Plot subnational intake distributions of interest: `?plot_dists`
- Generate subnational intake distributions for independent plotting: `?generate_dists`
- Shift subnational intake distributions of interest: `?shift_dists`
- Calculate the prevalence of inadequate nutrient intakes (SEVs): `?sev`
- Calculate the percent of population above the tolerable upper limit: `?above_ul`
- Calculate the shift required to obtain a target prevalence of inadequate intake: `?shift_req`
- Calculate the mean of intake distributions: `?mean_dist`
- Calculate the coefficient of variation (CV) and variance of intake distributions: `?cv`, `?variance`
- Calculate the skewness and kurtosis of intake distributions: `?skewness`, `?kurtosis`
- Calculate percent overlap (Bhattacharyya coefficient) between intake distributions: `?overlap`

Vigenette
---------

A vignette illustrating the functionality of the "nutriR" package is available here: 
https://marine.rutgers.edu/~cfree/wp-content/uploads/nutriR-vignette.html

R Shiny web application
---------

An R Shiny web application for exploring subnational nutrient intake distribtions is available here: 
https://emlab-ucsb.shinyapps.io/nutriR/

Citation
------------

Please cite the R package functions as:

* Free CM, Passarelli S, Allen LH, Beal T, Biltoft-Jensen AP, Bromage S, Cao L, Castellanos-Guitiérrez A, Christensen T, Crispim SP, Dekkers A, De Ridder K, Gicevic S, Lee C, Li Y, Moursi M, Moyersoen I,  Batis C, Schmidhuber J,  Shepon A, Viana DF, Golden CD (2021) nutriR: Nutritional intake functions for R. Available at: https://github.com/cfree14/nutriR

Please cite the data served in the R package as:

* Passarelli S, Free CM, Allen LH, Beal T, Biltoft-Jensen AP, Bromage S, Cao L, Castellanos-Guitiérrez A, Christensen T, Crispim SP, Dekkers A, De Ridder K, Gicevic S, Lee C, Li Y, Moursi M, Moyersoen I,  Batis C, Schmidhuber J,  Shepon A, Viana DF, Golden CD (in prep) Estimating national and sub-national habitual nutrient intake distributions of global diets. _Near submission_.


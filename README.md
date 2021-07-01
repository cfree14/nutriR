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
Coming soon.


Datasets
---------

The package includes the following datasets:

- Dietary reference intakes (DRIs) from NAS (2020): `?dris`
- Nutrient reference values (NRVs) from Allen et al. (2020): `?nrvs`
- Subnational habitual intake distribution parameters from Passarelli et al. (in prep): `?dists_full`

Allen, L.H., Carriquiry, A.L., Murphy, S.P. (2020) Perspective: proposed harmonized nutrient reference values for populations. Advances in Nutrition 11(3): 469-483.

Food and Nutrition Board, National Academy of Sciences, Institute of Medicine (2020) Dietary Reference intakes: Estimated Average requirements and recommended intakes. Accessed at https://www.nal.usda.gov/sites/default/files/fnic_uploads//recommended_intakes_individuals.pdf.

Functions
---------

The package includes the following functions:

- Extract subnational intake distributions of interest: `?get_dists`
- Plot subnational intake distributions of interest: `?plot_dists`
- Generate subnational intake distributions for independent plotting: `?generate_dists`
- Shift subnational intake distributions of interest: `?shift_dists`
- Calculate the prevalence of inadequate nutrient intakes (SEVs): `?sev`
- Calculate the shift required to obtain a target prevalence of inadequate intake: `?shift_req`
- Calculate the mean of intake distributions: `?mean_dist`
- Calculate the coefficient of variation (CV) and variance of intake distributions: `?cv`, `?variance`
- Calculate the skewness and kurtosis of intake distributions: `?skewness`, `?kurtosis`
- Calculate percent overlap (Bhattacharyya coefficient) between intake distributions: `?overlap`

Vigenette
---------

A vignette illustrating the functionality of the "nutriR" package is available here: 
https://marine.rutgers.edu/~cfree/wp-content/uploads/nutriR-vignette.html

Citation
------------

Please cite the R package functions as:

* Free CM, Passarelli S, Beal T, Batis Reuvalcaba C, Berger N, Bromage S, Cao L, Castellanos-Guitiérrez A, Crispim S, Shepon A, Lee C, Li Y, Moursi M, Moyersoen I, Schmidhuber J, Gicevic S, Golden CD (2021) nutriR: Nutritional intake functions for R. Available at: https://github.com/cfree14/nutriR

Please cite the data served in the R package as:

* Passarelli S, Free CM, Beal T, Batis Reuvalcaba C, Berger N, Bromage S, Cao L, Castellanos-Guitiérrez A, Crispim S, Shepon A, Lee C, Li Y, Moursi M, Moyersoen I, Schmidhuber J, Gicevic S, Golden CD (in prep) Global modeling of subnational habitual nutrient intake distributions. In prep.


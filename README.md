nutriR: Nutritional intake functions for R
======================================================================

Installation
------------

The "nutriR" R package can be installed from GitHub with:

``` r
# Run if you don't already have devtools installed
install.packages("devtools")

# Run once devtools is successfully installed
devtools::install_github("cfree14/nutriR", force=T)
library(nutriR)
```

Overview
---------
Coming soon.


Datasets
---------

The package includes the following datasets:

- Dietary reference intakes (DRIs): `?dris`
- Subnational habitual intake distribution parameters: `?dists_full`


Functions
---------

The package includes the following functions:

- Extract subnational intake distributions of interest: `?get_dists`
- Plot subnational intake distributions of interest: `?plot_dists`
- Generate subnational intake distributions for independent plotting: `?generate_dists`
- Shift subnational intake distributions of interest: `?shift_dists`
- Calculate summary exposure values (SEVs; a.k.a., nutrient deficiencies): `?sev`
- Calculate the mean of intake distributions: `?mean_dist`
- Calculate the coefficient of variation (CV) and variance of intake distributions: `?cv`, `?variance`
- Calculate the skewness and kurtosis of intake distributions: `?skewness`, `?kurtosis`
- Calculate percent overlap (Bhattacharyya coefficient) between intake distributions: `?overlap`

Vigenette
---------

A vignette illustrating the functionality of the "nutriR" package is available here: coming soon.

Citation
------------

Please cite the R package functions as:

* Free CM, Passarelli S, Shepon A, Lee C, Moursi M, Cao L, Li Y, Crispim S, Schmidhuber J, Bromage S, Beal T, Golden CD (2021) nutriR: Nutritional intake functions for R. Available at: https://github.com/cfree14/nutriR

Please cite the data served in the R package as:

* Passarelli S, Free CM, Shepon A, Lee C, Moursi M, Cao L, Li Y, Crispim S, Schmidhuber J, Bromage S, Beal T, Golden CD (in prep) Global modeling of subnational habitual nutrient intake distributions. In prep.


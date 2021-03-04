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
library(wcfish)
```

Overview
---------


Datasets
---------



Functions
---------


Description
---------

The R package provides subnational nutrient distributions for the following 9 macronutrients and 19 micronutrients.

__Macronutrients (9 total)__
* Energy (kcal)
* Protein (g)
* Carbohydrate (g)
* Fat (g)
* Beta carotene (mcg)
* Alcohol (g)
* Added sugar (g)
* Saturated fat (g)
* Total sugars (g)

__Minerals (9 total)__
* Choline (mg)
* Copper (mg)
* Iodine (mg)
* Magnesium (mg)
* Manganese (mg)
* Phosphorus (mg)
* Potassium (mg)
* Selenium (mg)
* Sodium (mg)

__Vitamins (10 total)__
* Vitamin A (mcg RAE)
* Vitamin B6 (mg)
* Vitamin B12 (mcg)
* Vitamin C (mg)
* Vitamin D (mcg)
* Vitamin E (mg)
* Thiamin (Vitamin B1) (mg)
* Riboflavin (Vitamin B2) (mg)
* Niacin (Vitamin B3) (mg)
* Folate (Vitamin B9) (mcg)

The data come from the following 21 countries but can get extrapolated to other countries based on nearest neighbor associations.

North America (3 countries)
* Canada
* Mexico
* USA

South America (1 country)
* Bolivia

Africa (5 countries)
* Burkina Faso
* Ethiopia
* Kenya
* Uganda
* Zambia

Europe (8 countries)
* Bosnia
* Bulgaria
* Estonia
* Italy
* Netherlands
* Portugal
* Romania
* Sweden

Asia (4 countries)
* Bangladesh
* China
* Lao
* Philippines


Citation
------------

Parrarelli et al. Global modelling of subnational nutrient distributions. In prep.

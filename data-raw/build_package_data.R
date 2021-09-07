
# Packages
library(tidyverse)
library(countrycode)

# Our data
#####################################################################################

# Read distributions
dists_full <- readRDS("/Users/cfree/Dropbox/Chris/UCSB/projects/nutrition/subnational_nutrient_distributions/data/nutrient_intake_distributions_22countries_expanded.Rds") %>%
  filter(best_dist!="none")

# Save for internal use
usethis::use_data(dists_full, overwrite = T)

# Other data
#####################################################################################

# Read RDIs (IOM/NASEM)
dris <- readRDS("/Users/cfree/Dropbox/Chris/UCSB/projects/nutrition/nutrient_endowment/data/ears/data/dietary_reference_intake_data.Rds")
usethis::use_data(dris, overwrite = T)

# Read NRVs (Allen et al. 2020)
nrvs <- readRDS("/Users/cfree/Dropbox/Chris/UCSB/projects/nutrition/subnational_nutrient_distributions/data/dris/processed/Allen_etal_2020_nrvs.Rds")
usethis::use_data(nrvs, overwrite = T)

# Read DRVs (EFSA)
drvs <- readxl::read_excel("/Users/cfree/Dropbox/Chris/UCSB/projects/nutrition/subnational_nutrient_distributions/data/dris/raw/efsa/EFSA_2019_dris_formatted.xlsx")
usethis::use_data(drvs, overwrite = T)


# Packages
library(tidyverse)
library(countrycode)

# Internal data
#####################################################################################

# Read distributions
dists_full_orig <- readRDS("/Users/cfree/Dropbox/Chris/UCSB/projects/nutrition/Health-Benefit-Calculation-BFA/data/intakes/output/intake_distributions_for_all_cosimo_countries.Rds")

# Format data
dists_full <- dists_full_orig %>%
  # Rename
  rename(country=country_name, iso3=country_iso3) %>%
  # Arrange
  select(iso3, country, everything())

# Save for internal use
usethis::use_data(dists_full, internal = TRUE, overwrite = T)

# External data
#####################################################################################

# Read RDIs
dris <- readRDS("/Users/cfree/Dropbox/Chris/UCSB/projects/nutrition/nutrient_endowment/data/ears/data/dietary_reference_intake_data.Rds")
usethis::use_data(dris, overwrite = T)

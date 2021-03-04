

# Read distributions
dists_full <- readRDS("/Users/cfree/Dropbox/Chris/UCSB/projects/nutrition/Health-Benefit-Calculation-BFA/data/intakes/output/intake_distributions_expanded_13countries.Rds")

# Save for internal use
usethis::use_data(dists_full, internal = TRUE, overwrite = T)

# Save for external use

# Read RDIs
dris <- readRDS("/Users/cfree/Dropbox/Chris/UCSB/projects/nutrition/nutrient_endowment/data/ears/data/dietary_reference_intake_data.Rds")
usethis::use_data(dris, overwrite = T)

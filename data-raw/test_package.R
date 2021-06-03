
# Packages
library(nutriR)
library(tidyverse)

# Get distributions
dists <- nutriR::get_dists(isos=c("USA", "GHA", "FRA", "CHN"), nutrients=c("Zinc"), sexes="F", ages=20:40)

# Plot and compare distributions
nutriR::plot_dists(dists)

# Generate distribution
dists <- nutriR::get_dists(isos=c("USA", "GHA"), nutrients=c("Iron"), sexes="MF", ages=20:40)
dists_sim <- nutriR::generate_dists(dists)


# Shift distribution (coming soon!)
shift_dist(shape=NULL, rate=NULL,
           meanlog=NULL, sdlog=NULL,
           to=NULL, by=NULL, plot=T)

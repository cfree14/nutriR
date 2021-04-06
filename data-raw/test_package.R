

# Get distributions
dists <- nutriR::get_dists(isos=c("USA", "GHA"), nutrients=c("Iron"), sexes="MF", ages=20:40)

# Plot and compare distributions
nutriR::plot_dists(dists)

# Generate distribution
dists <- nutriR::get_dists(isos=c("USA", "GHA"), nutrients=c("Iron"), sexes="MF", ages=20:40)
dists_sim <- nutriR::generate_dists(dists)

#' Generate subnational nutrient intake distributions
#'
#' This function generates data for plotting subnational nutrient intake distributions. It is provided a dataframe generated from the get_dists() function.
#'
#' @param dists A data frame of nutrient distributions
#' @return A dataframe
#' @example
#' dists <- nutriR::get_dists(isos=c("USA", "GHA"), nutrients=c("Iron"), sexes="MF", ages=20:40)
#' dists_sim <- nutriR::generate_dists(dists)
#' @export
generate_dists <- function(dists){

  # Generate density lines from distribution
  dist_data <- purrr::map_df(1:nrow(dists), function(i){

    # Distribution to do
    dist_do <- dists$best_dist[i]
    iso_do <- dists$iso3[i]
    country_do <- dists$country[i]
    nutrient_do <- dists$nutrient[i]
    sex_do <- dists$sex[i]
    age_group_do <- dists$age_group[i]

    # Simulation range
    xmin <- 0

    # If gamma
    if(dist_do=="gamma"){

      # Extract parameters
      shape <- dists$g_shape[i]
      rate <- dists$g_rate[i]

      # Set maximum value
      xmax <- qgamma(0.9999, shape=shape, rate=rate)

      # Build curve
      x <- seq(xmin, xmax, length.out = 1000)
      y <- dgamma(x, shape=shape, rate=rate)
      # plot(y ~ x)

      # Build data frame
      df <- tibble(country=country_do,
                   nutrient=nutrient_do,
                   sex=sex_do,
                   age_group=age_group_do,
                   intake=x,
                   density=y)

    }

    # If log-normal
    if(dist_do=="log-normal"){

      # Extract parameters
      meanlog <- dists$ln_meanlog[i]
      sdlog <- dists$ln_sdlog[i]

      # Set maximum value
      xmax <- qlnorm(0.99, meanlog=meanlog, sdlog=sdlog)

      # Build curve
      x <- seq(xmin, xmax, length.out = 200)
      y <- dlnorm(x, meanlog=meanlog, sdlog=sdlog)
      # plot(y ~ x)

      # Build data frame
      df <- tibble(iso=iso_do,
                   country=country_do,
                   nutrient=nutrient_do,
                   sex=sex_do,
                   age_group=age_group_do,
                   intake=x,
                   density=y)

    }

    # Return
    df

  })

  # Return
  return(dist_data)

}

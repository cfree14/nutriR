#' Calculate the percent overlap between two habitual intake distributions
#'
#' This function calculates the percent overlap between two habitual intake distributions. It handles combinations of gamma and log-normal distributions. The percent overlap is calculated as the Bhattacharyya coefficient.
#'
#' @param dist1 List containing the named distribution parameters for distribution A
#' @param dist2 List containing the named distribution parameters for distribution B
#' @param plot Boolean (TRUE/FALSE) indicating whether to plot the distributions and overlap
#' @return The percent overlap in the two distributions
#' @examples
#' overlap(dist1=list(shape=2, rate=2), dist2=list(shape=2, rate=2), plot=T) # same distribution
#' overlap(dist1=list(shape=2, rate=2), dist2=list(shape=3, rate=2), plot=T) # slighly different
#' overlap(dist1=list(shape=2, rate=2), dist2=list(meanlog=0.5, sdlog=0.4), plot=T) # slightly different
#' overlap(dist1=list(meanlog=0.5, sdlog=0.4), dist2=list(shape=2, rate=2), plot=T) # slightly different
#' overlap(dist1=list(shape=2, rate=2), dist2=list(shape=15, rate=4), plot=T) # more different
#' overlap(dist1=list(shape=2, rate=2), dist2=list(shape=30, rate=4), plot=T) # very different
#' @export
overlap <- function(dist1, dist2, plot=F){

  # An example where you get:
  # "the integral is probably divergent"
  # dist1 <- list(meanlog=7.60488, sdlog=0.4692323); dist2 <- list(meanlog=2.969439, sdlog=0.6529212); plot <- T

  # Build distribution 1
  dist1_type <- ifelse("shape" %in% names(dist1), "gamma", "log-normal")
  if(dist1_type=="gamma"){
    shape1 <- dist1$shape
    rate1 <- dist1$rate
    dist1_func <- function(x){dgamma(x, shape=shape1, rate=rate1)}
  }else{
    meanlog1 <- dist1$meanlog
    sdlog1 <- dist1$sdlog
    dist1_func <- function(x){dlnorm(x, sdlog=sdlog1, meanlog=meanlog1)}
  }

  # Build distribution 2
  dist2_type <- ifelse("shape" %in% names(dist2), "gamma", "log-normal")
  if(dist2_type=="gamma"){
    shape2 <- dist2$shape
    rate2 <- dist2$rate
    dist2_func <- function(x){dgamma(x, shape=shape2, rate=rate2)}
  }else{
    meanlog2 <- dist2$meanlog
    sdlog2 <- dist2$sdlog
    dist2_func <- function(x){dlnorm(x, sdlog=sdlog2, meanlog=meanlog2)}
  }

  # I got some poor behavior when intergrating from 0-Inf
  # So I'm going to integrate from 0 to the 2 x the 99.9th percentile instead

  # Step 1. Calculate the 99.9th percentile
  if(dist1_type=="gamma"){
    xmax1 <- qgamma(0.999, shape=shape1, rate=rate1)
  }else{
    xmax1 <- qlnorm(0.999, sdlog=sdlog1, meanlog=meanlog1)
  }
  if(dist2_type=="gamma"){
    xmax2 <- qgamma(0.999, shape=shape2, rate=rate2)
  }else{
    xmax2 <- qlnorm(0.999, sdlog=sdlog2, meanlog=meanlog2)
  }
  xmax <- max(xmax1, xmax2)

  #
  intergral_limit <- xmax*2

  # Calculate Bhattacharyya coefficient (percent overlap in two distributions)
  # https://en.wikipedia.org/wiki/Bhattacharyya_distance
  bc_integral <- function(x){sqrt(dist1_func(x)*dist2_func(x))}
  bc <- try(integrate(bc_integral, lower=0, upper=intergral_limit))
  if(inherits(bc, "try-error")){
    poverlap <- NA
    warning("Something went wrong with the integral. Returning NA for the percent overlap.")
  }else{
    poverlap <- bc$value * 100
  }

  # If plotting
  if(plot==T){

    # X-values (using xmax from above)
    x <- seq(0, xmax, length.out = 1000)

    # Simulate values
    y1 <- dist1_func(x=x)
    y2 <- dist2_func(x=x)
    dist1_label <- paste(names(dist1), unlist(dist1) %>% round(., 2), sep="=") %>% paste(., collapse=", ") %>% paste("Distribution 1", ., sep="\n")
    dist2_label <- paste(names(dist2), unlist(dist2) %>% round(., 2), sep="=") %>% paste(., collapse=", ") %>% paste("Distribution 2", ., sep="\n")
    df1 <- tibble(dist=dist1_label, x=x, y=y1)
    df2 <- tibble(dist=dist2_label, x=x, y=y2)
    df <- bind_rows(df1, df2)

    # Percent overlap label
    plabel <- paste0(round(poverlap,1), "% overlap")

    # Plot data
    g <- ggplot(df, aes(x=x, y=y, color=dist)) +
      geom_line() +
      # Labels
      labs(y="Density", x="Nutrient intake", title=plabel) +
      scale_color_discrete(name="") +
      # Theme
      theme_bw()
    print(g)

  }

  # Return
  return(poverlap)

}



#' Calculate the percent overlap between two nutrient intake distributions
#'
#' This function calculates the percent overlap between two nutrient intake distributions. It can handle combinations of gamma and log-normal distributions. The percent overlap is calculated as the Bhattacharyya coefficient.
#'
#' @param dist1 Named list with distribution parameters for distribution A
#' @param dist2 Named list with distribution parameters for distribution B
#' @param plot Plot the distributions and overlap?
#' @return The percent overlap
#' @examples
#' overlap(dist1=list(shape=2, rate=2), dist2=list(shape=2, rate=2), plot=T) # same distribution
#' overlap(dist1=list(shape=2, rate=2), dist2=list(shape=3, rate=2), plot=T) # slighly different
#' overlap(dist1=list(shape=2, rate=2), dist2=list(shape=15, rate=4), plot=T) # more different
#' overlap(dist1=list(shape=2, rate=2), dist2=list(shape=30, rate=4), plot=T) # very different
#' @export
overlap <- function(dist1, dist2, plot=F){

  # Build distribution 1
  shape1 <- dist1$shape
  rate1 <- dist1$rate
  dist1 <- function(x){dgamma(x, shape=shape1, rate=rate1)}

  # Build distribution 2
  shape2 <- dist2$shape
  rate2 <- dist2$rate
  dist2 <- function(x){dgamma(x, shape=shape2, rate=rate2)}

  # Calculate Bhattacharyya coefficient (percent overlap in two distributions)
  # https://en.wikipedia.org/wiki/Bhattacharyya_distance
  bc_integral <- function(x){sqrt(dist1(x)*dist2(x))}
  bc <- integrate(bc_integral, lower=0, upper=Inf)
  poverlap <- bc$value * 100

  # If plotting
  if(plot==T){

    # Simulate values
    xmax1 <- qgamma(0.9999, shape=shape1, rate=rate1)
    xmax2 <- qgamma(0.9999, shape=shape2, rate=rate2)
    xmax <- max(xmax1, xmax2)
    x <- seq(0, xmax, length.out = 1000)
    y1 <- dist1(x=x)
    y2 <- dist2(x=x)
    df1 <- tibble(dist="Distribution 1", x=x, y=y1)
    df2 <- tibble(dist="Distribution 2", x=x, y=y2)
    df <- bind_rows(df1, df2)

    # Label
    plabel <- paste0(round(poverlap,1), "% overlap")

    # Plot data
    g <- ggplot(df, aes(x=x, y=y, color=dist)) +
      geom_line() +
      # Labels
      labs(y="Density", x="Nutrient intake", title=plabel) +
      scale_color_discrete(name="") +
      # Theme
      theme_bw() +
      theme(legend.position="bottom")
    print(g)

  }

  # Return
  return(poverlap)

}



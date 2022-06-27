#' Calculate the median of a habitual intake distribution
#'
#' This function calculates the median of a habitual intake distribution. It handles gamma and log-normal distributions.
#'
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @param plot  Plot (T/F)?
#' @return The median of the distribution
#' @examples
#' median_dist(shape=1, rate=0.5)
#' median_dist(shape=1, rate=0.5, plot=T)
#' median_dist(meanlog=3, sdlog=1)
#' median_dist(meanlog=3, sdlog=1, plot=T)
#' @export
median_dist <- function(shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL, plot=F){

  # Which distribution?
  dist <- ifelse(!is.null(shape), "gamma", "log-normal")

  # If Gamma
  if(dist=="gamma"){

    # Calculate median
    median <- qgamma(p=0.5, shape=shape, rate=rate)

    # If plotting
    if(plot==T){
      g <- plot_dist(shape=shape, rate=rate) +
        geom_vline(xintercept=median, lty="dotted")
      print(g)
    }

  }

  # If log-normal
  if(dist=="log-normal"){

    # Calculate median
    median <- exp(meanlog)

    # If plotting
    if(plot==T){
      g <- plot_dist(meanlog=meanlog, sdlog=sdlog) +
        geom_vline(xintercept=median, lty="dotted")
      print(g)
    }

  }

  # Return
  return(median)

}



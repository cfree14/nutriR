#' Calculate the mean of a habitual intake distribution
#'
#' This function calculates the mean of a habitual intake distribution. It handles gamma and log-normal distributions.
#'
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @return The mean of the distribution
#' @examples
#' mean_dist(shape=1, rate=0.5)
#' mean_dist(meanlog=3, sdlog=1)
#' @export
mean_dist <- function(shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL){

  # Which distribution?
  dist <- ifelse(!is.null(shape), "gamma", "log-normal")

  # If Gamma
  if(dist=="gamma"){
    mu <- shape/rate
  }

  # If log-normal
  if(dist=="log-normal"){
    mu <- exp(meanlog + sdlog^2/2)
  }

  # Return
  return(mu)

}



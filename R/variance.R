#' Calculate the variance of a habitual intake distribution
#'
#' This function calculates the variance of a habitual intake distribution. It handles gamma and log-normal distributions.
#'
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @return The variance of the distribution
#' @examples
#' variance(shape=1, rate=0.5)
#' variance(meanlog=3, sdlog=1)
#' @export
variance <- function(shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL){

  # Which distribution?
  dist <- ifelse(!is.null(shape), "gamma", "log-normal")

  # If Gamma
  if(dist=="gamma"){
    var <- shape/rate^2
  }

  # If log-normal
  if(dist=="log-normal"){
    var <- ( exp(sdlog^2)-1 ) * exp(2*meanlog + sdlog^2)
  }

  # Return
  return(var)

}



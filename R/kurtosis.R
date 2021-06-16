#' Calculate the kurtosis of a habitual intake distribution
#'
#' This function calculates the kurtosis of a habitual intake distribution. It handles gamma and log-normal distributions.
#'
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @return The kurtosis of the distribution
#' @examples
#' kurtosis(shape=1, rate=0.5)
#' kurtosis(meanlog=3, sdlog=1)
#' @export
kurtosis <- function(shape=NULL, rate=NULL, meanlog, sdlog=NULL){

  # Which distribution?
  dist <- ifelse(!is.null(shape), "gamma", "log-normal")

  # If Gamma
  if(dist=="gamma"){
    kurt <- 6/shape
  }

  # If log-normal
  if(dist=="log-normal"){
    kurt <- exp(4*sdlog^2) + 2*exp(3*sdlog^2) + 3*exp(2*sdlog^2) - 6
  }

  # Return
  return(kurt)

}



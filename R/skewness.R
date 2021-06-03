#' Calculate the skewness of a habitual intake distribution
#'
#' This function calculates the skewness of a habitual intake distribution. It handles gamma and log-normal distributions.
#'
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @return The skewness of the distribution
#' @examples
#' skewness(shape=1, rate=0.5)
#' @export
skewness <- function(shape=NULL, rate=NULL, meanlog, sdlog=NULL){

  # Which distribution?
  dist <- ifelse(!is.null(shape), "gamma", "log-normal")

  # If Gamma
  if(dist=="gamma"){
    skew <- 2/sqrt(shape)
  }

  # If log-normal
  if(dist=="log-normal"){
    skew <- ( exp(sdlog^2)+2 ) * sqrt(exp(sdlog^2)-1)
  }

  # Return
  return(skew)

}



#' Calculate the coefficient of variation (CV) of a habitual intake distribution
#'
#' This function calculates the coefficient of variation (CV) of a habitual intake distribution. It handles gamma and log-normal distributions.
#'
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @return The coefficient of variation (CV) of the distribution
#' @examples
#' cv(shape=1, rate=0.5)
#' cv(meanlog=3, sdlog=1)
#' @export
cv <- function(shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL){

  # Which distribution?
  dist <- ifelse(!is.null(shape), "gamma", "log-normal")

  # If Gamma
  if(dist=="gamma"){
    cv <- 1 / sqrt(shape)
  }

  # If log-normal
  if(dist=="log-normal"){
    cv <- sqrt(exp(sdlog^2)-1)
  }

  # Return
  return(cv)

}



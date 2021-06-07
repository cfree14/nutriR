#' Calculate summary exposure values
#'
#' This function calculates the summary exposure value (SEV), or percent deficiency, for a group based on its Estimated Average Requirement and its habitual intake distribution.
#'
#' @param ear Estimated Average Requirement (EAR)
#' @param cv Coefficient of variation (CV)
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @param plot Plot the distributions relative to the EAR? True/False
#' @return The percent of a population deficient in a nutrient (SEV)
#' @examples
#' sev(ear=8.1, cv=0.1, shape=9.5, rate=1.3, plot=T)
#' sev(ear=8.1, cv=0.1, meanlog=1.9, sdlog=0.3, plot=T)
#' @export
sev <- function(ear, cv, shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL, plot=F){

  # Which dist?
  dist <- ifelse(!is.null(shape), "gamma", "log-normal")

  # Define habitual intake distribution
  if(dist=="gamma"){
    Intake <- function(x){dgamma(x, shape=shape, rate=rate)}
  }else{
    Intake <- function(x){dlnorm(x, meanlog=meanlog, sdlog=sdlog)}
  }

  # Notes on EAR CV
  # 25% for Vitamin B12 and 10% for the rest
  # 10% CV justification can be found here: Renwick (2004) Risk–benefit analysis of micronutrients,
  # https://ec.europa.eu/food/sites/food/files/safety/docs/labelling_nutrition-supplements-responses-ilsi_annex1_en.pdf

  # Define risk curve
  risk_func <- function(x){1-pnorm(x, mean=ear, sd=ear*cv)}

  # Define integral to solve
  integrant <- function(x){risk_func(x)*Intake(x)}

  # Solve integral
  solution <- integrate(integrant, lower=0, upper=Inf)

  # Extract SEV
  sev <- solution$value * 100

  # Plot data
  if(plot){

    # Simulate
    if(dist=="gamma"){
      xmax <- qgamma(0.9999, shape=shape, rate=rate)
      x <- seq(0, xmax, length.out = 1000)
      y <- dgamma(x, shape=shape, rate=rate)
    }else{
      xmax <- qlnorm(0.9999, meanlog=meanlog, sdlog=sdlog)
      x <- seq(0, xmax, length.out = 1000)
      y <- dlnorm(x, meanlog=meanlog, sdlog=sdlog)
    }

    # Plot distribution
    plot(y ~ x, type="l")
    abline(v=ear, lty=2)

    # # Plot risk curve
    # y2 <- 1 - pnorm(x, mean=ear, sd=ear*cv)
    # plot(y2 ~ x, type="l", col="red")
    # abline(v=ear, lty=2)

  }

  # Return
  return(sev)

}

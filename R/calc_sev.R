#' Calculate summary exposure value (SEV, % deficiency)
#'
#' This function calculates the summary exposure value (SEV), or percent deficiency, for a group based on its Estimated Average Requirement and its habitual intake distribution.
#'
#' @param ear Estimated Average Requirement (EAR)
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @param plot Plot the distributions relative to the EAR? True/False
#' @return The percent of a population deficient in a nutrient (SEV)
#' @examples
#' dist_do <- get_dists(nutrients="Calcium", isos="USA", sexes="F", ages=25)
#' ear <- dris %>% filter(nutrient=="Calcium" & sex=="Females" & age_range=="19-30 yr" & stage=="None" & dri_type=="Estimated Average Requirement (EAR)")
calc_sev <- function(ear, cv, shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL, plot=F){

  # For testing
  cv <-  0.1 # 0.25 for Vitamin B-12 and 0.10 for everything else
  ear <- ear$value
  shape <- dist_do$g_shape
  rate <- dist_do$g_rate

  # Define habitual intake distribution
  Intake <- function(x){dgamma(x, shape=shape, rate=rate)}

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

    # Plot distribution
    xmax <- qgamma(0.9999, shape=shape, rate=rate)
    x <- seq(0, xmax, length.out = 1000)
    y <- dgamma(x, shape=shape, rate=rate)
    plot(y ~ x, type="l")
    abline(v=ear, lty=2)

    # Plot risk curve
    # 0.25 for Vitamin B-12 and 0.10 for everything else
    y2 <- 1 - pnorm(x, mean=ear, sd=ear*cv)
    plot(y2 ~ x, type="l", col="red")
    abline(v=ear, lty=2)

  }

  # Return
  return(SEV)

}



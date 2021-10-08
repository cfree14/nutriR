#' Calculate prevalence of inadequate intakes using the cutpoint method
#'
#' This function calculates the prevalence of inadequate intakes using the EAR cutpoint method.
#'
#' @param intake_avg Mean of the habitual intake distribution
#' @param intake_cv Coefficient of variation (CV) of the habitual intake distribution
#' @param intake_dist Type of the habitual intake distribution: normal, lognormal, or gamma
#' @param ear Estimated Average Requirement (EAR)
#' @return The percent of a population with inadequate nutrient intakes (SEV)
#' @examples
#' cutpoint(intake_avg=6, intake_cv=0.25, intake_dist="normal", ear=8)
#' cutpoint(intake_avg=6, intake_cv=0.25, intake_dist="gamma", ear=8)
#' cutpoint(intake_avg=6, intake_cv=0.25, intake_dist="lognormal", ear=8)
#' @export
cutpoint <- function(intake_avg, intake_cv, intake_dist, ear){

  # Check distribution
  dist_check <- intake_dist %in% c("normal", "lognormal", "gamma")
  if(!dist_check){stop("Intake distribution must be one of the following: normal, lognormal, or gamma")}

  # Normal distribution
  if(intake_dist=="normal"){
    pdeficient <- pnorm(q=ear, mean=intake_avg, sd=intake_avg*intake_cv) * 100
  }

  # Gamma distribution
  if(intake_dist=="lognormal"){
    sdlog <- sqrt(log(intake_cv^2+1))
    meanlog <- log(intake_avg) - sdlog^2/2
    pdeficient <- plnorm(q=ear, meanlog=meanlog, sdlog=sdlog) * 100
  }

  # Gamma distribution
  if(intake_dist=="gamma"){
    shape <- (1 / intake_cv) ^ 2
    rate <- shape / intake_avg
    pdeficient <- pgamma(q=ear, shape=shape, rate=rate) * 100
  }

  # Return
  return(pdeficient)

}

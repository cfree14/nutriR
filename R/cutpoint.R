#' Calculate prevalence of inadequate intakes using the cutpoint method
#'
#' This function calculates the prevalence of inadequate intakes using the EAR cutpoint method.
#'
#' @param intake_avg Mean of the habitual intake distribution
#' @param intake_cv Coefficient of variation (CV) of the habitual intake distribution
#' @param ear Estimated Average Requirement (EAR)
#' @return The percent of a population deficient in a nutrient (SEV)
#' @export
cutpoint <- function(intake_avg, intake_cv, ear){

  # Calculate p(deficient)
  pdeficient <- pnorm(q=ear, mean=intake_avg, sd=intake_avg*intake_cv)

  # Return
  return(pdeficient)

}

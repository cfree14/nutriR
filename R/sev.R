#' Calculate summary exposure value
#'
#' This function calculates the summary exposure value (SEV), i.e., the percent of a population with inadequate nutrient intakes, for a group based on its Estimated Average Requirement (EAR) and its habitual intake distribution. It uses the probability method (NRC 1986). A CV of 0.25 is recommended for the EAR of Vitamin B12 and a CV of 0.10 is recommended for the EAR of all other nutrients (Renwick et al. 2004).
#'
#' @param ear Estimated Average Requirement (EAR)
#' @param cv Coefficient of variation (CV) of the EAR
#' @param mean Mean for normal distribution
#' @param sd Standard deviation for normal distribution
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @param plot Boolean (TRUE/FALSE) indicating whether to plot the distributions relative to the EAR
#' @return The percent of a population with inadequate nutrient intakes (SEV)
#' @examples
#' sev(ear=8.1, cv=0.1, mean=8.5, sd=1.3, plot=T)
#' sev(ear=8.1, cv=0.1, shape=9.5, rate=1.3, plot=T)
#' sev(ear=8.1, cv=0.1, meanlog=1.9, sdlog=0.3, plot=T)
#' @references
#' National Research Council (1986) Nutrient Adequacy: Assessment Using Food Consumption Surveys. Washington, DC: The National Academies Press. https://doi.org/10.17226/618.
#'
#' Renwick AG, Flynn A, Fletcher RJ, Müller DJ, Tuijtelaars S, Verhagen H (2004) Risk-benefit analysis of micronutrients. Food and Chemical Toxicology 42(12): 1903-22. https://doi.org/10.1016/j.fct.2004.07.013
#' @export
sev <- function(ear, cv, mean=NULL, sd=NULL, shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL, plot=F){

  # Notes on an example where you get "bad integrand behavior"
  # ear <- 10; cv <- 0.1; meanlog <- -36.92221; sdlog <- 46.77756; shape <- NULL

  # Is an EAR provided?
  if(is.na(ear) | is.na(cv)){

    sev <- NA
    warning("EAR or EAR CV not provided. Returning NA for the SEV value.")

  }else{

    # Which dist?
    dist <- ifelse(!is.null(mean), "normal",
                   ifelse(!is.null(shape), "gamma", "log-normal"))

    # Define habitual intake distribution
    if(dist=="gamma"){
      Intake <- function(x){dgamma(x, shape=shape, rate=rate)}
    }
    if(dist=="log-normal"){
      Intake <- function(x){dlnorm(x, meanlog=meanlog, sdlog=sdlog)}
    }
    if(dist=="normal"){
        Intake <- function(x){dnorm(x, mean=mean, sd=sd)}
    }

    # Notes on EAR CV
    # 25% for Vitamin B12 and 10% for the rest
    # 10% CV justification can be found here: Renwick (2004) Risk–benefit analysis of micronutrients,
    # https://ec.europa.eu/food/sites/food/files/safety/docs/labelling_nutrition-supplements-responses-ilsi_annex1_en.pdf

    # Define risk curve
    risk_func <- function(x){1-pnorm(x, mean=ear, sd=ear*cv)}

    # Define integral to solve
    integrant <- function(x){risk_func(x)*Intake(x)}

    # Solving the intregral from 0 to infinity resulted in poor behaviour in some cases
    # Instead, I have decided to solve the integral from 0 to 2x the 99.9th percentile
    if(dist=="gamma"){
      integral_limit <- qgamma(0.999, shape=shape, rate=rate) * 2
    }
    if(dist=="log-normal"){
      integral_limit <- qlnorm(0.999, sdlog=sdlog, meanlog=meanlog) * 2
    }
    if(dist=="normal"){
      integral_limit <- qnorm(0.999, sd=sd, mean=mean) * 2
    }

    # Solve integral
    # Add a try function in case there is bad behavior
    solution <- try(integrate(integrant, lower=0, upper=integral_limit))

    # Extract SEV
    if(inherits(solution, "try-error")){
      sev <- NA
      warning("Extremely bad integrand behaviour. Returning NA for the SEV value.")
    }else{
      sev <- solution$value * 100
    }

    # Plot data
    if(plot){

      # Simulate
      if(dist=="gamma"){
        xmax <- qgamma(0.9999, shape=shape, rate=rate)
        x <- seq(0, xmax, length.out = 1000)
        y <- dgamma(x, shape=shape, rate=rate)
      }
      if(dist=="log-normal"){
        xmax <- qlnorm(0.9999, meanlog=meanlog, sdlog=sdlog)
        x <- seq(0, xmax, length.out = 1000)
        y <- dlnorm(x, meanlog=meanlog, sdlog=sdlog)
      }
      if(dist=="normal"){
        xmax <- qnorm(0.9999, mean=mean, sd=sd)
        x <- seq(0, xmax, length.out = 1000)
        y <- dnorm(x, mean=mean, sd=sd)
      }

      # Merge
      df <- tibble(intake=x,
                   density=y)

      # Plot distributon
      g <- ggplot(df, mapping=aes(x=intake, y=density)) +
        geom_line() +
        # Labels
        labs(x="Habitual intake", y="Density",
             title=paste0(round(sev, 1), "% of population with inadequate intake")) +
        # Plot EAR
        geom_vline(xintercept=ear, linetype="dotted") +
        annotate("text", x=ear, y=max(df$density), label=ear, hjust=-0.4) +
        # Theme
        theme_bw() +
        theme(# Gridlines
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"))
      print(g)

      # # Plot risk curve
      # y2 <- 1 - pnorm(x, mean=ear, sd=ear*cv)
      # plot(y2 ~ x, type="l", col="red")
      # abline(v=ear, lty=2)

    }

  }

  # Return
  return(sev)

}

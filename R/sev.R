#' Calculate summary exposure value
#'
#' This function calculates the summary exposure value (SEV), i.e., the percent deficiency, for a group based on its Estimated Average Requirement (EAR) and its habitual intake distribution. It uses the probability method. A CV of 0.25 is recommended for the EAR of Vitamin B12 and a CV of 0.10 is recommended for the EAR of all other nutrients.
#'
#' @param ear Estimated Average Requirement (EAR)
#' @param cv Coefficient of variation (CV) of the EAR
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @param plot Boolean (TRUE/FALSE) indicating whether to plot the distributions relative to the EAR
#' @return The percent of a population deficient in a nutrient (SEV)
#' @examples
#' sev(ear=8.1, cv=0.1, shape=9.5, rate=1.3, plot=T)
#' sev(ear=8.1, cv=0.1, meanlog=1.9, sdlog=0.3, plot=T)
#' @export
sev <- function(ear, cv, shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL, plot=F){

  # Notes on an example where you get "bad integrand behavior"
  # ear <- 10; cv <- 0.1; meanlog <- -36.92221; sdlog <- 46.77756; shape <- NULL

  # Is an EAR provided?
  if(is.na(ear) | is.na(cv)){

    sev <- NA
    warning("EAR or EAR CV not provided. Returning NA for the SEV value.")

  }else{


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
    # Add a try function in case there is bad behavior
    solution <- try(integrate(integrant, lower=0, upper=Inf))

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
      }else{
        xmax <- qlnorm(0.9999, meanlog=meanlog, sdlog=sdlog)
        x <- seq(0, xmax, length.out = 1000)
        y <- dlnorm(x, meanlog=meanlog, sdlog=sdlog)
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

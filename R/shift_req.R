#' Calculate intake mean shift required to achieve a specified prevalence
#'
#' This function calculates the shift in a habitual intake distribution required to achieve a user-specified target prevalence of inadequate intakes.
#'
#' @param ear Estimated Average Requirement (EAR)
#' @param cv Coefficient of variation (CV) of the EAR
#' @param target Target prevalence (0-100): 0 percent inadequate to 100 percent inadequate
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @param plot Boolean (TRUE/FALSE) indicating whether to plot the distributions relative to the EAR
#' @return A list of the parameters for the intake distribution required to obtain the target prevalence
#' @examples
#' # Gamma-distribution examples
#' sev(ear=8.1, cv=0.1, shape=9.5, rate=1.3, plot=T)
#' shift_req(ear=8.1, cv=0.1, target=25, shape=9.5, rate=1.3, plot=T)
#' shift_req(ear=8.1, cv=0.1, target=10, shape=9.5, rate=1.3, plot=T)
#' shift_req(ear=8.1, cv=0.1, target=5, shape=9.5, rate=1.3, plot=T)
#'
#' # Lognormal-distribution examples
#' sev(ear=8.1, cv=0.1, meanlog=1.9, sdlog=0.3, plot=T)
#' shift_req(ear=8.1, cv=0.1, target=25, meanlog=1.9, sdlog=0.3, plot=T)
#' shift_req(ear=8.1, cv=0.1, target=10, meanlog=1.9, sdlog=0.3, plot=T)
#' shift_req(ear=8.1, cv=0.1, target=5, meanlog=1.9, sdlog=0.3, plot=T)
#' @export
shift_req <- function(ear, cv, target, shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL, plot=F){

  # Is an EAR provided?
  if(is.na(ear) | is.na(cv)){
    sev <- NA
    warning("EAR or EAR CV not provided. Returning NA for the SEV value.")
  # Proceed if the EAR is provided,
  }else{

    # Which distribution?
    dist_do <- ifelse(!is.null(shape) & !is.null(rate), "gamma",
                      ifelse(!is.null(meanlog) & !is.null(sdlog), "log-normal", "incomplete"))
    if(dist_do=="incomplete"){stop("Not enough parameters provided. Either shape/rate or meanlog/sdlog requried.")}

    # Calculate difference between p(deficient) target
    # and the p(deficient) produced by an evaluated mean intake
    minDiff <- function(mu){
      # Shift distribution
      dist_i <- shift_dist(shape=shape, rate=rate, meanlog=meanlog, sdlog=sdlog, to=mu, plot=F)
      # Calculate SEV of shifted distribution
      sev_i <- sev(ear=ear, cv=cv, shape=dist_i$shape, rate=dist_i$rate, meanlog=dist_i$meanlog, sdlog=dist_i$sdlog)
      # Calculate difference between realized SEV and target SEV
      diff_i <- abs(sev_i - target)
      return(diff_i)
    }

    # Find mean intake required to hit the target prevalence of inadequacy
    fit <- optimize(f=minDiff, lower=0, upper=ear*10)
    mu_req <- fit$minimum

    # Determine properties for the required intake distribution
    dist_req <- shift_dist(shape=shape, rate=rate, meanlog=meanlog, sdlog=sdlog, to=mu_req, plot=F)

    # Plot data
    if(plot){

      # Simulate data
      if(dist_do=="gamma"){

        # Curves
        shape2 <- dist_req$shape
        rate2 <- dist_req$rate
        xmax1 <- qgamma(p=0.9999, shape=shape, rate=rate)
        xmax2 <- qgamma(p=0.9999, shape=shape2, rate=rate2)
        xmax <- pmax(xmax1, xmax2)
        x <- seq(0, xmax, length.out = 200)
        y1 <- dgamma(x, shape=shape, rate=rate)
        y2 <- dgamma(x, shape=shape2, rate=rate2)

        # Mean values / SEVs
        sev1 <- sev(ear=ear, cv=cv, shape=shape, rate=rate)
        sev2 <- sev(ear=ear, cv=cv, shape=shape2, rate=rate2)
        mean1 <- mean_dist(shape=shape, rate=rate)
        mean2 <- mean_dist(shape=shape2, rate=rate2)
        mean1_dens = dgamma(mean1, shape=shape, rate=rate)
        mean2_dens = dgamma(mean2, shape=shape2, rate=rate2)

      }
      if(dist_do=="log-normal"){
        # Curves
        meanlog2 <- dist_req$meanlog
        sdlog2 <- dist_req$sdlog
        xmax1 <- qlnorm(p=0.9999, meanlog = meanlog, sdlog=sdlog)
        xmax2 <- qlnorm(p=0.9999, meanlog = meanlog2, sdlog=sdlog2)
        xmax <- pmax(xmax1, xmax2)
        x <- seq(0, xmax, length.out = 200)
        y1 <- dlnorm(x, meanlog=meanlog, sdlog=sdlog)
        y2 <- dlnorm(x, meanlog=meanlog2, sdlog=sdlog2)

        # Mean values / SEVs
        sev1 <- sev(ear=ear, cv=cv, meanlog = meanlog, sdlog=sdlog)
        sev2 <- sev(ear=ear, cv=cv, meanlog = meanlog2, sdlog=sdlog2)
        mean1 <- mean_dist(meanlog = meanlog, sdlog=sdlog)
        mean2 <- mean_dist(meanlog = meanlog2, sdlog=sdlog2)
        mean1_dens = dlnorm(mean1, meanlog=meanlog, sdlog=sdlog)
        mean2_dens = dlnorm(mean2, meanlog=meanlog2, sdlog=sdlog2)
      }

      # Build mean data frame
      mu_df <- tibble(scenario=c("Current", "Shifted"),
                      mean=c(mean1, mean2),
                      density=c(mean1_dens, mean2_dens),
                      sev=c(sev1, sev2),
                      label=paste0(round(mean, 1), ", ", round(sev,1), "% inadequate"))

      # Create dataframe
      data <- tibble(intake=x, y1, y2) %>%
        # Gather
        tidyr::gather(key="scenario", value="density", 2:ncol(.)) %>%
        dplyr::mutate(scenario=recode_factor(scenario,
                                             "y1"="Current",
                                             "y2"="Shifted")) %>%
        # Standardize densities
        group_by(scenario) %>%
        mutate(density_sd=density/max(density))

      # Base R plot
      # plot(x, y1, type="l", xlab="Intake", ylab="Density")
      # lines(x, y2, col="blue")

      # Plot shifted distribution
      g <- ggplot(data, aes(x=intake, y=density, color=scenario)) +
        geom_line() +
        # EAR
        geom_vline(xintercept=ear, linetype="dotted", color="black") +
        # Mean points
        geom_point(data=mu_df, mapping=aes(x=mean, y=density, color=scenario)) +
        geom_text(data=mu_df, mapping=aes(x=mean, y=density, color=scenario, label=label), hjust=-0.1, show.legend = F) +
        geom_segment(data=mu_df, mapping=aes(x=mean, xend=mean, y=0, yend=density, color=scenario), linetype="dotted") +
        # Labels
        labs(x="Nutrient intake", y="Density") +
        scale_color_discrete(name="Distribution") +
        # Theme
        theme_bw() +
        theme(axis.text=element_text(size=6),
              axis.title=element_text(size=8),
              legend.text=element_text(size=6),
              legend.title=element_text(size=8),
              strip.text=element_text(size=8),
              plot.title=element_blank(),
              # Gridlines
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.background = element_blank(),
              axis.line = element_line(colour = "black"))
      g
      print(g)

    }

  }

  # Format outout
  output <- dist_req
  output$mean <- mean2

  # Return
  return(output)

}

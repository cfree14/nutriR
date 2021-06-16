#' Shift the mean of a habitual intake distribution
#'
#' This function shifts the mean of a habitual intake distribution and provides the new parameters used to describe the shifted distribution.
#'
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @param by Amount to shift the current mean by
#' @param to New mean to shift the current mean to
#' @param plot Boolean (TRUE/FALSE) indicating whether to plot the current/shifted distributions
#' @return A list with the parameters for the shifted distribution
#' @examples
#' # Shift gamma distribution by an amount (2 and -3)
#' shift_dist(shape=9.7, rate=1.25, by=2, plot=T)
#' shift_dist(shape=9.7, rate=1.25, by=-3, plot=T)
#'
#' # Shift gamma distribution to a new mean (10 or 4)
#' shift_dist(shape=9.7, rate=1.25, to=10, plot=T)
#' shift_dist(shape=9.7, rate=1.25, to=4, plot=T)
#'
#' # Shift log-normal distribution by an amount (10 and -5)
#' shift_dist(meanlog=3, sdlog=0.5, by=10, plot=T)
#' shift_dist(meanlog=3, sdlog=0.5, by=-5, plot=T)
#'
#' # Shift log-normal distribution to a new mean (35 and 15)
#' shift_dist(meanlog=3, sdlog=0.5, to=35, plot=T)
#' shift_dist(meanlog=3, sdlog=0.5, to=15, plot=T)
#' @export
shift_dist <- function(shape=NULL, rate=NULL,
                       meanlog=NULL, sdlog=NULL,
                       by=NULL, to=NULL, plot=F){

  # Perform checks
  if(is.null(by) & is.null(to)){stop("A 'by' or 'to' must be specified.")}
  if(!is.null(by) & !is.null(to)){stop("Either a 'by' OR a 'to' should be specified, not both.")}

  # Which distribution?
  dist_do <- ifelse(!is.null(shape) & !is.null(rate), "gamma",
                    ifelse(!is.null(meanlog) & !is.null(sdlog), "log-normal", "incomplete"))
  if(dist_do=="incomplete"){stop("Not enough parameters provided. Either shape/rate or meanlog/sdlog requried.")}

  # Current mean
  if(dist_do=="gamma"){mean1 <- nutriR::mean_dist(shape=shape, rate=rate)}
  if(dist_do=="log-normal"){mean1 <- nutriR::mean_dist(meanlog=meanlog, sdlog=sdlog)}

  # Shifted mean
  mean2 <- ifelse(!is.null(by), mean1+by, to)

  # Shift mean

  # If gamma...
  if(dist_do=="gamma"){
    scalar <- mean2 / mean1
    shape2 <- shape
    rate2 <- rate/scalar
    output <- list(shape=shape2, rate=rate2)
  }
  # If log-normal...
  if(dist_do=="log-normal"){
    sdlog2 <- sdlog
    meanlog2 <- log(mean2) - sdlog2^2/2
    output <- list(meanlog=meanlog2, sdlog=sdlog2)
  }

  # Plot shifted distribution
  if(plot==T){

    # Simulate data
    if(dist_do=="gamma"){
      xmax <- qgamma(p=0.9999, shape=shape, rate=rate)
      x <- seq(0, xmax, length.out = 200)
      y1 <- dgamma(x, shape=shape, rate=rate)
      y2 <- dgamma(x, shape=shape2, rate=rate2)
      mean1_dens = dgamma(mean1, shape=shape, rate=rate)
      mean2_dens = dgamma(mean2, shape=shape2, rate=rate2)
    }
    if(dist_do=="log-normal"){
      xmax <- qlnorm(p=0.9999, meanlog = meanlog, sdlog=sdlog)
      x <- seq(0, xmax, length.out = 200)
      y1 <- dlnorm(x, meanlog=meanlog, sdlog=sdlog)
      y2 <- dlnorm(x, meanlog=meanlog2, sdlog=sdlog2)
      mean1_dens = dlnorm(mean1, meanlog=meanlog, sdlog=sdlog)
      mean2_dens = dlnorm(mean2, meanlog=meanlog2, sdlog=sdlog2)
    }

    # Build mean data frame
    mu_df <- tibble(scenario=c("Current", "Shifted"),
                    mean=c(mean1, mean2),
                    density=c(mean1_dens, mean2_dens),
                    mean_label=round(mean, 1))

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
      # Mean points
      geom_point(data=mu_df, mapping=aes(x=mean, y=density, color=scenario)) +
      geom_text(data=mu_df, mapping=aes(x=mean, y=density, color=scenario, label=mean_label), hjust=-0.5, show.legend = F) +
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

  # Return
  return(output)

}



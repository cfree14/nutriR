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
#' @param plot Plot the current/shifted distributions? True/False
#' @return A list with the parameters for the shifted distribution
#' @examples
#' # Shift distributions by an amount (2 and -3)
#' shift_dist(shape=9.7, rate=1.25, by=2, plot=T)
#' shift_dist(shape=9.7, rate=1.25, by=-3, plot=T)
#'
#' # Shift distributions to a new mean (10 or 4)
#' shift_dist(shape=9.7, rate=1.25, to=10, plot=T)
#' shift_dist(shape=9.7, rate=1.25, to=4, plot=T)
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
  if(dist_do=="gamma"){mean1 <- shape/rate}

  # Shifted mean
  mean2 <- ifelse(!is.null(by), mean1+by, to)

  # New parameters
  scalar <- mean2 / mean1

  # Shift distribution
  if(dist_do=="gamma"){

    shape2 <- shape
    rate2 <- rate/scalar
    output <- list(shape=shape2, rate=rate2)

  }

  # Plot shifted distribution
  if(plot==T){

    # Simulate data
    xmax <- qgamma(p=0.9999, shape=shape, rate=rate)
    x <- seq(0, xmax, length.out = 200)
    y1 <- dgamma(x, shape=shape, rate=rate)
    y2 <- dgamma(x, shape=shape2, rate=rate2)

    # Create dataframe
    data <- tibble(intake=x, y1, y2) %>%
      # Gather
      tidyr::gather(key="scenario", value="density", 2:ncol(.)) %>%
      dplyr::mutate(scenario=recode_factor(scenario,
                                    "y1"="Current",
                                    "y2"="Shifted")) %>%
      # Standardize densities
      group_by(scenario) %>%
      mutate(density_std=density/max(density))


    # Base R plot
    # plot(x, y1, type="l", xlab="Intake", ylab="Density")
    # lines(x, y2, col="blue")

    # Nice plot
    g <- ggplot(data, aes(x=intake, y=density_std, color=scenario)) +
      geom_line() +
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



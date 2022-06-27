#' Shift the scale of a habitual intake distribution
#'
#' This function shifts the scale of a habitual intake distribution and provides the new parameters used to describe the shifted distribution. The shift in scale is defined by either a shift in the mean or median of of the habitual intake distribution.
#'
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @param by Amount to shift the current mean/median by
#' @param to New mean/median to shift the current mean/median to
#' @param type Measure of scale to shift ("mean" or "median"); mean is default
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
                       by=NULL, to=NULL, type="mean", plot=F){

  # Perform checks
  if(is.null(by) & is.null(to)){stop("A 'by' or 'to' must be specified.")}
  if(!is.null(by) & !is.null(to)){stop("Either a 'by' OR a 'to' should be specified, not both.")}
  if(!type %in% c("mean", "median")){stop("Type must be either 'mean' or 'median'.")}

  # Which distribution?
  dist_do <- ifelse(!is.null(shape) & !is.null(rate), "gamma",
                    ifelse(!is.null(meanlog) & !is.null(sdlog), "log-normal", "incomplete"))
  if(dist_do=="incomplete"){stop("Not enough parameters provided. Either shape/rate or meanlog/sdlog requried.")}

  # If mean
  ################################################

  if(type=="mean"){

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
        xmax1 <- qgamma(p=0.9999, shape=shape, rate=rate)
        xmax2 <- qgamma(p=0.9999, shape=shape2, rate=rate2)
        xmax <- pmax(xmax1, xmax2)
        x <- seq(0, xmax, length.out = 200)
        y1 <- dgamma(x, shape=shape, rate=rate)
        y2 <- dgamma(x, shape=shape2, rate=rate2)
        mean1_dens = dgamma(mean1, shape=shape, rate=rate)
        mean2_dens = dgamma(mean2, shape=shape2, rate=rate2)
      }
      if(dist_do=="log-normal"){
        xmax1 <- qlnorm(p=0.9999, meanlog = meanlog, sdlog=sdlog)
        xmax2 <- qlnorm(p=0.9999, meanlog = meanlog2, sdlog=sdlog2)
        xmax <- pmax(xmax1, xmax2)
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

  }

  # If median
  ################################################

  if(type=="median"){

    # Current median
    if(dist_do=="gamma"){median1 <- median_dist(shape=shape, rate=rate)}
    if(dist_do=="log-normal"){median1 <- median_dist(meanlog=meanlog, sdlog=sdlog)}

    # Shifted median
    median2 <- ifelse(!is.null(by), median1+by, to)

    # Shift median

    # If gamma...
    if(dist_do=="gamma"){

      # Function to find new rate
      # Rate required to have a gamma dist with median2 given shape
      find_new_rate <- function(median2, shape){

        # Definite objective function
        objFun <- function(x){
          rate <- x
          median_derived <- median_dist(shape=shape, rate=rate)
          median_diff <- abs(median_derived-median2)
          return(median_diff)
        }

        # Find solution
        solution <- optim(par=1, fn=objFun,  method="Brent", lower=0, upper=100)
        rate <- solution$par

        # Return
        return(rate)

      }

      # Derive
      shape2 <- shape
      rate2 <- find_new_rate(median2, shape=shape2)
      output <- list(shape=shape2, rate=rate2)

    }
    # If log-normal...
    if(dist_do=="log-normal"){
      sdlog2 <- sdlog
      meanlog2 <- log(median2)
      output <- list(meanlog=meanlog2, sdlog=sdlog2)
    }

    # Plot shifted distribution
    if(plot==T){

      # Simulate data
      if(dist_do=="gamma"){
        xmax1 <- qgamma(p=0.9999, shape=shape, rate=rate)
        xmax2 <- qgamma(p=0.9999, shape=shape2, rate=rate2)
        xmax <- pmax(xmax1, xmax2)
        x <- seq(0, xmax, length.out = 200)
        y1 <- dgamma(x, shape=shape, rate=rate)
        y2 <- dgamma(x, shape=shape2, rate=rate2)
        median1_dens = dgamma(median1, shape=shape, rate=rate)
        median2_dens = dgamma(median2, shape=shape2, rate=rate2)
      }
      if(dist_do=="log-normal"){
        xmax1 <- qlnorm(p=0.9999, meanlog = meanlog, sdlog=sdlog)
        xmax2 <- qlnorm(p=0.9999, meanlog = meanlog2, sdlog=sdlog2)
        xmax <- pmax(xmax1, xmax2)
        x <- seq(0, xmax, length.out = 200)
        y1 <- dlnorm(x, meanlog=meanlog, sdlog=sdlog)
        y2 <- dlnorm(x, meanlog=meanlog2, sdlog=sdlog2)
        median1_dens = dlnorm(median1, meanlog=meanlog, sdlog=sdlog)
        median2_dens = dlnorm(median2, meanlog=meanlog2, sdlog=sdlog2)
      }

      # Build median data frame
      median_df <- tibble(scenario=c("Current", "Shifted"),
                      median=c(median1, median2),
                      density=c(median1_dens, median2_dens),
                      median_label=round(median, 1))

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
        # Median points
        geom_point(data=median_df, mapping=aes(x=median, y=density, color=scenario)) +
        geom_text(data=median_df, mapping=aes(x=median, y=density, color=scenario, label=median_label), hjust=-0.5, show.legend = F) +
        geom_segment(data=median_df, mapping=aes(x=median, xend=median, y=0, yend=density, color=scenario), linetype="dotted") +
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

  # Return
  return(output)

}



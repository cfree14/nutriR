#' Plots a log-normal or gamma distribution
#'
#' This function plots a log-normal or gamma distribution.
#'
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @examples
#' plot_dist(shape=2, rate=0.5)
#' plot_dist(meanlog=3, sdlog=1)
#' @export
plot_dist <- function(shape=NULL, rate=NULL,
                       meanlog=NULL, sdlog=NULL){

  # Which distribution?
  dist <- ifelse(!is.null(shape), "gamma", "log-normal")

  # If gamma
  if(dist=="gamma"){

    # Set maximum value
    xmax <- qgamma(0.99, shape=shape, rate=rate)

    # Build curve
    x <- seq(0, xmax, length.out = 1000)
    y <- dgamma(x, shape=shape, rate=rate)

    # Build data frame
    df <- tibble(intake=x,
                 density=y)

  }

  # If log-normal
  if(dist=="log-normal"){

    # Set maximum value
    xmax <- qlnorm(0.99, meanlog=meanlog, sdlog=sdlog)

    # Build curve
    x <- seq(0, xmax, length.out = 200)
    y <- dlnorm(x, meanlog=meanlog, sdlog=sdlog)
    # plot(y ~ x)

    # Build data frame
    df <- tibble(intake=x,
                 density=y)

  }

  # Plot
  g <- ggplot(df, aes(x=intake, y=density)) +
    geom_line() +
    # Labels
    labs(x="Habitual intake", y='Density') +
    # Theme
    theme_bw() +
    theme(axis.text=element_text(size=7),
          axis.title=element_text(size=8),
          legend.text=element_text(size=7),
          legend.title=element_text(size=8),
          strip.text=element_text(size=8),
          plot.title=element_text(size=10),
          # Gridlines
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          # Legend
          legend.background = element_rect(fill=alpha('blue', 0)))
  print(g)

  # Return
  return(g)

}



#' Calculate percent of population at risk of adverse effects
#'
#' This function calculates the percent of a population whose habitual intake is above the Tolerable Upper Limit (UL) and are therefore at risk of adverse effects.
#'
#' @param ul Tolerable Upper Limit (UL)
#' @param shape Shape parameter for gamma distribution
#' @param rate Rate parameter for gamma distribution
#' @param meanlog Mean parameter for gamma distribution
#' @param sdlog Standard deviation parameter for gamma distribution
#' @param plot Boolean (TRUE/FALSE) indicating whether to plot the distributions relative to the EAR
#' @return The percent of a population at risk of adverse effects
#' @examples
#' above_ul(ul=11, shape=9.5, rate=1.3, plot=T)
#' above_ul(ul=11, meanlog=1.9, sdlog=0.3, plot=T)
#' above_ul(ul=13, meanlog=1.9, sdlog=0.3, plot=T)
#' @export
above_ul <- function(ul, shape=NULL, rate=NULL, meanlog=NULL, sdlog=NULL, plot=F){

  # Is an UL provided?
  if(is.na(ul)){

    perc <- NA
    warning("UL not provided. Returning NA for the percent above the upper limit.")

  }else{

    # Which dist?
    dist <- ifelse(!is.null(shape), "gamma", "log-normal")

    # Define habitual intake distribution
    if(dist=="gamma"){
      perc <- (1 - pgamma(q=ul, shape=shape, rate=rate)) * 100
    }else{
      perc <- (1 - plnorm(q=ul, meanlog=meanlog, sdlog=sdlog)) * 100
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

      # Plot distribution
      g <- ggplot(df, mapping=aes(x=intake, y=density)) +
        geom_line() +
        # Labels
        labs(x="Habitual intake", y="Density",
             title=paste0(round(perc, 1), "% of population above the upper limit")) +
        # Plot UL
        geom_vline(xintercept=ul, linetype="dotted") +
        annotate("text", x=ul, y=max(df$density), label=ul, hjust=-0.4) +
        # Theme
        theme_bw() +
        theme(# Gridlines
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"))
      print(g)


    }

  }

  # Return
  return(perc)

}

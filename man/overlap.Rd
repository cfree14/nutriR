% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/overlap.R
\name{overlap}
\alias{overlap}
\title{Calculate the percent overlap between two habitual intake distributions}
\usage{
overlap(dist1, dist2, plot = F)
}
\arguments{
\item{dist1}{List containing the named distribution parameters for distribution A}

\item{dist2}{List containing the named distribution parameters for distribution B}

\item{plot}{Boolean (TRUE/FALSE) indicating whether to plot the distributions and overlap}
}
\value{
The percent overlap in the two distributions
}
\description{
This function calculates the percent overlap between two habitual intake distributions. It handles combinations of gamma and log-normal distributions. The percent overlap is calculated as the Bhattacharyya coefficient.
}
\examples{
overlap(dist1=list(shape=2, rate=2), dist2=list(shape=2, rate=2), plot=T) # same distribution
overlap(dist1=list(shape=2, rate=2), dist2=list(shape=3, rate=2), plot=T) # slighly different
overlap(dist1=list(shape=2, rate=2), dist2=list(meanlog=0.5, sdlog=0.4), plot=T) # slightly different
overlap(dist1=list(meanlog=0.5, sdlog=0.4), dist2=list(shape=2, rate=2), plot=T) # slightly different
overlap(dist1=list(shape=2, rate=2), dist2=list(shape=15, rate=4), plot=T) # more different
overlap(dist1=list(shape=2, rate=2), dist2=list(shape=30, rate=4), plot=T) # very different
}

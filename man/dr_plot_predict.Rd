% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot-predict.R
\name{dr_plot_predict}
\alias{dr_plot_predict}
\alias{dr_plot_predict.drfit}
\alias{dr_plot_predict.data.frame}
\title{Plot Predicted Detection Range}
\usage{
dr_plot_predict(x, ...)

\method{dr_plot_predict}{drfit}(
  x,
  xlab = "Distance",
  ylab = "Proportion of Pings Detected",
  facet = TRUE,
  ...
)

\method{dr_plot_predict}{data.frame}(
  x,
  predict_de,
  xlab = "Distance",
  ylab = "Proportion of Pings Detected",
  facet = TRUE,
  ...
)
}
\arguments{
\item{x}{The object.}

\item{...}{Unused parameters.}

\item{xlab}{A string of the x-axis title.}

\item{ylab}{A string of the y-axis title.}

\item{facet}{A flag indicating whether to facet plot by Station.}

\item{predict_de}{A tibble of the output of \code{dr_predict_de}.}
}
\description{
Generic function to plot the predicted detection range.
}
\section{Methods (by class)}{
\itemize{
\item \code{drfit}: method to plot predicted detection range from drfit object

\item \code{data.frame}: method to plot predicted detection range from data.frame object
}}

\examples{
fit <- dr_fit(detrange::range_obs)
dr_plot_predict(fit)
fit <- dr_fit(detrange::range_obs)
dr_plot_predict(fit)
}

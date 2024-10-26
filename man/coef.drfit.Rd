% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coef.R
\name{coef.drfit}
\alias{coef.drfit}
\title{Get Tidy Tibble from drfit Object.}
\usage{
\method{coef}{drfit}(object, conf_level = 0.95, estimate = median, random_effects = FALSE, ...)
}
\arguments{
\item{object}{The object.}

\item{conf_level}{A number between 0 and 1 of the confidence level.}

\item{estimate}{A function to calculate the estimate.}

\item{random_effects}{A flag indicating whether to include random effect terms.}

\item{...}{Unused parameters.}
}
\description{
A wrapper on \code{\link[=tidy.drfit]{tidy.drfit()}}.
}
\examples{
fit <- dr_fit(detrange::range_obs)
coef(fit)
}
\seealso{
\code{\link[=tidy.drfit]{tidy.drfit()}}
}

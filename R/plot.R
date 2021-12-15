#' Plot Predicted Detection Range
#'
#' Generic function to plot the predicted detection range.
#'
#' @inheritParams params
#' @export
dr_plot <- function(x, ...) {
  UseMethod("dr_plot")
}

#' @export
ggplot2::autoplot

#' @describeIn autoplot method to plot detection range from data.frame object
#' @inheritParams params
#' @export
#' @examples
#' autoplot(detrange::range_obs)
autoplot.data.frame <- function(object, ...){
  dr_plot(object,  ...)
}

#' @describeIn autoplot method to plot detection range from drfit object
#' @inheritParams params
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_obs)
#' autoplot(fit)
autoplot.drfit <- function(object,  ...){

  dr_plot(object, ...)
}

#' @describeIn dr_plot method to plot predicted detection range from data.frame object
#' @inheritParams params
#' @export
#' @examples
#' dr_plot(detrange::range_obs)
dr_plot.data.frame <- function(x,
                               facet = TRUE,
                               xlab = "Distance",
                               ylab = "Proportion of Pings Detected", ...){
  chk_unused(...)
  data <- x

  chk_s3_class(data, "data.frame")
  data <- format_colnames(data)
  .chk_data(data)

  gp <- ggplot() +
    ggplot2::labs(x = xlab, y = ylab)

  if(facet){
    gp <- gp +
      geom_dr_point(data = data, aes(x = .data$Distance,
                                     detects = .data$Detects,
                                     pings = .data$Pings)) +
      facet_wrap(vars(.data$Station))
  } else {
    gp <- gp +
      geom_dr_point(data = data, aes(x = .data$Distance,
                                     detects = .data$Detects,
                                     pings = .data$Pings,
                                     color = .data$Station))
  }
  gp
}

#' @describeIn dr_plot method to plot predicted detection range from drfit object
#' @inheritParams params
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_obs)
#' dr_plot(fit)
dr_plot.drfit <- function(x,
                          facet = TRUE,
                          xlab = "Distance",
                          ylab = "Proportion of Pings Detected", ...){
  chk_unused(...)
  .chk_fit(x)
  dr_plot_predict(x, facet = facet, xlab = xlab, ylab = ylab)
}

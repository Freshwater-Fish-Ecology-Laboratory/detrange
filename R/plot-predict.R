#' Plot Predicted Detection Range
#'
#' Generic function to plot the predicted detection range.
#'
#' @inheritParams params
#' @export
dr_plot_predict <- function(x, ...) {
  UseMethod("dr_plot_predict")
}

#' @describeIn dr_plot_predict method to plot predicted detection range from drfit object
#' @inheritParams params
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_obs)
#' dr_plot_predict(fit)
dr_plot_predict.drfit <- function(x, xlab = "Distance",
                                  ylab = "Proportion of Pings Detected",
                                  facet = TRUE, ...){
  chk_unused(...)
  .chk_fit(x)

  pred <- dr_predict_de(x)
  data <- augment(x)

  dr_plot_predict.data.frame(data, pred, xlab = xlab,
                             ylab = ylab, facet = facet)
}

#' @describeIn dr_plot_predict method to plot predicted detection range from data.frame object
#' @inheritParams params
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_obs)
#' dr_plot_predict(fit)
dr_plot_predict.data.frame <- function(x, predict_de,
                                       xlab = "Distance",
                                       ylab = "Proportion of Pings Detected",
                                       facet = TRUE, ...){
  .chk_data(x)
  .chk_predict_de(predict_de)
  chk_unused(...)
  data <- x

  gp <- ggplot() +
    geom_dr_point(data = data, aes(x = .data$Distance,
                                   detects = .data$Detects,
                                   pings = .data$Pings)) +
    ggplot2::labs(x = xlab, y = ylab)

  if(facet){
    gp <- gp + geom_dr_ribbon(data = predict_de, aes(x = .data$Distance,
                                               estimate = .data$estimate,
                                               lower = .data$lower,
                                               upper = .data$upper)) +
      facet_wrap(vars(.data$Station))
  } else {
    gp <- gp + geom_dr_ribbon(data = predict_de, aes(x = .data$Distance,
                                               estimate = .data$estimate,
                                               lower = .data$lower,
                                               upper = .data$upper,
                                               color = .data$Station,
                                               fill = .data$Station))
  }
  gp
}

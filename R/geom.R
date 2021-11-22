#' Observed Detection Range
#'
#' Add point layer of observed detection range data.
#'
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @seealso [`dr_plot()`] [`dr_plot_predict()`]
#' @family ggplot
#' @export
#' @examples
#' ggplot2::ggplot(detrange::range_obs) +
#'   geom_dr_point(ggplot2::aes(x = Distance, detects = Detects, pings = Pings))
geom_dr_point <- function(mapping = NULL, data = NULL, stat = "drPoint",
                         position = "identity", na.rm = FALSE,
                         show.legend = NA, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomDrPoint, mapping = mapping,
    data = data, stat = stat, position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' Predicted Detection Range
#'
#' Add line layer of predicted detection range estimates and
#' ribbon layer of the confidence interval.
#'
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_line
#' @inheritParams ggplot2::geom_ribbon
#' @seealso [`dr_plot()`] [`dr_plot_predict()`]
#' @family ggplot
#' @export
#' @examples
#' ggplot2::ggplot(data = detrange::range_pred) +
#'   geom_dr_ribbon(ggplot2::aes(x = Distance, estimate = estimate,
#'                                 lower = lower, upper = upper))
geom_dr_ribbon <-
  function(mapping = NULL,
           data = NULL,
           stat = "identity",
           position = "identity",
           na.rm = FALSE,
           show.legend = NA,
           inherit.aes = TRUE,
           ...) {
    layer(
      geom = GeomDrRibbon,
      mapping = mapping,
      data = data,
      stat = stat,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(na.rm = na.rm, ...)
    )
  }

#' Predicted Detection Range Point
#'
#' Add point layer of predicted detection range estimates and
#' error bar layer of the confidence interval.
#'
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @seealso [`dr_plot()`] [`dr_plot_predict()`]
#' @family ggplot
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_obs)
#' pred <- dr_predict_distance(fit)
#' ggplot2::ggplot(data = pred) +
#'   geom_dr_errorbar(ggplot2::aes(y = de, x = estimate,
#'                                 xmin = lower, xmax = upper))
geom_dr_errorbar <-
  function(mapping = NULL,
           data = NULL,
           stat = "identity",
           position = "identity",
           na.rm = FALSE,
           show.legend = NA,
           inherit.aes = TRUE,
           ...) {
    layer(
      geom = GeomDrErrorbar,
      mapping = mapping,
      data = data,
      stat = stat,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(na.rm = na.rm, ...)
    )
  }

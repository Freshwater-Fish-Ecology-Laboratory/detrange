#' Observed Detection Range
#'
#' Add point layer of observed detection range data.
#'
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @seealso [`dr_plot_observed()`]
#' @family ggplot
#' @export
#' @examples
#' ggplot2::ggplot(detrange::range_obs) +
#'   geom_dr_observed(ggplot2::aes(x = Distance, detects = Detects, pings = Pings))
geom_dr_observed <- function(mapping = NULL, data = NULL, stat = "obspoint",
                         position = "identity", na.rm = FALSE,
                         show.legend = NA, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomObspoint, mapping = mapping,
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
#' @seealso [`dr_plot_predicted()`]
#' @family ggplot
#' @export
#' @examples
#' ggplot2::ggplot(data = detrange::range_pred) +
#'   geom_dr_predicted(ggplot2::aes(x = Distance, estimate = estimate,
#'                                 lower = lower, upper = upper))
geom_dr_predicted <-
  function(mapping = NULL,
           data = NULL,
           stat = "identity",
           position = "identity",
           na.rm = FALSE,
           show.legend = NA,
           inherit.aes = TRUE,
           ...) {
    layer(
      geom = GeomPredicted,
      mapping = mapping,
      data = data,
      stat = stat,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(na.rm = na.rm, ...)
    )
  }

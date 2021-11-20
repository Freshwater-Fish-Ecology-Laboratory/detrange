#' Species Sensitivity Data Points
#'
#' Uses the empirical cumulative distribution to create scatterplot of points `x`.
#'
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @seealso [`dr_plot_observed()`]
#' @family ggplot
#' @export
#' @examples
#' ggplot2::ggplot(detrange::range_test) +
#'   geom_ssdpoint(ggplot2::aes(x = Distance, detects = Detects, pings = Pings))
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

#' Species Sensitivity Data Points
#'
#' Uses the empirical cumulative distribution to create scatterplot of points `x`.
#'
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @seealso [`dr_plot_predicted()`]
#' @family ggplot
#' @export
#' @examples
#' ggplot2::ggplot(detrange::range_test) +
#'   geom_ssdpoint(ggplot2::aes(x = Distance, detects = Detects, pings = Pings))
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
      geom = GeomPredDe,
      mapping = mapping,
      data = data,
      stat = stat,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(na.rm = na.rm, ...)
    )
  }

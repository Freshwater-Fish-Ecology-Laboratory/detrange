#' ggproto Classes for Plotting Detection Range
#'
#' @seealso [`ggplot2::ggproto()`]
#' @name detrange-ggproto
NULL

#' @rdname detrange-ggproto
#' @export
StatObspoint <- ggproto(
  "StatObspoint", Stat,
  required_aes = c("x", "detects", "pings"),
  default_aes = aes(y = ..DE..),
  compute_panel = function(data, scales) {
    data$DE <- data$detects/data$pings
    data
  }
)

#' @rdname detrange-ggproto
#' @export
GeomObspoint <- ggproto(
  "GeomObspoint", GeomPoint
)

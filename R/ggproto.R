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

#' @rdname detrange-ggproto
#' @export
GeomPredicted <- ggproto(
  "GeomPredicted",
  Geom,
  required_aes = c("x", "estimate", "lower", "upper"),
  draw_key = draw_key_path,
  default_aes = aes(
    colour = "black",
    fill = "blue",
    size = 0.5,
    ribbon_size = 0.1,
    ribbon_alpha = 0.1,
    ribbon_colour = "black",
    linetype = 1,
    alpha = 1
  ),
  setup_data = function(self, data, params) {
    data <- ggproto_parent(Geom, self)$setup_data(data, params)
    data
  },
  draw_group = function(data, panel_scales, coord) {
    data$y <- data$estimate
    data$ymin <- data$lower
    data$ymax <- data$upper

    dfrib <- data
    dfrib$alpha <- data$ribbon_alpha
    dfrib$size <- data$ribbon_size
    dfrib$colour <- data$ribbon_colour

    est_grob <- GeomLine$draw_panel(data, panel_scales, coord)
    int_grob <- GeomRibbon$draw_panel(dfrib, panel_scales, coord)

    ggplot2:::ggname("geom_dr_predicted",
                     grid::grobTree(int_grob, est_grob))

  }
)



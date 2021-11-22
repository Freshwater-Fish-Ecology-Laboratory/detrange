#' ggproto Classes for Plotting Detection Range
#'
#' @seealso [`ggplot2::ggproto()`]
#' @name detrange-ggproto
NULL

#' @rdname detrange-ggproto
#' @export
StatDrPoint <- ggproto(
  "StatDrPoint", Stat,
  required_aes = c("x", "detects", "pings"),
  default_aes = aes(y = ..DE..),
  compute_panel = function(data, scales) {
    data$DE <- data$detects/data$pings
    data
  }
)

#' @rdname detrange-ggproto
#' @export
GeomDrPoint <- ggproto(
  "GeomDrPoint", GeomPoint
)

#' @rdname detrange-ggproto
#' @export
GeomDrRibbon <- ggproto(
  "GeomDrRibbon",
  Geom,
  required_aes = c("x", "estimate", "lower", "upper"),
  draw_key = draw_key_path,
  default_aes = aes(
    colour = "black",
    fill = "blue",
    size = 0.5,
    size_ribbon = 0.1,
    alpha_ribbon = 0.1,
    colour_ribbon = "black",
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
    dfrib$alpha <- data$alpha_ribbon
    dfrib$size <- data$size_ribbon
    dfrib$colour <- data$colour_ribbon

    est_grob <- GeomLine$draw_panel(data, panel_scales, coord)
    int_grob <- GeomRibbon$draw_panel(dfrib, panel_scales, coord)

    ggplot2:::ggname("geom_dr_predicted",
                     grid::grobTree(int_grob, est_grob))

  }
)

#' @rdname detrange-ggproto
#' @export
GeomDrErrorbar <- ggproto(
  "GeomDrErrorbar",
  GeomPoint,
  required_aes = c("y", "x", "xmin", "xmax"),
  default_aes = aes(
    shape = 19,
    colour = "red",
    size = 1.5,
    size_errorbar = 0.5,
    fill = NA,
    alpha = NA,
    linetype = 1,
    stroke = 0.5,
    height = 0.04,
  ),
  draw_panel = function(data, panel_params, coord) {

    data_errbarh <- transform(data,
                              size = size_errorbar,
                              ymin = y - height/2,
                              ymax = y + height/2)

    errorbarh_grob <- GeomErrorbarh$draw_panel(data = data_errbarh,
                                               panel_params = panel_params,
                                               coord = coord)
    point_grob <- GeomPoint$draw_panel(data = data,
                                       panel_params = panel_params,
                                       coord = coord)
    gt <- grid::grobTree(
      errorbarh_grob,
      point_grob,
      name = 'geom_dr_errorbar')
    gt
  }
)


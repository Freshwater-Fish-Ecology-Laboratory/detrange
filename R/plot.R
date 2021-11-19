

#' Plot predicted detection range and midpoint
#'
#' Plot predicted detection range and midpoint from analysis output of `dr_fit`,
#'
#' @inheritParams params
#' @return A ggplot2 object.
#' @family plot
#' @export
#' @examples
#' \dontrun{
#' dr_plot(detrange::range_test)
#' }
dr_plot <- function(data){
  chk_range_test(data)

  gp <- ggplot() +
    ggplot2::geom_point(data = data, aes(y = .data$Detects/.data$Pings, x = .data$Distance)) +
    ggplot2::facet_wrap(ggplot2::vars(.data$Station)) +
    ggplot2::labs(x = "Distance", y = "Proportion of Pings Detected")
  gp
}

#' Add geom predicted
#'
#' Add layer of predicted DE at distance to ggplot created by `dr_plot()`
#'
#' @inheritParams params
#' @return A ggplot2 object.
#' @family plot
#' @export
#' @examples
#' \dontrun{
#' dr_plot(range_test) %>% add_geom_predicted(predicted)
#' }
add_geom_predicted <- function(gp, predicted){
  chk_s3_class(gp, "ggplot")
  chk_predicted(predicted)
    gp <- gp +
      ggplot2::geom_line(data = predicted, aes(x = .data$Distance, y = .data$estimate)) +
      ggplot2::geom_line(data = predicted, aes(x = .data$Distance, y = .data$lower), linetype = "dotted") +
      ggplot2::geom_line(data = predicted, aes(x = .data$Distance, y = .data$upper), linetype = "dotted")
   gp
}

#' Add geom distance at De
#'
#' Add layer of predicted distance at target DE to ggplot created by `dr_plot()`
#'
#' @inheritParams params
#' @return A ggplot2 object.
#' @family plot
#' @export
#' @examples
#' \dontrun{
#' dr_plot(range_test) %>%
#' add_geom_predicted(predicted) %>%
#' add_geom_distance_at_de(distance_at_de)
#' }
add_geom_predicted_distance <- function(gp, distance_at_de){
    chk_s3_class(gp, "ggplot")
    .chk_predicted_distance(distance_at_de)
    de <- unique(distance_at_de$de)
    gp <- gp +
      ggplot2::geom_errorbarh(data = distance_at_de, aes(xmin = .data$lower,
                                                         xmax = .data$upper,
                                                         y = de),
                              height = .05, color = "red") +
      ggplot2::geom_point(data = distance_at_de, aes(x = .data$estimate, y = de), color = "red") +
      ggplot2::geom_vline(data = distance_at_de, aes(xintercept = .data$estimate),
                          linetype = "longdash", size = 0.2)
  gp
}

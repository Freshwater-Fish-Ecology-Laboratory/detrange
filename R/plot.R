#' Plot range test
#'
#' Plot observed range test data
#'
#' @inheritParams params
#' @return A ggplot2 object.
#' @family plot
#' @export
#' @examples
#' dr_plot_observed(detrange::range_test)

dr_plot_observed <- function(data){
  chk_range_test(data)
  ggplot(data = data, aes(x = .data$Distance, y = .data$Detects/.data$Pings)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(ggplot2::vars(.data$Station)) +
    ggplot2::labs(x = "Distance", y = "Proportion of Pings Detected")
}

#' Plot predicted detection range and midpoint
#'
#' Plot predicted detection range and midpoint from analysis output of `dr_analyse`,
#'
#' @inheritParams params
#' @return A ggplot2 object.
#' @family plot
#' @export
#' @examples
#' \dontrun{
#' dr_plot(analysis)
#' }

dr_plot <- function(data, predicted = NULL, distance_at_de = NULL){
  message("add method for data.frame predicted and for anlalysis object")
  chk_range_test(data)

  gp <- ggplot() +
    ggplot2::geom_point(data = data, aes(y = .data$Detects/.data$Pings, x = .data$Distance)) +
    ggplot2::facet_wrap(ggplot2::vars(.data$Station)) +
    ggplot2::labs(x = "Distance", y = "Proportion of Pings Detected")

  if(!is.null(predicted)){
    gp <- gp +
      ggplot2::geom_line(data = predicted, aes(x = .data$Distance, y = .data$estimate)) +
      ggplot2::geom_line(data = predicted, aes(x = .data$Distance, y = .data$lower), linetype = "dotted") +
      ggplot2::geom_line(data = predicted, aes(x = .data$Distance, y = .data$upper), linetype = "dotted")
  }

  if(!is.null(distance_at_de)){
    de <- unique(distance_at_de$de)
    gp <- gp +
      ggplot2::geom_errorbarh(data = distance_at_de, aes(xmin = .data$lower,
                                                         xmax = .data$upper,
                                                         y = de),
                              height = .05, color = "red") +
      ggplot2::geom_point(data = distance_at_de, aes(x = .data$estimate, y = de), color = "red") +
      ggplot2::geom_vline(data = distance_at_de, aes(xintercept = .data$estimate),
                          linetype = "longdash", size = 0.2)
  }
  gp
}

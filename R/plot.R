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
#' dr_plot_predicted(analysis)
#' }

dr_plot_predicted <- function(analysis){
  message("add method for data.frame predicted and for anlalysis object")
  # chk_s3_class(analysis, "jmb_analysis")
  #
  # predicted <- dr_analysis_predict(analysis)
  # midpoint <- dr_analysis_midpoint(analysis)
  # data <- mbr::data_set(analysis)
  #
  # gp <- ggplot() +
  #   ggplot2::geom_point(data = data, aes(y = .data$Detects/.data$Pings, x = .data$Distance)) +
  #   ggplot2::geom_errorbarh(data = midpoint, aes(xmin = .data$lower,
  #                                       xmax = .data$upper,
  #                                       y = de_target),
  #                  height = .05, color = "red") +
  #   ggplot2::geom_point(data = midpoint, aes(x = .data$estimate, y = de_target), color = "red") +
  #   ggplot2::geom_vline(data = midpoint, aes(xintercept = .data$estimate),
  #              linetype = "longdash", size = 0.2) +
  #   ggplot2::geom_line(data = predicted, aes(x = .data$Distance, y = .data$estimate)) +
  #   ggplot2::geom_line(data = predicted, aes(x = .data$Distance, y = .data$lower), linetype = "dotted") +
  #   ggplot2::geom_line(data = predicted, aes(x = .data$Distance, y = .data$upper), linetype = "dotted") +
  #   ggplot2::facet_wrap(ggplot2::vars(.data$Station)) +
  #   ggplot2::labs(x = "Distance", y = "Proportion of Pings Detected") +
  #   NULL
  #
  # gp
}

#' Plot range test
#'
#' Plot observed range test data
#'
#' @inheritParams params
#' @return A ggplot2 object.
#' @family plot
#' @export
#' @examples
#' \dontrun{
#' dr_plot_observed(detrange::range_test)
#' }

dr_plot_observed <- function(data){
  chk_range_test(data)
  ggplot2::ggplot(data = data, ggplot2::aes(x = Distance, y = Detects/Pings)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~Station) +
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
  chk_s3_class(analysis, "jmb_analysis")

  prediction <- dr_analysis_predict(analysis)
  midpoint <- dr_analysis_midpoint(analysis)

  gp <- ggplot() +
    geom_point(data = data, aes(y = Detects/Pings, x = Distance)) +
    geom_errorbarh(data = midpoint, aes(xmin = lower,
                                        xmax = upper,
                                        y = 0.5),
                   height = .05, color = "red") +
    geom_point(data = midpoint, aes(x = estimate, y = 0.5), color = "red") +
    geom_vline(data = midpoint, aes(xintercept = estimate),
               linetype = "longdash", size = 0.3) +
    geom_line(data = prediction, aes(x = Distance, y = estimate)) +
    geom_line(data = prediction, aes(x = Distance, y = lower), linetype = "dotted") +
    geom_line(data = prediction, aes(x = Distance, y = upper), linetype = "dotted") +
    facet_wrap(~Station) +
    labs(x = "Distance", y = "Proportion of Pings Detected") +
    NULL

  gp
}

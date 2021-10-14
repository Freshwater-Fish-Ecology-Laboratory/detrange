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
#' dr_plot_range_test(detrange::range_test)
#' }

dr_plot_range_test <- function(data){
  chk_range_test(data)
  ggplot2::ggplot(data = data, ggplot2::aes(x = Distance, y = Detects/Pings)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~Station) +
    ggplot2::labs(x = "Distance (m)", y = "Proportion of Pings Detected")
}

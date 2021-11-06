#' Predict detection range
#'
#' Predict detection range from model object output of `dr_analyse`.
#'
#' @inheritParams params
#' @return A tibble of the coefficients.
#' @export
#' @family analysis
dr_analysis_predict <- function(analysis,
                                distance_seq = NULL,
                                by_station = TRUE){

  mbr::check_mb_analysis(analysis)
  chkor_vld(is.null(distance_seq), all(is.numeric(distance_seq)))

  new_data_cols <- "Distance"
  if(by_station){
    new_data_cols <- c("Distance", "Station")
  }

  data <- new_data_cols
  if(!is.null(distance_seq)){
    if(by_station){
      data <- newdata::new_data(data = mbr::data_set(analysis),
                                seq = "Station",
                                ref = list(Distance = distance_seq))
    } else {
      data <- newdata::new_data(data = mbr::data_set(analysis),
                                ref = list(Distance = distance_seq))
    }
  }

  mbr::predict(analysis, new_data = data)

}

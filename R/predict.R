new_data <- function(analysis, by = "Station", distance_seq){
  if(is.null(by)) by <- character(0)

  data <- data_set(analysis)

  if(is.null(distance_seq))
    distance_seq <- newdata::new_seq(data$Distance, length_out = 30)

  newdata::new_data(data = data,
                    seq = by,
                    ref = list(Distance = distance_seq))
}

predict <- function(analysis, new_data, conf_level = 0.95, estimate = median){
  model_type <- model_type(analysis)
  new_expr <- new_expr(model_type)
  samples <- samples(analysis)

  derived <- mcmcderive::mcmc_derive(samples,
                                     expr = new_expr,
                                     monitor = "prediction",
                                     values = new_data,
                                     silent = TRUE)

  prediction <- derived$prediction
  coef <- mcmcr::coef(prediction, estimate = estimate, conf_level = conf_level)
  data <- cbind(new_data, coef[, c("estimate", "lower", "upper")])
  data
}

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
                                by = "Station",
                                conf_level = 0.95,
                                estimate = median){

  chk_analysis(analysis)
  chkor_vld(vld_null(distance_seq), vld_numeric(distance_seq))
  chkor_vld(vld_null(by), vld_subset(by, c("Station", character(0))))
  chk_number(conf_level)
  chk_gte(conf_level, 0)
  chk_lte(conf_level, 1)
  chk_is(estimate, "function")

  new_data <- new_data(analysis, by, distance_seq)
  predict(analysis, new_data, conf_level, estimate)
}

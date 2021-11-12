new_data <- function(analysis, seq, ref){
  data <- data_df(analysis)

  newdata::new_data(data = data,
                    seq = seq,
                    ref = ref)
}

predict <- function(analysis, new_data, new_expr, monitor, conf_level = 0.95,
                    estimate = median){
  samples <- samples(analysis)

  derived <- mcmcderive::mcmc_derive(samples,
                                     expr = new_expr,
                                     monitor = monitor,
                                     values = new_data,
                                     silent = TRUE)

  x <- derived[[monitor]]
  coef <- mcmcr::coef(x, estimate = estimate, conf_level = conf_level)
  data <- cbind(new_data, coef[, c("estimate", "lower", "upper", "svalue")])
  data
}

#' Predict detection range
#'
#' Predict detection efficiency at distance sequence from model object output of `dr_analyse`.
#'
#' @inheritParams params
#' @return A tibble of the coefficients.
#' @export
#' @family analysis
dr_predict <- function(analysis,
                       by = "Station",
                       distance_seq = NULL,
                       conf_level = 0.95,
                       estimate = median){

  chk_analysis(analysis)
  chkor_vld(vld_null(distance_seq), vld_numeric(distance_seq))
  chkor_vld(vld_null(by), vld_subset(by, c("Station", character(0))))
  chk_number(conf_level)
  chk_gte(conf_level, 0)
  chk_lte(conf_level, 1)
  chk_is(estimate, "function")

  seq <- if(is.null(by)) character(0) else by
  if(is.null(distance_seq)){
    seq <- c(seq, "Distance")
    ref <- list()
  } else {
    ref <- list(Distance = distance_seq)
  }

  new_data <- new_data(analysis, seq = seq, ref = ref)

  model_type <- model_type(analysis)
  new_expr <- new_expr(model_type, "prediction")

  x <- predict(analysis, new_data, new_expr, conf_level,
          estimate, monitor = "prediction")
  x[, unique(c(seq, "Distance", "estimate", "lower", "upper", "svalue"))]
}

#' Predict distance at target DE
#'
#' Predict distance at target detection efficiency from model object output of `dr_analyse`.
#'
#' @inheritParams params
#' @return A tibble of the coefficients.
#' @export
#' @family analysis
dr_distance_at_de <- function(analysis,
                              de_target = 0.5,
                              by = "Station",
                              conf_level = 0.95,
                              estimate = median){

  chk_analysis(analysis)
  chk_number(de_target)
  chk_gte(de_target, 0)
  chk_lte(de_target, 1)
  chkor_vld(vld_null(by), vld_subset(by, c("Station", character(0))))
  chk_number(conf_level)
  chk_gte(conf_level, 0)
  chk_lte(conf_level, 1)
  chk_is(estimate, "function")

  seq <- if(is.null(by)) character(0) else by
  new_data <- new_data(analysis, seq, ref = list())
  model_type <- model_type(analysis)
  de_logit <- logit(de_target)
  new_expr <- new_expr(model_type, "target", de_logit = de_logit)

  x <- predict(analysis, new_data, new_expr, conf_level,
          estimate, monitor = "target")
  x[, c(seq, "estimate", "lower", "upper", "svalue")]
}

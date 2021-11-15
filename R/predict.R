new_data <- function(x, seq, ref){
  data <- data_df(x)

  newdata::new_data(data = data,
                    seq = seq,
                    ref = ref)
}

predict <- function(x, new_data, new_expr, monitor, conf_level = 0.95,
                    estimate = median){
  samples <- samples(x)

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

clean_predict <- function(x, seq){
  x <- x[, unique(c(seq, "Distance", "estimate", "lower", "upper", "svalue"))]
  if("Station" %in% names(x))
    x <- x[order(x$Station), , drop = FALSE]
  x
}

#' Predict detection range
#'
#' Predict detection efficiency at distance sequence from model object output of `dr_fit`.
#'
#' @inheritParams params
#' @return A tibble of the coefficients.
#' @export
#' @family analysis
dr_predict <- function(x,
                       by = "Station",
                       distance_seq = NULL,
                       conf_level = 0.95,
                       estimate = median){

  chk_fit(x)
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

  new_data <- new_data(x, seq = seq, ref = ref)

  model_type <- model_type(x)
  new_expr <- new_expr(model_type, "prediction")

  x <- predict(x, new_data, new_expr, conf_level,
          estimate, monitor = "prediction")
  clean_predict(x, seq)
}

#' Predict distance at target DE
#'
#' Predict distance at target detection efficiency from model object output of `dr_analyse`.
#'
#' @inheritParams params
#' @return A tibble of the coefficients.
#' @export
#' @family analysis
dr_distance_at_de <- function(x,
                              de_target = 0.5,
                              by = "Station",
                              conf_level = 0.95,
                              estimate = median){

  chk_fit(x)
  chk_number(de_target)
  chk_gte(de_target, 0)
  chk_lte(de_target, 1)
  chkor_vld(vld_null(by), vld_subset(by, c("Station", character(0))))
  chk_number(conf_level)
  chk_gte(conf_level, 0)
  chk_lte(conf_level, 1)
  chk_is(estimate, "function")

  seq <- if(is.null(by)) character(0) else by
  new_data <- new_data(x, seq, ref = list())
  model_type <- model_type(x)
  de_logit <- logit(de_target)
  new_expr <- new_expr(model_type, "target", de_logit = de_logit)

  x <- predict(x, new_data, new_expr, conf_level,
          estimate, monitor = "target")
  x <- clean_predict(x, seq)
  x$de <- de_target
  x
}

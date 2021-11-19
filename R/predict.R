.new_data <- function(x, seq, ref){
  newdata::new_data(data = x,
                    seq = seq,
                    ref = ref)
}

.predict <- function(x, new_data, derived_expr, monitor,
                    conf_level = 0.95, estimate = median){

  samples <- .samples(x)
  derived <- mcmcderive::mcmc_derive(samples,
                                     expr = derived_expr,
                                     monitor = monitor,
                                     values = new_data,
                                     silent = TRUE)

  x <- derived[[monitor]]
  coef <- mcmcr::coef(x, estimate = estimate, conf_level = conf_level)
  data <- cbind(new_data, coef[, c("estimate", "lower", "upper", "svalue")])
  data
}

clean_predict <- function(x, seq, ref){
  cols <- intersect(c(seq, names(ref), "de", "estimate", "lower", "upper", "svalue"), names(x))
  x <- x[, cols]
  if("Station" %in% names(x))
    x <- x[order(x$Station), , drop = FALSE]
  x
}

#' Predict detection efficiency
#'
#' Predict detection efficiency at specified distance(s).
#'
#' @inheritParams params
#' @return A tibble of the coefficients.
#' @export
#' @family analysis
dr_predict_de <- function(x,
                       distance,
                       by = "Station",
                       conf_level = 0.95,
                       estimate = median){

  .chk_fit(x)
  chkor_vld(vld_numeric(distance) & vld_gte(distance, 0),
            vld_identical(distance, numeric(0)),
            vld_identical(distance, NULL))
  chkor_vld(vld_subset(by, "Station"),
            vld_identical(by, character(0)),
            vld_identical(by, NULL),
            vld_identical(by, ""))
  chk_number(conf_level)
  chk_gte(conf_level, 0)
  chk_lte(conf_level, 1)
  chk_is(estimate, "function")

  seq <- to_ch0(by)
  if(!length(distance)){
    seq <- c(seq, "Distance")
    ref <- list()
  } else {
    ref <- list(Distance = distance)
  }

  data <- .augment(x)
  new_data <- .new_data(data, seq = seq, ref = ref)

  model_type <- .model_type_drfit(x)
  random_intercept <- .random_intercept_drfit(x)
  template <- .template(model_type, random_intercept)
  derived_expr <- .derived(template)

  x <- .predict(x, new_data, derived_expr, conf_level,
          estimate, monitor = "prediction")
  clean_predict(x, seq, ref)
}

#' Predict distance
#'
#' Predict distance at specified detection efficiency or vector of detection efficiencies.
#'
#' @inheritParams params
#' @return A tibble of the coefficients.
#' @export
#' @family analysis
dr_predict_distance <- function(x,
                              de,
                              by = "Station",
                              conf_level = 0.95,
                              estimate = median){

  .chk_fit(x)
  chk_numeric(de)
  chk_gte(de, 0)
  chk_lte(de, 1)
  chkor_vld(vld_subset(by, "Station"),
            vld_identical(by, character(0)),
            vld_identical(by, NULL),
            vld_identical(by, ""))
  chk_number(conf_level)
  chk_gte(conf_level, 0)
  chk_lte(conf_level, 1)
  chk_is(estimate, "function")

  seq <- to_ch0(by)
  data <- .augment(x)
  data$DELogit <- 0
  delogit <- logit(de)
  ref <- list(DELogit = delogit)
  new_data <- .new_data(data, seq, ref = ref)

  model_type <- .model_type_drfit(x)
  random_intercept <- .random_intercept_drfit(x)
  template <- .template(model_type, random_intercept)
  derived_expr <- .derived(template)

  x <- .predict(x, new_data, derived_expr, conf_level,
          estimate, monitor = "target")
  x$de <- plogis(x$DELogit)
  x$DELogit <- NULL
  clean_predict(x, seq, ref)
}

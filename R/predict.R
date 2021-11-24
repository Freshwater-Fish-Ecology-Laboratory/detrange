.new_data <- function(x, seq, ref){
  newdata::new_data(data = x,
                    seq = seq,
                    ref = ref)
}

.predict <- function(x, new_data, derived_expr, monitor,
                    conf_level = 0.95, estimate = median){

  samples <- samples(x)
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

#' @export
stats::predict

#' Predict Detection Efficiency
#'
#' A wrapper on [`dr_predict_de()`] that by default predicts
#' detection efficiency over the range of distance in data.
#'
#' It is useful for plotting purposes.
#'
#' @inheritParams params
#' @export
#' @seealso [`dr_predict_de()`]
#' @examples
#' fit <- dr_fit(detrange::range_obs)
#' predict(fit)
predict.drfit <- function(object,
                          distance = NULL,
                          by = "Station",
                          conf_level = 0.95,
                          estimate = median, ...){
  chk_unused(...)
  dr_predict_de(object, distance, by, conf_level, estimate)
}

#' Predict Detection Efficiency
#'
#' Predict detection efficiency at specified distance(s).
#' By default, detection efficiency is predicted over the data distance range.
#'
#' @inheritParams params
#' @return A tibble of the predicted detection efficiency.
#' @export
#' @family analysis
dr_predict_de <- function(x,
                       distance = NULL,
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

  data <- augment(x)

  seq <- to_ch0(by)
  if(!length(distance))
    distance <- seq(0, ceiling100(max(data$Distance)), 30)

  ref <- list(Distance = distance)
  new_data <- .new_data(data, seq = seq, ref = ref)

  model_type <- .model_drfit(x)
  template <- template_derived(model_type)

  x <- .predict(x, new_data, template, conf_level,
          estimate, monitor = "prediction")
  clean_predict(x, seq, ref)
}

#' Predict Distance
#'
#' Predict distance at vector of detection efficiencies.
#' By default, the midpoint (`de = 0.5`) is predicted.
#'
#' @inheritParams params
#' @return A tibble of the predicted distance estimates.
#' @export
#' @family analysis
dr_predict_distance <- function(x,
                              de = 0.5,
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
  data <- augment(x)
  data$DELogit <- 0
  delogit <- logit(de)
  ref <- list(DELogit = delogit)
  new_data <- .new_data(data, seq, ref = ref)

  model_type <- .model_drfit(x)
  template <- template_derived(model_type)

  x <- .predict(x, new_data, template, conf_level,
          estimate, monitor = "target")
  x$de <- plogis(x$DELogit)
  x$DELogit <- NULL
  clean_predict(x, seq, ref)
}

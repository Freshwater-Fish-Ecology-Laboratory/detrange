#' Analyse model
#'
#' Analyse detection range test data with a Bayesian mixed-effects model. Each station has a random slope and intercept.
#' Note that with fewer data points per station, priors will have strong influence on the posterior.
#' The default priors are based on understanding of typical detection range.
#'
#' @inheritParams params
#' @return A mbr model object.
#' @aliases dr_analyze
#' @export
#' @family analysis
dr_analyse <- function(data, de_target = 0.5, priors = rsi_priors, nthin = 10L){

  chk_whole_number(nthin)
  chk_gte(nthin, value = 1L)
  chk_rsi_priors(priors)
  chk_range_test(data)
  chk_number(de_target)
  chk_gte(de_target, 0)
  chk_lte(de_target, 1)

  de_logit <- logit(de_target)

  template <- jags_template_rsi(de_logit = de_logit, priors = priors, nthin = nthin)
  mbr::analyse(template, data = data, silent = TRUE)
}

#' Get model coefficients
#'
#' Get coefficients from model object output of `dr_analyse`.
#'
#' @inheritParams params
#' @return A tibble of the coefficients.
#' @export
#' @family analysis
dr_analysis_coef <- function(analysis, include_random = FALSE){

  mbr::check_mb_analysis(analysis)

  coefs <- mbr::coef(analysis, simplify = TRUE)
  if(include_random){
   rndm <-  mbr::coef(analysis, simplify = TRUE, param_type = "random")
   coefs <- rbind(coefs, rndm)
  }
  coefs
}

#' Get midpoint estimates
#'
#' Get estimates of midpoints for each station from model object output of `dr_analyse`.
#'
#' @inheritParams params
#' @return A tibble of the estimates.
#' @export
#' @family analysis
dr_analysis_midpoint <- function(analysis){

  mbr::check_mb_analysis(analysis)
  predicted <- mbr::predict(analysis, new_data = "Station", term = c("eMidpoint"))
  predicted[,c("Station", "estimate", "lower", "upper", "svalue")]
}

#' Get analysis glance summary
#'
#' Get analysis glance summary from model object output of `dr_analyse`.
#'
#' @inheritParams params
#' @return A tibble of the glance summary.
#' @export
#' @family analysis
dr_analysis_glance <- function(analysis){

  mbr::check_mb_analysis(analysis)
  mbr::glance(analysis, simplify = TRUE)
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
                                distance_seq = NULL){

  mbr::check_mb_analysis(analysis)
  chkor_vld(is.null(distance_seq), all(is.numeric(distance_seq)))

  if(is.null(distance_seq)){
    return(mbr::predict(analysis, new_data = c("Distance", "Station")))
  } else {
    data <-  newdata::new_data(data = mbr::data_set(analysis),
                               seq = c("Station"),
                               ref = list(Distance = distance_seq))
   return(mbr::predict(analysis, new_data = data))
  }
}


#' Analyse model
#'
#' Analyse detection range test data with a Bayesian model fit with JAGS.
#' Each station has a random slope and intercept.
#'
#' @inheritParams params
#' @return A list of the jags model object and mcmcr samples.
#' @aliases dr_analyze
#' @export
#' @family analysis
dr_analyse <- function(data, de_target = 0.5, nthin = 10L,
                       priors = NULL, quiet = TRUE){

  chk_range_test(data)
  data_list <- df_to_list(data)
  model <- if(data_list$nStation >= 5) "random" else "fixed"
  chk_priors(priors, model)
  chk_number(de_target)
  chk_gte(de_target, 0)
  chk_lte(de_target, 1)
  chk_whole_number(nthin)
  chk_gte(nthin, value = 1L)
  chk_flag(quiet)

  de <- logit(de_target)
  priors <- replace_priors(priors(model), priors)
  template <- template(de, priors, model)
  monitors <- monitors(model)

  run <- run_jags(template = template, data = data_list, monitor = monitors,
                  inits = NULL, niters = 1000, nchains = 3,
                  nthin = nthin, quiet = quiet)

  attr(run, 'model_type') <- model
  run
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

  # mbr::check_mb_analysis(analysis)
  #
  # nstation <- length(unique(mbr::data_set(analysis)$Station))
  # param_desc <- param_description(n = nstation)
  # coefs <- mbr::coef(analysis, simplify = TRUE)
  # if(include_random){
  #  rndm <-  mbr::coef(analysis, simplify = TRUE, param_type = "random")
  #  coefs <- rbind(coefs, rndm)
  # }
  # tibble::as_tibble(merge(coefs, param_desc, by = "term", all.x = TRUE))
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

  # mbr::check_mb_analysis(analysis)
  # predicted <- mbr::predict(analysis, new_data = "Station", term = c("eMidpoint"))
  # predicted[,c("Station", "estimate", "lower", "upper", "svalue")]
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

  # mbr::check_mb_analysis(analysis)
  # mbr::glance(analysis, simplify = TRUE)
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

  # mbr::check_mb_analysis(analysis)
  # chkor_vld(is.null(distance_seq), all(is.numeric(distance_seq)))
  #
  # if(is.null(distance_seq)){
  #   return(mbr::predict(analysis, new_data = c("Distance", "Station")))
  # } else {
  #   data <-  newdata::new_data(data = mbr::data_set(analysis),
  #                              seq = c("Station"),
  #                              ref = list(Distance = distance_seq))
  #  return(mbr::predict(analysis, new_data = data))
  # }
}


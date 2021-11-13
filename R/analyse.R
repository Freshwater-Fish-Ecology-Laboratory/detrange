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
dr_analyse <- function(data, nthin = 10L,
                       priors = NULL, quiet = TRUE){

  chk_range_test(data)
  data_list <- df_to_list(data)
  model <- if(data_list$nStation >= 5) "random" else "fixed"
  chk_priors(priors, model)
  chk_whole_number(nthin)
  chk_gte(nthin, value = 1L)
  chk_flag(quiet)

  priors <- replace_priors(priors(model), priors)
  template <- template(model, priors)
  monitors <- monitors(model)

  run <- run_jags(template = template, data = data_list, monitor = monitors,
                  inits = NULL, niters = 1000, nchains = 3,
                  nthin = nthin, quiet = quiet)

  attr(run, 'model_type') <- model
  attr(run, 'nthin') <- nthin
  attr(run, 'priors') <- priors
  class(run) <- 'dr_model'
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
dr_coef <- function(analysis, conf_level = 0.95,
                    estimate = median, random_effects = FALSE){

  chk_analysis(analysis)
  data <- data_set(analysis)
  samples <- samples(analysis)
  model <- attr(analysis, "model_type")

  nstation <- data$nStation

  param_desc <- param_description(n = nstation, model)
  coefs <- mcmcr::coef(samples, conf_level = conf_level, estimate = estimate)
  coefs <- merge(coefs, param_desc, by = "term", all.x = TRUE)
  if(!random_effects)
    coefs <- coefs[!coefs$random,]
  coefs$random <- NULL

  tibble::as_tibble(coefs)
}

#' Get analysis glance summary
#'
#' Get analysis glance summary from model object output of `dr_analyse`.
#'
#' @inheritParams params
#' @return A tibble of the glance summary.
#' @export
#' @family analysis
dr_glance <- function(analysis){

  chk_analysis(analysis)
  tibble::tibble(n = n(analysis),
                 K = K(analysis),
                 nchains = nchains(analysis),
                 niters = niters(analysis),
                 nthin = nthin(analysis),
                 ess = ess(analysis),
                 rhat = rhat(analysis),
                 converged = converged(analysis))
}


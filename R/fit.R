.coef <- function(samples, conf_level, estimate, description, random_effects){
  coefs <- mcmcr::coef(samples, conf_level = conf_level, estimate = estimate)
  coefs <- merge(coefs, description, by = "term", all.x = TRUE)
  if(!random_effects)
    coefs <- coefs[!coefs$random,]
  coefs$random <- NULL
  coefs
}

#' Analyse model
#'
#' Analyse detection range test data with a Bayesian model fit with JAGS.
#' Each station has a random slope and intercept.
#'
#' @inheritParams params
#' @return A list of the jags model object and mcmcr samples.
#' @aliases dr_fit
#' @export
#' @family fit
dr_fit <- function(data,
                   nthin = 10,
                   min_random = 5,
                   random_intercept = FALSE,
                   priors = NULL,
                   quiet = TRUE){

  .chk_data(data)
  chk_whole_number(min_random)
  .chk_priors(priors)
  chk_whole_number(nthin)
  chk_gte(nthin, value = 1L)
  chk_flag(quiet)

  data_list <- df_to_list(data)
  model_type <- if(data_list$nStation >= min_random) "random" else "fixed"
  terms <- .terms()
  default_priors <- .priors(terms)
  priors <- replace_priors(default_priors, priors)
  template <- .template(model_type, random_intercept)
  template_model <- .model(template, priors)
  monitors <- .monitors(terms)

  fit <- run_jags(template = template_model,
                  data = data_list, monitor = monitors,
                  inits = NULL, niters = 1000, nchains = 3,
                  nthin = nthin, quiet = quiet)

  attrs <- list(nthin = nthin,
                n = nrow(data),
                model_type = model_type,
                random_intercept = random_intercept)

  .attrs_drfit(fit) <- attrs
  fit$data <- data
  drfit(fit)
}

#' Get model coefficients
#'
#' Get coefficients from model object output of `dr_fit`.
#'
#' @inheritParams params
#' @return A tibble of the coefficients.
#' @export
#' @family analysis
dr_coef <- function(x, conf_level = 0.95,
                    estimate = median, random_effects = FALSE){

  .chk_fit(x)
  data <- .data_set(x)
  samples <- .samples(x)
  model <- .model_type_drfit(x)

  nstation <- data$nStation
  description <- .description(n = nstation)
  if(model == "fixed")
    description$random <- FALSE

  coefs <- .coef(samples, conf_level, estimate, description, random_effects)

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
dr_glance <- function(x){

  .chk_fit(x)
  tibble::tibble(n = .n_drfit(x),
                 K = .K(x),
                 nchains = .nchains(x),
                 niters = .niters(x),
                 nthin = .nthin_drfit(x),
                 ess = .ess(x),
                 rhat = .rhat(x),
                 converged = .converged(x))
}


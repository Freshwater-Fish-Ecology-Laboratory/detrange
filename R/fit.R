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



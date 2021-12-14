model_type <- function(nstation, min_random_intercept, min_random_slope){
  slope <- nstation >= min_random_slope
  intercept <- nstation >= min_random_intercept
  m <- "f"
  if(!slope & intercept)
    m <- "ri"
  if(slope & !intercept)
    m <- "rs"
  if(slope & intercept)
    m <- "rsri"
  m
}

nstation <- function(data){
  length(unique(data$Station))
}

set_factors <- function(data){
  data$Station <- factor(data$Station)
  data
}

#' Fit Detection Range Model
#'
#' Fit detection range model using JAGS.
#' If the number of stations is < min_random, a fixed-effects model is fit.
#' Otherwise, a mixed-effects model is fit with random slope for each station.
#' If random_intercept = TRUE, a random intercept is also fit for each station.
#'
#' @inheritParams params
#' @return A list of the jags model object and mcmcr samples.
#' @export
#' @family model
dr_fit <- function(data,
                   nthin = 10,
                   min_random_slope = 5,
                   min_random_intercept = 5,
                   priors = NULL,
                   quiet = TRUE,
                   seed = .rndm_seed()){

  .chk_data(data)
  chk_whole_number(min_random_slope)
  chk_whole_number(min_random_intercept)
  chk_whole_number(nthin)
  chk_gte(nthin, value = 1L)
  chk_flag(quiet)
  chk_whole_number(seed)
  chk_gte(seed, 0)

  # reset factor so doesnt cause issues down the line
  data <- set_factors(data)
  datal <- data_list(data)
  nstation <- nstation(datal)
  model <- model_type(nstation, min_random_intercept, min_random_slope)
  req_params <- template_params(model)
  .chk_priors(priors, req_params)

  default_priors <- priors()
  priors <- replace_priors(default_priors, priors)
  template <- template_model(model, priors)
  monitor <- monitors()

  ### in case of fixed model remove nStation and Station
  if(model == "f"){
    datal$Station <- NULL
    datal$nStation <- NULL
  }

  fit <- run_jags(template = template,
                  data = datal, monitor = monitor,
                  inits = NULL, niters = 1000, nchains = 3,
                  nthin = nthin, quiet = quiet, seed = seed)

  attrs <- list(nthin = nthin,
                n = nrow(data),
                model = model)

  .attrs_drfit(fit) <- attrs
  fit$data <- data
  drfit(fit)
}



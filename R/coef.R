#' @export
stats::coef

#' Get Tidy Tibble from drfit Object.
#'
#' A wrapper on [`tidy.drfit()`].
#'
#' @inheritParams params
#' @seealso [`tidy.drfit()`]
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_obs)
#' coef(fit)
coef.drfit <- function(object, conf_level = 0.95, estimate = median,
                       random_effects = FALSE, ...){
  chk_unused(...)
  dr_coef(object, conf_level, estimate, random_effects)
}


dr_coef <- function(x, conf_level = 0.95,
                    estimate = median, random_effects = FALSE){

  .chk_fit(x)
  data <- data_set(x)
  samples <- samples(x)
  model <- .model_drfit(x)

  nstation <- data$nStation
  description <- description(n = nstation)
  if(model == "f")
    description$random <- FALSE

  coefs <- mcmcr::coef(samples, conf_level = conf_level, estimate = estimate)
  coefs <- merge(coefs, description, by = "term", all.x = TRUE)
  if(!random_effects)
    coefs <- coefs[!coefs$random,]
  coefs$random <- NULL

  tibble::as_tibble(coefs)
}

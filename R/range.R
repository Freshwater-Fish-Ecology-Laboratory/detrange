#' Estimate detection range.
#'
#' Estimate detection range from range test data.
#'
#' Returns output of a JAGS Bayesian mixed-effects model with random intercept and slope for each station.
#' Note that with fewer data points per station, sensible default priors will have strong influence on the posterior.
#'
#' @inheritParams params
#' @return The model output object.
#' @family model
#' @export
#' @examples
#' \dontrun{
#' dr_model_range(range_test)
#' }
dr_model_range <- function(data){
  chk_range_test(data)

}

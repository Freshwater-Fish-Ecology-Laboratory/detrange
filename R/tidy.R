#' @export
generics::tidy

#' Get Tidy Tibble from drfit Object.
#'
#' Get a tidy tibble of the coefficient estimates and
#' confidence intervals from model fit.
#'
#' @inheritParams params
#' @return A tibble of the tidy coefficient summary.
#' @family generics
#' @seealso [`coef.drfit()`]
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_obs)
#' tidy(fit)
tidy.drfit <- function(x, conf_level = 0.95, estimate = median,
                       random_effects = FALSE, ...) {
  chk_unused(...)
  dr_coef(x, conf_level, estimate, random_effects)
}

#' @export
generics::glance

dr_glance <- function(x){
  .chk_fit(x)
  tibble::tibble(n = nobs(x),
                 K = npars(x),
                 nchains = nchains(x),
                 niters = niters(x),
                 nthin = .nthin_drfit(x),
                 ess = .ess(x),
                 rhat = rhat(x),
                 converged = converged(x))
}

#' Get a Glance Summary of drfit Object
#'
#' Get a tibble of a one-row summary of the model fit.
#'
#' @inheritParams params
#' @return A tibble of the glance summary.
#' @family generics
#' @seealso
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_test)
#' glance(fit)
glance.drfit <- function(x, ...){
  chk_unused(...)
  dr_glance(x)
}



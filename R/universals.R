#' @export
universals::estimates

#' Estimates for drfit Object
#'
#' Gets a named list of the estimated values by term.
#'
#' @inheritParams params
#' @return A named list of the estimates.
#' @seealso [`tidy.drfit()`]
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_test)
#' estimates(fit)
estimates.drfit <- function(x, ...) {
  mcmcr::estimates(.samples(x))
}

#' @export
universals::nchains

#' Get Number of Chains from drfit Object
#'
#' @inheritParams params
#' @return A number of the number of chains.
#' @export
nchains.drfit <- function(x, ...) {
  mcmcr::nchains(.samples(x))
}

#' @export
universals::npars

#' Get Number of Parameters from drfit Object
#'
#' @inheritParams params
#' @return A number of the number of parameters.
#' @export
npars.drfit <- function(x, ...) {
  mcmcr::npars(.samples(x))
}

#' @export
universals::nterms

#' Get Number of Terms from drfit Object
#'
#' @inheritParams params
#' @return A number of the number of terms.
#' @export
nterms.drfit <- function(x, ...) {
  mcmcr::nterms(.samples(x))
}

#' @export
universals::niters

#' Get Number of Iterations from drfit Object
#'
#' @inheritParams params
#' @return A number of the number of iterations.
#' @export
niters.drfit <- function(x, ...) {
  mcmcr::niters(.samples(x))
}

#' @export
universals::rhat

#' Get Rhat of drfit Object
#'
#' @inheritParams params
#' @return A number of rhat value.
#' @export
rhat.drfit <- function(x, ...) {
  mcmcr::rhat(.samples(x))
}

#' @export
universals::esr

#' Get Effective Sample Rate of drfit Object
#'
#' @inheritParams params
#' @return A number of the number of chains.
#' @export
esr.drfit <- function(x, ...) {
  mcmcr::esr(.samples(x))
}

#' @export
universals::converged

#' Get Convergence of drfit Object
#'
#' @inheritParams params
#' @return A flag indicating convergence.
#' @export
converged.drfit <- function(x, ...) {
  mcmcr::converged(.samples(x))
}

#' @export
universals::pars

#' Get Parameters from drfit Object
#'
#' @inheritParams params
#' @return A vector of the parameter names.
#' @export
pars.drfit <- function(x, ...) {
  mcmcr::pars(.samples(x))
}

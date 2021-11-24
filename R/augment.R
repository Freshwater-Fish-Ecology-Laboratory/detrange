#' @export
generics::augment

#' Get Augmented Data from drfit Object
#'
#' Get a tibble of the original data with augmentation.
#'
#' @inheritParams params
#' @return A tibble of the augmented data.
#' @family generics
#' @seealso
#' @export
#' @examples
#' fit <- dr_fit(detrange::range_obs)
#' augment(fit)
augment.drfit <- function(x, ...) {
  chk_unused(...)
  x$data
}

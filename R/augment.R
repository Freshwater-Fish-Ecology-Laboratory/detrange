#' @export
generics::augment

.augment <- function(x){
  x$data
}

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
#' fit <- dr_fit(detrange::range_test)
#' augment(fit)
augment.drfit <- function(x, ...) {
  chk_unused(...)
  .augment(x)
}

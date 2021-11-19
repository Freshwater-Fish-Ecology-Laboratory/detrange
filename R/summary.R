#' @export
summary.drfit <- function(object, ...) {
  summary(.samples(object))
}

#' @export
print.drfit <- function(x, ...) {
  print(summary(x))
}

#' @export
stats::nobs
#' @export
nobs.drfit <- function(object, ...) {
  .data_set(object)$nObs
}



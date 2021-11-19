`.model_type_drfit<-` <- function(fit, value) {
  attr(fit, "model_type") <- value
  fit
}

.model_type_drfit <- function(fit) {
  attr(fit, "model_type", exact = TRUE)
}

`.nthin_drfit<-` <- function(fit, value) {
  attr(fit, "nthin") <- value
  fit
}

.nthin_drfit <- function(fit) {
  attr(fit, "nthin", exact = TRUE)
}

`.random_intercept_drfit<-` <- function(fit, value) {
  attr(fit, "random_intercept") <- value
  fit
}

.random_intercept_drfit <- function(fit) {
  attr(fit, "random_intercept", exact = TRUE)
}

.attrs_drfit <- function(fit) {
  attrs <- attributes(fit)
  attrs[c("nthin", "model_type", "random_intercept")]
}

`.attrs_drfit<-` <- function(fit, value) {
  .nthin_drfit(fit) <- value$nthin
  .model_type_drfit(fit) <- value$model_type
  .random_intercept_drfit(fit) <- value$random_intercept
  fit
}


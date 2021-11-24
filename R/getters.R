`.model_drfit<-` <- function(fit, value) {
  attr(fit, "model") <- value
  fit
}

.model_drfit <- function(fit) {
  attr(fit, "model", exact = TRUE)
}

`.nthin_drfit<-` <- function(fit, value) {
  attr(fit, "nthin") <- value
  fit
}

.nthin_drfit <- function(fit) {
  attr(fit, "nthin", exact = TRUE)
}

.attrs_drfit <- function(fit) {
  attrs <- attributes(fit)
  attrs[c("nthin", "model")]
}

`.attrs_drfit<-` <- function(fit, value) {
  .nthin_drfit(fit) <- value$nthin
  .model_drfit(fit) <- value$model
  fit
}


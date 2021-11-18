glue2 <- function(x){
  as.character(glue::glue(x, .open = "<<", .close = ">>",
                          .envir = parent.frame()))
}

.model <- function(model, priors){
  glue2(model(priors)$model)
}

.derived <- function(model, de_logit){
  glue2(model(de_logit)$derived)
}

.template <- function(model_type, random_intercept){
  if(model_type == "fixed") {
    fun <- .template_fixed
  } else if (random_intercept){
    fun <- .template_random_intercept
  } else {
    fun <- .template_random_slope
  }
  fun
}


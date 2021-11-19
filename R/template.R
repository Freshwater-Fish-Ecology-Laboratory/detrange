.model <- function(model, priors){
  glue2(model(priors)$model)
}

.derived <- function(model){
  glue2(model()$derived)
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


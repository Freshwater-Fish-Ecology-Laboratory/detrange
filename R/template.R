.model <- function(template, priors){
  glue2(template(priors)$model)
}

.derived <- function(template){
  glue2(template()$derived)
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


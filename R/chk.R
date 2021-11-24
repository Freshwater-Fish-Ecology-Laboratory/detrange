.chk_data <- function(data, x_name = deparse(substitute(data))) {
  chk::check_data(data,
                  x_name = x_name,
                  values = list(Station = factor(),
                                Distance = c(0, Inf),
                                Detects = c(0L, .max_int),
                                Pings = c(1L, .max_int)))
  invisible(data)
}

.chk_predict_de <- function(data, x_name = deparse(substitute(data))){
  chk::check_data(data,
                  x_name = x_name,
                  values = list(Station = factor(),
                                Distance = c(0, Inf),
                                estimate = c(0, 1),
                                lower = c(0, 1),
                                upper = c(0, 1)))
  invisible(data)
}

.chk_predict_distance <- function(data, x_name = deparse(substitute(data))){
  chk::check_data(data,
                  x_name = x_name,
                  values = list(Station = factor(),
                                de = c(0, 1),
                                estimate = c(0, 1),
                                lower = c(0, 1),
                                upper = c(0, 1),
                                svalue = c(0, 1)))
}

.chk_priors <- function(priors){
  if(is.null(priors)) return(priors)
  chk_is(priors, "list")
  chk_named(priors)
  x <- unlist(priors)
  chk_character(x)
  chk_subset(names(x), names(priors()), x_name = "Term name")
  invisible(priors)
}

.chk_params <- function(params){
  if(is.null(params)) return(params)
  chk_is(params, "list")
  chk_named(params)
  x <- unlist(params)
  chk_numeric(x)
  chk_subset(names(x), names(priors()), x_name = "Term name")
  invisible(params)
}

.chk_fit <- function(x){
  chk_s3_class(x, "drfit")
  chk_subset(names(x), c("model", "samples", "data"))
  chk_true(all(names(attributes(x)) %in% c("names", "nthin", "model", "n", "class")))
  chk_s3_class(x$model, "jags")
  chk_s3_class(x$samples, "mcmcr")
  invisible(x)
}



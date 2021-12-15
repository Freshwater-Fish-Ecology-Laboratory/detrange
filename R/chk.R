xname <- function(x, col){
  glue::glue("Column `{col}` of `{x}`")
}

.chk_data <- function(data, x_name = deparse(substitute(data))) {

  nms <- c("Station", "Distance", "Detects", "Pings")
  chk_superset(names(data), nms, x_name = x_name)

  chk_character_or_factor(data$Station, x_name = xname(x_name, "Station"))
  chk_whole_numeric(data$Detects, x_name = xname(x_name, "Detects"))
  chk_whole_numeric(data$Pings, x_name = xname(x_name, "Pings"))
  chk_numeric(data$Distance, x_name = xname(x_name, "Distance"))
  chk_gt(data$Distance, 0, x_name = xname(x_name, "Distance"))

  invisible(data)
}

.chk_predict_de <- function(data, x_name = deparse(substitute(data))){

  nms <- c("Station", "Distance", "estimate", "lower", "upper")
  chk_subset(nms, names(data), x_name = x_name)

  chk_character_or_factor(data$Station, x_name = xname(x_name, "Station"))
  chk_numeric(data$Distance, x_name = xname(x_name, "Distance"))
  chk_gte(data$Distance, 0, x_name = xname(x_name, "Distance"))
  chk_numeric(data$estimate, x_name = xname(x_name, "estimate"))
  chk_gte(data$estimate, 0, x_name = xname(x_name, "estimate"))
  chk_lte(data$estimate, 1, x_name = xname(x_name, "estimate"))
  chk_numeric(data$lower, x_name = xname(x_name, "lower"))
  chk_gte(data$lower, 0, x_name = xname(x_name, "lower"))
  chk_lte(data$lower, 1, x_name = xname(x_name, "lower"))
  chk_numeric(data$upper, x_name = xname(x_name, "upper"))
  chk_gte(data$upper, 0, x_name = xname(x_name, "upper"))
  chk_lte(data$upper, 1, x_name = xname(x_name, "upper"))

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

.chk_priors <- function(priors, req_params){
  if(is.null(priors)) return(priors)
  chk_is(priors, "list")
  chk_named(priors)
  x <- unlist(priors)
  chk_character(x)
  chk_subset(names(x), req_params, x_name = "Parameter names in priors")
  invisible(priors)
}

### looser check than above
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



chk_range_test <- function(data, x_name = deparse(substitute(data))) {
  chk::check_data(data,
                  x_name = x_name,
                  values = list(Station = factor(),
                                Distance = c(0, Inf),
                                Detects = c(0L, .max_int),
                                Pings = c(1L, .max_int)))
}

chk_predicted <- function(data, x_name = deparse(substitute(data))){
  chk::check_data(data,
                  x_name = x_name,
                  values = list(Station = factor(),
                                Distance = c(0, Inf),
                                estimate = 1,
                                lower = 1,
                                upper = 1))
}

chk_distance_at_de <- function(data, x_name = deparse(substitute(data))){
  chk::check_data(data,
                  x_name = x_name,
                  values = list(Station = factor(),
                                estimate = 1,
                                lower = 1,
                                upper = 1,
                                de = c(0, 1)))
}

chk_priors <- function(priors, model){
  if(is.null(priors)) return(priors)
  chk_is(priors, "list")
  chk_named(priors)
  x <- unlist(priors)
  chk_true(all(is.character(x)))
  chk_subset(names(x), names(priors(model)), x_name = "Term name")
}

chk_fit <- function(x){
  chk_s3_class(x, "drfit")
  chk_subset(names(x), c("model", "samples", "data"))
  chk_identical(c("names", "model_type", "nthin", "priors", "class"),
                names(attributes(x)))
  chk_s3_class(x$model, "jags")
  chk_s3_class(x$samples, "mcmcr")
}



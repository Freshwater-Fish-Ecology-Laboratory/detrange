chk_range_test <- function(data, x_name = deparse(substitute(data))) {
  chk::check_data(data,
                  x_name = x_name,
                  values = list(Station = factor(),
                                Distance = c(0, Inf),
                                Detects = c(0L, .max_int),
                                Pings = c(1L, .max_int)))
}

chk_priors <- function(priors, model){
  if(is.null(priors)) return(priors)
  chk_is(priors, "list")
  chk_named(priors)
  x <- unlist(priors)
  chk_true(all(is.character(x)))
  chk_subset(names(x), names(priors(model)), x_name = "Term name")
}

chk_analysis <- function(analysis){
  chk_is(analysis, "list")
  chk_subset(names(analysis), c("model", "samples"))
  chk_subset("model_type", names(attributes(analysis)))
  chk_s3_class(analysis$model, "jags")
  chk_s3_class(analysis$samples, "mcmcr")
}



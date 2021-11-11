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



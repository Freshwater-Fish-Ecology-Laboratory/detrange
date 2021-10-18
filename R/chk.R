chk_range_test <- function(data, x_name = deparse(substitute(data))) {
  chk::check_data(data,
                  x_name = x_name,
                  values = chk_values_rangetest)
}

chk_rsi_priors <- function(priors){
  chk_is(priors, "list")
  chk_named(priors)
  x <- unlist(priors)
  chk_true(all(is.character(x)))
  chk_subset(names(x), names_rsi_priors, x_name = "Term name")
}



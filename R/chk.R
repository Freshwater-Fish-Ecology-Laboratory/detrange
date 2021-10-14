chk_range_test <- function(data, x_name = deparse(substitute(data))) {
  chk::check_data(data,
                  x_name = x_name,
                  values = list(Station = "a",
                                Distance = c(0, Inf),
                                Pings = c(0L, .max_int),
                                Detects = c(0L, .max_int)))
}



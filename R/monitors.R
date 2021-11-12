monitors <- function(model = "random"){
  monitors_list[[model]]
}

monitors_list <- list(
  random = c("bIntercept",
             "bDist",
             "sInterceptStation",
             "sDistStation",
             "bInterceptStation",
             "bDistStation")
)

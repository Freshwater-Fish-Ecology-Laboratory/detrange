monitors <- function(model = "random"){
  monitors_list[[model]]
}

monitors_list <- list(
  random = c("bIntercept",
             "bDist",
             "sInterceptStation",
             "sDistStation",
             "bInterceptStation",
             "bDistStation"),
  fixed = c("bIntercept",
            "bDist",
            "bDistStation")
)

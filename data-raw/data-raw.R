.max_int <- .Machine$integer.max

### simulate range test data for demo and testing ----
set.seed(153)
logit <- function(x) log(x / (1 - x))

generate_distance <- function(n){
  sapply(1:n, function(x) {
    xmin <- (x-1)*130
    round(runif(1, xmin, xmin+50))
  })
}

### set up data
ngroup = 6
n = 7
nobs = ngroup * n
distance <- as.vector(replicate(ngroup, generate_distance(n)))

bIntercept = 5
bDist = -0.02
sDistStation = 0.007
sInterceptStation = 0.1
bDistStation <- rnorm(ngroup, mean = 0, sd = sDistStation)
bInterceptStation <- rnorm(ngroup, mean = 0, sd = sInterceptStation)

eIntercept <- bIntercept + bInterceptStation
eDist <- bDist + bDistStation
mu <- eIntercept + eDist * distance

p <- 1/(1 + exp(-mu))
pings <- round(runif(nobs, 50, 60))
detects <- rbinom(nobs, size = pings, p = p)

range_test <- tibble::tibble(Distance = distance,
                             Pings = as.integer(pings),
                             Detects = as.integer(detects),
                             Station = factor(paste0("Station", rep(1:ngroup, n))))

usethis::use_data(range_test, overwrite = TRUE)

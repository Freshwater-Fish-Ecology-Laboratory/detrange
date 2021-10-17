chk_values_rangetest <- list(Station = factor(),
                           Distance = c(0, Inf),
                           Detects = c(0L, .max_int),
                           Pings = c(1L, .max_int))

### priors for jags model random slope and intercept ----
rsi_priors <- list(bIntercept = "dnorm(0, 5^-2)",
                   bMidpoint = "dunif(0, 1000)",
                   sInterceptStation = "dnorm(0, 2^-2) T(0,)",
                   sMidpointStation ="dnorm(0, 2^-2) T(0,)")

names_rsi_priors <- names(unlist(rsi_priors))

usethis::use_data(rsi_priors, names_rsi_priors, chk_values_rangetest, overwrite = TRUE, internal = TRUE)

### simulate range test data for demo and testing ----
set.seed(152)
nstation <- 6
# generate samples per river
n <- sample(x = 5:7, size = nstation, replace = TRUE)

bSlope <- -0.01 # typical effect of discharge
bIntercept <- 4 # typical intercept

# generate random slopes + intercepts
sSlopeStation <- 0.005 # sd of random effect
sInterceptStation <- 1 # sd of random intercept
bSlopeStation <- rnorm(nstation, bSlope, sSlopeStation)
bInterceptStation <- rnorm(nstation, bIntercept, sInterceptStation)

generate_distance <- function(n){
  sapply(1:n, function(x) {
    xmin <- (x-1)*100
    round(runif(1, xmin, xmin+50))
  })
}

range_test <- purrr::map_df(seq_len(nstation), function(i){
  distance <- generate_distance(n[i])
  mu <- bInterceptStation[i] + bSlopeStation[i]*distance
  p <- 1/(1 + exp(-mu))
  pings <- round(runif(n[i], 75, 150))
  detects <- rbinom(n[i], size = pings, p = p)
  tibble::tibble(Station = factor(glue::glue("Station{i}")),
             Distance = distance,
             Detects = as.integer(detects),
             Pings = as.integer(pings))
})

usethis::use_data(range_test, overwrite = TRUE)

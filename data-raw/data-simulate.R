.max_int <- .Machine$integer.max

### simulate range test data for demo and testing ----
set.seed(153)
logit <- function(x) log(x / (1 - x))

### set up data
nstation = 6
n = 7
bIntercept = 5
bDist = -0.02
sDistStation = 0.007
sInterceptStation = 0.1

parameters <- list(bIntercept = 5,
                   bDistance = bDist,
                   sDistanceStation = sDistStation,
                   sInterceptStation = sInterceptStation)

model <- "for(i in 1:nStation) {
    bInterceptStation[i] ~ dnorm(0, sInterceptStation^-2)
    bDistanceStation[i] ~ dnorm(0, sDistanceStation^-2)
  }

  for(i in 1:nObs) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDistance[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
"
range_obs <- dr_simulate(code = model,
            parameters = parameters,
            monitor = c("Detects"), nstation = nstation, n = n,
            nsims = 1, distance_min = 0, distance_max = 1000,
            ping_min = 100, ping_max = 150)

range_obs$Station <- factor(paste("Station", range_obs$Station, sep = ""))
range_obs$Distance <- as.numeric(range_obs$Distance)
range_obs$Detects <- as.integer(range_obs$Detects)

range_obs <- tibble::as_tibble(range_obs)

fit <- dr_fit(range_obs)
range_pred <- dr_predict_de(fit)

usethis::use_data(range_obs, overwrite = TRUE)
usethis::use_data(range_pred, overwrite = TRUE)


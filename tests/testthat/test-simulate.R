test_that("simulation funs work", {
  code <-"
for(i in 1:nStation) {
    bDistanceStation[i] ~ dnorm(0, sDistanceStation^-2)
  }

  for(i in 1:nObs) {
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDistance[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
"
  parameters <- list(bIntercept = 4,
                 bDistance = -0.02,
                 sDistanceStation = 0.01)
  monitor <- c("eDetects", "Detects")

  x <- dr_simulate(code = code, parameters = parameters, monitor = monitor,
                   nstation = 2, n = 10, distance_min = 0,
                   distance_max = 800, seed = 1)
  x2 <- dr_simulate(code = code, parameters = parameters, monitor = monitor,
                    nstation = 2, n = 10, distance_min = 0,
                    distance_max = 800, seed = 1)

  expect_identical(x, x2)

  x3 <- dr_simulate(code = code, parameters = parameters,
                    nstation = 2, n = 10, distance_min = 0,
                    distance_max = 800, return_nlist = TRUE)
})

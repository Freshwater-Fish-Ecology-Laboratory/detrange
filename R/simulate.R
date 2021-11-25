sim_distance <- function(n, ngroup, min, max){
  slices <- (max - min)/n
  as.vector(replicate(ngroup, sapply(1:n, function(x){
    ymin <- (x - 1) * slices + min
    ymax <- x * slices + min
    as.integer(runif(1, ymin, ymax))
  })))
}

sim_pings <- function(nobs, min, max){
  as.integer(runif(nobs, min, max))
}

sim_group <- function(n, ngroup){
  as.vector(sapply(1:ngroup, function(x) rep(x, n)))
}

dr_simulate <- function(code,
                        parameters = list(bIntercept = 4,
                                                bDistance = -0.02,
                                                sDistanceStation = 0.01),
                        monitor  = ".*",
                        nstation = 8,
                        n = 6,
                        nsims = 1,
                        distance_min = 0,
                        distance_max = 1000,
                        ping_min = 100,
                        ping_max = 150,
                        return_nlist = FALSE,
                        seed = .rndm_seed()){

  chk_string(code)
  .chk_params(parameters)
  chk_whole_number(nstation)
  chk_gte(nstation, 1)
  chk_whole_number(n)
  chk_gte(n, 1)
  chk_number(distance_min)
  chk_gte(distance_min, 0)
  chk_number(distance_max)
  chk_gt(distance_max, distance_min)
  chk_whole_number(ping_min)
  # should I allow 0 pings?
  chk_gt(ping_min, 0)
  chk_whole_number(ping_max)
  chk_gt(ping_max, ping_min)
  chk_whole_number(seed)
  chk_gte(seed, 0)

  set.seed(seed)

  nObs <- nstation * n
  nStation <- nstation
  Distance <- sim_distance(n, nstation, distance_min, distance_max)  # predictor
  Station <- sim_group(n, nstation)
  Pings <- sim_pings(nObs, ping_min, ping_max)

  data <- list(Station = Station,
               Distance = Distance,
               Pings = Pings)

  constants <- list(nObs = nObs,
                    nStation = nStation)

  sim <- sims::sims_simulate(code, constants = c(data, constants),
                             parameters = parameters,
                             monitor = monitor,
                             stochastic = NA, nsims = nsims)

  if(return_nlist)
    return(sim)

  df <- list_to_df(data)
  est <- estimates(sim)
  for(i in monitor){
    df[[i]] <- est[[i]]
  }
  df
}

template <- function(model, priors){
  code <- model_list[[model]]
  as.character(glue::glue(code, .open = "<<", .close = ">>", .envir = parent.frame()))
}

model_random <-
  "model {

  bIntercept ~ <<priors$bIntercept>>
  bDist ~ <<priors$bDist>>

  sInterceptStation ~ <<priors$sInterceptStation>>
  sDistStation ~ <<priors$sDistStation>>

  for(i in 1:nStation) {
    bInterceptStation[i] ~ dnorm(0, sInterceptStation^-2)
    bDistStation[i] ~ dnorm(0, sDistStation^-2)
  }

  for(i in 1:nObs) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDist[i] <- bDist + bDistStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDist[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}"

model_fixed <-
  "model {

  bIntercept ~ <<priors$bIntercept>>
  bDist ~ <<priors$bDist>>

  bDistStation[1] <- 0
  for(i in 2:nStation) {
    bDistStation[i] ~ dnorm(0, 10^-2)
  }

  for(i in 1:nStation){
    eDistStation[i] <- bDist + bDistStation[i]
  }

  for(i in 1:nObs) {
    logit(eDetects[i]) <- bIntercept + eDistStation[Station[i]] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}"

model_list <- list(
  random = model_random,
  fixed = model_fixed
)


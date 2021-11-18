.template_random_intercept <- function(...){
  list(model = .model_ri,
       derived = .derived_ri)
}

.model_ri <-
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

.derived_ri <- "for(i in 1:length(Distance)) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDist[i] <- bDist + bDistStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDist[i] * Distance[i]
    target[i] <- eIntercept[i] + (<<de_logit>> - eIntercept[i])/eDist[i]
    prediction[i] <- eDetects[i]
  }"



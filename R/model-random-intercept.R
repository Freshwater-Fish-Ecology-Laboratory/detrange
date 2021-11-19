.template_random_intercept <- function(...){
  list(model = .model_ri,
       derived = .derived_ri)
}

.model_ri <-
  "model {

  bIntercept ~ <<priors$bIntercept>>
  bDistance ~ <<priors$bDistance>>

  sInterceptStation ~ <<priors$sInterceptStation>>
  sDistanceStation ~ <<priors$sDistanceStation>>

  for(i in 1:nStation) {
    bInterceptStation[i] ~ dnorm(0, sInterceptStation^-2)
    bDistanceStation[i] ~ dnorm(0, sDistanceStation^-2)
  }

  for(i in 1:nObs) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDistance[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}"

.derived_ri <- "for(i in 1:length(Distance)) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDistance[i] * Distance[i]
    target[i] <- eIntercept[i] + (DELogit[i] - eIntercept[i])/eDistance[i]
    prediction[i] <- eDetects[i]
  }"



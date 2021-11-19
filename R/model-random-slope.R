.template_random_slope <- function(...){
  list(model = .model_rs,
       derived = .derived_rs)
}

.model_rs <-
  "model {

  bIntercept ~ <<priors$bIntercept>>
  bDist ~ <<priors$bDist>>

  sDistStation ~ <<priors$sDistStation>>

  for(i in 1:nStation) {
    bDistStation[i] ~ dnorm(0, sDistStation^-2)
  }

  for(i in 1:nObs) {
    eDist[i] <- bDist + bDistStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDist[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}"

.derived_rs <- "for(i in 1:length(Distance)) {
    eDist[i] <- bDist + bDistStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDist[i] * Distance[i]
    target[i] <- bIntercept + (DELogit[i] - bIntercept)/eDist[i]
    prediction[i] <- eDetects[i]
  }"



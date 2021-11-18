.template_fixed <- function(...){
  list(model = .model_f,
       derived = .derived_f)
}

.model_f <-
  "model {

  bIntercept ~ <<priors$bIntercept>>
  bDist ~ <<priors$bDist>>

  bDistStation[1] <- 0
  for(i in 2:nStation) {
    bDistStation[i] ~ dnorm(0, 10^-2)
  }

  for(i in 1:nObs) {
    eDist[i] <- bDist + bDistStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDist[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}"

.derived_f <- "for(i in 1:length(Distance)) {
    eDist[i] <- bDist + bDistStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDist[i] * Distance[i]
    target[i] <- bIntercept + (<<de_logit>> - bIntercept)/eDist[i]
    prediction[i] <- eDetects[i]
  }"

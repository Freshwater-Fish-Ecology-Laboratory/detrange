.template_fixed <- function(...){
  list(model = .model_f,
       derived = .derived_f)
}

.model_f <-
  "model {

  bIntercept ~ <<priors$bIntercept>>
  bDistance ~ <<priors$bDistance>>

  bDistanceStation[1] <- 0
  for(i in 2:nStation) {
    bDistanceStation[i] ~ dnorm(0, 10^-2)
  }

  for(i in 1:nObs) {
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDistance[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}"

.derived_f <- "for(i in 1:length(Distance)) {
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDistance[i] * Distance[i]
    target[i] <- bIntercept + (DELogit[i] - bIntercept)/eDistance[i]
    prediction[i] <- eDetects[i]
  }"

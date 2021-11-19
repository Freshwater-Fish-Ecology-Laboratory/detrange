.template_random_slope <- function(...){
  list(model = .model_rs,
       derived = .derived_rs)
}

.model_rs <-
  "model {

  bIntercept ~ <<priors$bIntercept>>
  bDistance ~ <<priors$bDistance>>

  sDistanceStation ~ <<priors$sDistanceStation>>

  for(i in 1:nStation) {
    bDistanceStation[i] ~ dnorm(0, sDistanceStation^-2)
  }

  for(i in 1:nObs) {
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDistance[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}"

.derived_rs <- "for(i in 1:length(Distance)) {
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDistance[i] * Distance[i]
    target[i] <- bIntercept + (DELogit[i] - bIntercept)/eDistance[i]
    prediction[i] <- eDetects[i]
  }"



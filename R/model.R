### fixed ----
.model_f <- function(priors){
  glue2("model {

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
}")
}

.derived_f <- function() {
  "for(i in 1:length(Distance)) {
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDistance[i] * Distance[i]
    target[i] <- bIntercept + (DELogit[i] - bIntercept)/eDistance[i]
    prediction[i] <- eDetects[i]
  }"
}

### random slope ----
.model_rs <- function(priors){
  glue2("model {

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
}")
}

.derived_rs <- function(){
  "for(i in 1:length(Distance)) {
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDistance[i] * Distance[i]
    target[i] <- bIntercept + (DELogit[i] - bIntercept)/eDistance[i]
    prediction[i] <- eDetects[i]
  }"
}

### random intercept ----
.model_ri <- function(priors){
  glue2("model {

  bIntercept ~ <<priors$bIntercept>>
  bDistance ~ <<priors$bDistance>>
  sInterceptStation ~ <<priors$sInterceptStation>>

  for(i in 1:nStation) {
    bInterceptStation[i] ~ dnorm(0, sInterceptStation^-2)
  }

  for(i in 1:nObs) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + bDistance * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}")
}

.derived_ri <- function() {
  "for(i in 1:length(Distance)) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + bDistance * Distance[i]
    target[i] <- eIntercept[i] + (DELogit[i] - eIntercept[i])/eDistance[i]
    prediction[i] <- eDetects[i]
  }"
}

#### random slope  + random intercept ----
.model_rsri <- function(priors){
  glue2("model {

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
}")
}

.derived_rsri <- function(){
  "for(i in 1:length(Distance)) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDistance[i] * Distance[i]
    target[i] <- eIntercept[i] + (DELogit[i] - eIntercept[i])/eDistance[i]
    prediction[i] <- eDetects[i]
  }"
}


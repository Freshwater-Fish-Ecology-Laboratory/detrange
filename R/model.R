make_priors <- function(x){
  paste0(glue::glue("{x} ~ <<priors${x}>>"), collapse = "\n")
}
make_model <- function(params, likelihood){
  glue2("model {\n<<make_priors(params)>>\n\n <<likelihood>>\n}")
}

### fixed ----
.likelihood_f <- function(){
  "
  for(i in 1:nObs) {
    logit(eDetects[i]) <- bIntercept + bDistance * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }"
}
.params_f <- function() c("bIntercept", "bDistance")
.model_f <- function(priors) glue2(make_model(.params_f(), .likelihood_f()))

.derived_f <- function() {
  "for(i in 1:length(Distance)) {
    logit(eDetects[i]) <- bIntercept + bDistance * Distance[i]
    target[i] <- (DELogit[i] - bIntercept) / bDistance
    prediction[i] <- eDetects[i]
  }"
}

### random slope ----
.likelihood_rs <- function(){
  "for(i in 1:nStation) {
    bDistanceStation[i] ~ dnorm(0, sDistanceStation^-2)
  }

  for(i in 1:nObs) {
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDistance[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }"
}
.params_rs <- function() c("bIntercept", "bDistance", "sDistanceStation")
.model_rs <- function(priors) glue2(make_model(.params_rs(), .likelihood_rs()))

.derived_rs <- function(){
  "for(i in 1:length(Distance)) {
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- bIntercept + eDistance[i] * Distance[i]
    target[i] <- (DELogit[i] - bIntercept) / eDistance[i]
    prediction[i] <- eDetects[i]
  }"
}

### random intercept ----
.likelihood_ri <- function(){
  "for(i in 1:nStation) {
    bInterceptStation[i] ~ dnorm(0, sInterceptStation^-2)
  }

  for(i in 1:nObs) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + bDistance * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }"
}
.params_ri <- function() c("bIntercept", "bDistance", "sInterceptStation")
.model_ri <- function(priors) glue2(make_model(.params_ri(), .likelihood_ri()))

.derived_ri <- function() {
  "for(i in 1:length(Distance)) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + bDistance * Distance[i]
    target[i] <- (DELogit[i] - eIntercept[i]) / bDistance
    prediction[i] <- eDetects[i]
  }"
}

#### random slope  + random intercept ----
.likelihood_rsri <- function(){
  "for(i in 1:nStation) {
    bInterceptStation[i] ~ dnorm(0, sInterceptStation^-2)
    bDistanceStation[i] ~ dnorm(0, sDistanceStation^-2)
  }

  for(i in 1:nObs) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDistance[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }"
}
.params_rsri <- function() c("bIntercept", "bDistance", "sDistanceStation", "sInterceptStation")
.model_rsri <- function(priors) glue2(make_model(.params_rsri(), .likelihood_rsri()))

.derived_rsri <- function(){
  "for(i in 1:length(Distance)) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDistance[i] <- bDistance + bDistanceStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDistance[i] * Distance[i]
    target[i] <- (DELogit[i] - eIntercept[i]) / eDistance[i]
    prediction[i] <- eDetects[i]
  }"
}


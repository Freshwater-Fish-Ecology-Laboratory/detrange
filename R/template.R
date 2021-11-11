template <- function(de_logit, priors, model){
  code <- model_code(model)
  as.character(glue::glue(code, .open = "<<", .close = ">>"))
}

model_code <- function(model){
  switch(model,
         "random" = model_random)
}

model_random <-
  "model {

  bIntercept ~ <<priors$bIntercept>>
  bTarget ~ <<priors$bTarget>>

  sInterceptStation ~ <<priors$sInterceptStation>>
  sTargetStation ~ <<priors$sTargetStation>>

  for(i in 1:nStation) {
    bInterceptStation[i] ~ dnorm(0, sInterceptStation^-2)
    bTargetStation[i] ~ dnorm(0, sTargetStation^-2)
  }

  for(i in 1:nObs) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eTarget[i] <- bTarget + bTargetStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + (<<de_logit>> - eIntercept[i])/eTarget[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}"



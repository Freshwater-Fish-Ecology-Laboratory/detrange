new_expr <- function(model = "random"){
  switch(model, "random" = "
  for(i in 1:length(Distance)) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eTarget[i] <- bTarget + bTargetStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + (0 - eIntercept[i])/eTarget[i] * Distance[i]
    prediction[i] <- eDetects[i]
  }
")
}


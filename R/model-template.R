
jags_template_rsi <- function(de_logit = 0, priors = rsi_priors, nthin = 3L){
  mbr::model(as.character(glue::glue("model {

  bIntercept ~ _{priors$bIntercept}_
  bMidpoint ~ _{priors$bMidpoint}_

  sInterceptStation ~ _{priors$sInterceptStation}_
  sMidpointStation ~ _{priors$sMidpointStation}_

  for(i in 1:nStation) {
    bInterceptStation[i] ~ dnorm(0, sInterceptStation^-2)
    bMidpointStation[i] ~ dnorm(0, sMidpointStation^-2)
  }

  for(i in 1:nObs) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eMidpoint[i] <- bMidpoint + bMidpointStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + (_{de_logit}_ - eIntercept[i])/eMidpoint[i] * Distance[i]
    Detects[i] ~ dbin(eDetects[i], Pings[i])
  }
}", .open = "_{", .close = "}_")),
             new_expr = as.character(glue::glue("
  for(i in 1:nObs) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eMidpoint[i] <- bMidpoint + bMidpointStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + (_{de_logit}_ - eIntercept[i])/eMidpoint[i] * Distance[i]
    prediction[i] <- eDetects[i]
  }
", .open = "_{", .close = "}_")),
             nthin = nthin,
             select_data = list(Station = factor(),
                                Distance = c(0, Inf),
                                Detects = c(0L, .max_int),
                                Pings = c(1L, .max_int)),
                 random_effects = list(bMidpointStation = "Station",
                                       bInterceptStation = "Station"))
}

# jags_model_crsi <- function(priors = crsi_priors){
#   model <- mbr::model("model {
#
#   bIntercept ~ dnorm(0, 5^-2)
#   bSlope ~ dnorm(0, 5^-2)
#
#   sInterceptStation ~ dnorm(0, 5^-2) T(0,)
#   sSlopeStation ~ dnorm(0, 5^-2) T(0,)
#   rho ~ dnorm(0, 0.5^-2) T(-1,1)
#
#   eCovMat[1,1] <- sInterceptStation^2
#   eCovMat[2,2] <- sSlopeStation^2
#   eCovMat[1,2] <- rho*sInterceptStation*sSlopeStation
#   eCovMat[2,1] <- eCovMat[1,2]
#   eInvCovMat[1:2,1:2] <- inverse(eCovMat[,])
#
#   for(i in 1:nStation) {
#     eBhat[i,1] <- 0
#     eBhat[i,2] <- 0
#     eB[i, 1:2] ~ dmnorm(eBhat[i,], eInvCovMat[,])
#     bInterceptStation[i] <- eB[i,1]
#     bSlopeStation[i] <- eB[i,2]
#   }
#
#   for(i in 1:nObs) {
#     eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
#     eSlope[i] <- bSlope + bSlopeStation[Station[i]]
#     logit(eDetects[i]) <- eIntercept[i] + eSlope[i] * Distance[i]
#     Detects[i] ~ dbin(eDetects[i], Pings[i])
#   }
# }", new_expr = "
#   for(i in 1:nObs) {
#     eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
#     eSlope[i] <- bSlope + bSlopeStation[Station[i]]
#     logit(eDetects[i]) <- eIntercept[i] + eSlope[i] * Distance[i]
#     prediction[i] <- eDetects[i]
#   }
# ", nthin = 100L, select_data = list(Detects = c(0L, 10000L),
#                                     Distance = c(0, 1500),
#                                     Station = factor(),
#                                     Pings = c(1L, 10000L)),
#                  random_effects = list(bSlopeStation = "Station",
#                                        bInterceptStation = "Station"))
# }





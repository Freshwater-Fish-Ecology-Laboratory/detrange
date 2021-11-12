new_expr <- function(model, monitor, de_logit = NULL){
  code <- new_expr_list[[model]][[monitor]]
  if(is.null(de_logit))
    return(code)
  as.character(glue::glue(code, .open = "<<", .close = ">>"))
}

new_expr_fixed_target <- "
for(i in 1:length(Distance)) {
    logit(eDetects[i]) <- bIntercept + bDist * Distance[i]
    target[i] <- bIntercept + (<<de_logit>> - bIntercept)/bDist
  }"

new_expr_fixed_prediction <- "
for(i in 1:length(Distance)) {
    logit(eDetects[i]) <- bIntercept + bDist * Distance[i]
    prediction[i] <- eDetects[i]
  }"

new_expr_random_target <- "for(i in 1:length(Distance)) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDist[i] <- bDist + bDistStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDist[i] * Distance[i]
    target[i] <- eIntercept[i] + (<<de_logit>> - eIntercept[i])/eDist[i]
  }"

new_expr_random_prediction <- "for(i in 1:length(Distance)) {
    eIntercept[i] <- bIntercept + bInterceptStation[Station[i]]
    eDist[i] <- bDist + bDistStation[Station[i]]
    logit(eDetects[i]) <- eIntercept[i] + eDist[i] * Distance[i]
    prediction[i] <- eDetects[i]
  }"

new_expr_list <- list(
  random = list(
    target = new_expr_random_target,
    prediction = new_expr_random_prediction
  ),
  target = list(
    target = new_expr_fixed_target,
    prediction = new_expr_fixed_prediction
  )
)

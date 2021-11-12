replace_priors <- function(priors, new_prior){
  if(is.null(new_prior))
    return(priors)
  nms <- intersect(names(new_prior), names(priors))
  modifyList(priors, new_prior[nms])
}

priors <- function(model = "random"){
  priors_list[[model]]
}

priors_list <- list(
  random = list(
    bIntercept = "dnorm(0, 10^-2)",
    bDist = "dnorm(0, 10^-2)",
    sInterceptStation = "dnorm(0, 10^-2) T(0,)",
    sDistStation = "dnorm(0, 500^-2) T(0,)"
  )
)



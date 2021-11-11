replace_priors <- function(priors, new_prior){
  if(is.null(new_prior))
    return(priors)
  nms <- intersect(names(new_prior), names(priors))
  modifyList(priors, new_prior[nms])
}

priors <- function(model = "random"){
  switch(model,
         "random" = list(
           bIntercept = "dnorm(0, 10^-2)",
           bTarget = "dnorm(0, 1000^-2) T(0,)",
           sInterceptStation = "dnorm(0, 10^-2) T(0,)",
           sTargetStation = "dnorm(0, 500^-2) T(0,)"),
         NULL)
}

monitors <- function(model = "random"){
  switch(model,
         "random" = c("bIntercept", "bTarget", "sInterceptStation", "sTargetStation",
                      "bInterceptStation", "bTargetStation"),
         NULL)
}

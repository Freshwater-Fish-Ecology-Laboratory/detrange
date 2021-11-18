replace_priors <- function(priors, new_prior){
  if(is.null(new_prior))
    return(priors)
  nms <- intersect(names(new_prior), names(priors))
  modifyList(priors, new_prior[nms])
}

.terms <- function(){
  list(bIntercept = "dnorm(0, 10^-2)",
       bDist = "dnorm(0, 10^-2)",
       sInterceptStation = "dnorm(0, 10^-2) T(0,)",
       sDistStation = "dnorm(0, 10^-2) T(0,)",
       bDistStation = NULL,
       bInterceptStation = NULL)
}

.monitors <- function(terms) names(terms)
.priors <- function(terms) terms[!sapply(terms, is.null)]



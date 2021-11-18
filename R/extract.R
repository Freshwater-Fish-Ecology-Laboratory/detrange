### extract from analysis object
.data_set <- function(x){
  x$model$data()
}

.augment <- function(x){
  x$data
}

.samples <- function(x){
  x$samples
}

.model_type <- function(x){
  attr(x, "model_type")
}

.nthin <- function(x){
  attr(x, "nthin")
}

.de_target <- function(x){
  attr(x, "de_target")
}

.priors <- function(x){
  attr(x, "priors")
}

.n <- function(x){
  nrow(.augment(x))
}

### sample extract
.nchains <- function(x){
  mcmcr::nchains(.samples(x))
}

.niters <- function(x){
  mcmcr::niters(.samples(x))
}

.K <- function(analysis){
  model <- .model_type(analysis)
  switch(model,
         "random" = 4,
         "fixed" = 2)
}

.ess <- function(x){
  mcmcr::ess(.samples(x))
}

.rhat <- function(x){
  mcmcr::rhat(.samples(x))
}

.converged <- function(x){
  mcmcr::converged(.samples(x))
}





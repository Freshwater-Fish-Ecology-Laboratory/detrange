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

### sample extract
.nchains <- function(x){
  mcmcr::nchains(.samples(x))
}

.niters <- function(x){
  mcmcr::niters(.samples(x))
}

.K <- function(x){
  mcmcr::nterms(.samples(x))
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





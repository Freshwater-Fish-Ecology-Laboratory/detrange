### extract from analysis object
.data_set <- function(x){
  x$model$data()
}

.samples <- function(x){
  x$samples
}

.ess <- function(x){
  mcmcr::ess(.samples(x))
}







### extract from analysis object
data_set <- function(analysis){
  analysis$model$data()
}

data_df <- function(analysis){
  x <- data_set(analysis)
  list_to_df(x)
}

samples <- function(analysis){
  analysis$samples
}

model_type <- function(analysis){
  attr(analysis, "model_type")
}

nthin <- function(analysis){
  attr(analysis, "nthin")
}

de_target <- function(analysis){
  attr(analysis, "de_target")
}

priors <- function(analysis){
  attr(analysis, "priors")
}

n <- function(analysis){
  nrow(data_df(analysis))
}

### sample extract
nchains <- function(analysis){
  mcmcr::nchains(samples(analysis))
}

niters <- function(analysis){
  mcmcr::niters(samples(analysis))
}

K <- function(analysis){
  model <- model_type(analysis)
  switch(model,
         "random" = 4,
         "fixed" = 2)
}

ess <- function(analysis){
  mcmcr::ess(samples(analysis))
}

rhat <- function(analysis){
  mcmcr::rhat(samples(analysis))
}

converged <- function(analysis){
  mcmcr::converged(samples(analysis))
}





data <- function(analysis){
  analysis$model$data()
}

data_df <- function(analysis){
  x <- data(analysis)
  list_to_df(x)
}

samples <- function(analysis){
  analysis$samples
}

nchains <- function(analysis){
  mcmcr::nchains(samples(analysis))
}

niters <- function(analysis){
  mcmcr::niters(samples(analysis))
}

n <- function(analysis){
  nrow(data_df(analysis))
}

K <- function(analysis){
  model <- model_type(analysis)
  switch(model,
         "random" = 4,
         "fixed" = 2)
}

nthin <- function(analysis){
  attr(analysis, "nthin")
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

model_type <- function(analysis){
  attr(analysis, "model_type")
}



.max_int <- .Machine$integer.max

logit <- function(x) log(x / (1 - x))

df_to_list <- function(x){
  list(nObs = nrow(x),
       nStation = length(unique(x$Station)),
       Distance = x$Distance,
       Detects = x$Detects,
       Pings = x$Pings,
       Station = x$Station)
}

list_to_df <- function(x){
  x <- as.data.frame(x)
  x$Station <- as.factor(x$Station)
  x
}

data_set <- function(analysis, df = TRUE){
  x <- analysis$model$data()
  if(df)
    x <- list_to_df(x)
  x
}

samples <- function(analysis){
  analysis$samples
}

model_type <- function(analysis){
  attr(analysis, "model_type")
}



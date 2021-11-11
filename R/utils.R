.max_int <- .Machine$integer.max

logit <- function(x) log(x / (1 - x))

data_to_list <- function(x){
  list(nObs = nrow(x),
       nStation = length(unique(x$Station)),
       Distance = x$Distance,
       Detects = x$Detects,
       Pings = x$Pings,
       Station = x$Station)
}

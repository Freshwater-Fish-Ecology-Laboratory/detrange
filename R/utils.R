.rndm_seed <- function() as.integer(Sys.time())

.max_int <- .Machine$integer.max

logit <- function(x) log(x / (1 - x))

ceiling100 <- function(x) ceiling(x/100)*100

to_ch0 <- function(x){
  if(!length(x) || x == "")
    x <- character(0)
  x
}

data_list <- function(x){
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

glue2 <- function(x){
  as.character(glue::glue(x, .open = "<<", .close = ">>",
                          .envir = parent.frame()))
}




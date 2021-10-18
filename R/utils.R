.max_int <- .Machine$integer.max

logit <- function(x) log(x / (1 - x))

glue_model <- function(x){
  as.character(glue::glue(x, .open = "_{", .close = "}_"))
}

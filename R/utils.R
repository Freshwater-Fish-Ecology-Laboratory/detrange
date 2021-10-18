.max_int <- .Machine$integer.max

logit <- function(x) log(x / (1 - x))

glue_model <- function(x){
  as.character(glue::glue(x, .open = "_{", .close = "}_"))
}

replace_prior <- function(priors, new_prior){
  nms <- intersect(names(new_prior), names(rsi_priors))
  modifyList(rsi_priors, new_prior[nms])
}

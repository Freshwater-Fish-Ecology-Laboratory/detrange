drfit <- function(x){
  chk_is(x, "list")
  class(x) <- "drfit"
  x
}

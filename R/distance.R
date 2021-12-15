hypotenuse <- function(base, height){
  sapply(seq_along(base), function(x){
    sqrt(x = sum(base[x] ^ 2, height[x] ^ 2))
  })
}

correct_distance <- function(data){

  if(!("DepthReceiver" %in% names(data)))
    data$DepthReceiver <- 0

  if(!("DepthTag" %in% names(data)))
    data$DepthTag <- 0

  data$DistanceRaw <- data$Distance
  data$Distance <- hypotenuse(data$DistanceRaw,
                              abs(data$DepthReceiver - data$DepthTag))
  data
}

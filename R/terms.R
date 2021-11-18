replace_priors <- function(priors, new_prior){
  if(is.null(new_prior))
    return(priors)
  nms <- intersect(names(new_prior), names(priors))
  modifyList(priors, new_prior[nms])
}

.terms <- function(){
  list(bIntercept = "dnorm(0, 10^-2)",
       bDist = "dnorm(0, 10^-2)",
       sInterceptStation = "dnorm(0, 10^-2) T(0,)",
       sDistStation = "dnorm(0, 10^-2) T(0,)",
       bDistStation = NULL,
       bInterceptStation = NULL)
}

.monitors <- function(terms) names(terms)
.priors <- function(terms) terms[!sapply(terms, is.null)]

.description <- function(n){
  description <- c(
    "eDetects[i]" = "Expected `Detects` of `i`^th^ sample event",
    "bIntercept" = "Intercept of logit(`eDetects`)",
    "bDist" = "Effect of distance on logit(`eDetects`)",
    "sInterceptStation" = "Standard deviation of `bInterceptStation`",
    "sDistStation" = "Standard deviation of `bDistStation`"
  )

  description <- tibble::tibble(term = names(description),
                                description = description,
                                random = FALSE)

  intercept_df <- do.call(rbind, lapply(1:n, function(i){
    intercept <- glue::glue("bInterceptStation[{i}]")
    intercept_desc <- glue::glue("Effect of `{i}`^th^ `Station` on `bIntercept`")
    intercept_df <- tibble::tibble(term = intercept,
                                   description = intercept_desc,
                                   random = TRUE)
  }))

  dist_df <- do.call(rbind, lapply(1:n, function(i){
    dist <- glue::glue("bDistStation[{i}]")
    dist_desc <- glue::glue("Effect of `{i}`^th^ `Station` on `bDist`")
    dist_df <- tibble::tibble(term = dist,
                              description = dist_desc,
                              random = TRUE)
  }))

  rbind(description, intercept_df, dist_df)
}



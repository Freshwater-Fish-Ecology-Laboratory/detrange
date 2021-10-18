.max_int <- .Machine$integer.max

logit <- function(x) log(x / (1 - x))

replace_prior <- function(priors, new_prior){
  nms <- intersect(names(new_prior), names(rsi_priors))
  modifyList(rsi_priors, new_prior[nms])
}

param_description <- function(n){

  description <- c(
    "`eDetects[i]" = "Expected `Detects` of `i`^th^ sample event",
    "bIntercept" = "Intercept of logit(`eDetects`)",
    "bMidpoint" = "Intercept of logit(`eDetects`) at target detection efficiency ",
    "sInterceptStation" = "Standard deviation of `bInterceptStation`",
    "sMidpointStation" = "Standard deviation of `bMidpointStation`"
  )

  description <- tibble::tibble(term = names(description),
                                  description = description)

  for(i in 1:n){
    intercept <- glue::glue("bInterceptStation[{i}]")
    intercept_desc <- glue::glue("Effect of `{i}`^th^ `Station` on `bIntercept`")
    intercept_df <- tibble::tibble(term = intercept,
                               description = intercept_desc)

    midpoint <- glue::glue("bMidpointStation[{i}]")
    midpoint_desc <- glue::glue("Effect of `{i}`^th^ `Station` on `bMidpoint`")
    midpoint_df <- tibble::tibble(term = midpoint,
                              description = midpoint_desc)

    description <- rbind(description, intercept_df)
    description <- rbind(description, midpoint_df)
  }
  description
}

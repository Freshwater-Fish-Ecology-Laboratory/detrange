param_description <- function(n, model){
  switch(model,
         "random" = param_description_random(n),
         "fixed" = param_description_fixed(n),
         NULL)
}

param_description_random <- function(n){
  description <- c(
    "eDetects[i]" = "Expected `Detects` of `i`^th^ sample event",
    "bIntercept" = "Intercept of logit(`eDetects`)",
    "bTarget" = "Intercept of logit(`eDetects`) at target detection efficiency ",
    "sInterceptStation" = "Standard deviation of `bInterceptStation`",
    "sTargetStation" = "Standard deviation of `bTargetStation`"
  )

  description <- tibble::tibble(term = names(description),
                                description = description)

  for(i in 1:n){
    intercept <- glue::glue("bInterceptStation[{i}]")
    intercept_desc <- glue::glue("Effect of `{i}`^th^ `Station` on `bIntercept`")
    intercept_df <- tibble::tibble(term = intercept,
                                   description = intercept_desc)

    target <- glue::glue("bTargetStation[{i}]")
    target_desc <- glue::glue("Effect of `{i}`^th^ `Station` on `bTarget`")
    target_df <- tibble::tibble(term = target,
                                description = target_desc)

    description <- rbind(description, intercept_df)
    description <- rbind(description, target_df)
  }
  description
}

param_description_fixed <- function(n){
  description <- c(
    "eDetects[i]" = "Expected `Detects` of `i`^th^ sample event",
    "bIntercept" = "Intercept of logit(`eDetects`)",
    "bTarget" = "Intercept of logit(`eDetects`) at target detection efficiency "
  )

  description <- tibble::tibble(term = names(description),
                                description = description)
  description
}


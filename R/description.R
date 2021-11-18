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

# param_description <- function(n, model){
#   switch(model,
#          "random" = param_description_random(n),
#          "fixed" = param_description_fixed(n),
#          NULL)
# }
#
# param_description_random <- function(n){
#   description <- c(
#     "eDetects[i]" = "Expected `Detects` of `i`^th^ sample event",
#     "bIntercept" = "Intercept of logit(`eDetects`)",
#     "bDist" = "Effect of distance on logit(`eDetects`)",
#     "sInterceptStation" = "Standard deviation of `bInterceptStation`",
#     "sDistStation" = "Standard deviation of `bDistStation`"
#   )
#
#   description <- tibble::tibble(term = names(description),
#                                 description = description,
#                                 random = FALSE)
#
#   for(i in 1:n){
#     intercept <- glue::glue("bInterceptStation[{i}]")
#     intercept_desc <- glue::glue("Effect of `{i}`^th^ `Station` on `bIntercept`")
#     intercept_df <- tibble::tibble(term = intercept,
#                                    description = intercept_desc,
#                                    random = TRUE)
#
#     target <- glue::glue("bDistStation[{i}]")
#     target_desc <- glue::glue("Effect of `{i}`^th^ `Station` on `bDist`")
#     target_df <- tibble::tibble(term = target,
#                                 description = target_desc,
#                                 random = TRUE)
#
#     description <- rbind(description, intercept_df)
#     description <- rbind(description, target_df)
#   }
#   description
# }
#
# param_description_fixed <- function(n){
#   description <- c(
#     "eDetects[i]" = "Expected `Detects` of `i`^th^ sample event",
#     "bIntercept" = "Intercept of logit(`eDetects`)",
#     "bDist" = "Effect of distance on logit(`eDetects`)"
#   )
#
#   description <- tibble::tibble(term = names(description),
#                                 description = description,
#                                 random = FALSE)
#
#   for(i in 1:n){
#     dist <- glue::glue("bDistStation[{i}]")
#     dist_desc <- glue::glue("Effect of `{i}`^th^ `Station` on `bDist`")
#     dist_df <- tibble::tibble(term = dist,
#                                 description = dist_desc,
#                                 random = FALSE)
#
#     description <- rbind(description, dist_df)
#   }
#   description
# }


#' Parameter Descriptions for detrange Functions
#' @param ... Unused parameters.
#' @param data A tibble of the range test data.
#' Data must include columns Station (character), Distance (numeric), Pings (integer) and Detects (integer).
#' @param analysis The analysis object from `dr_analyse`.
#' @param distance_seq A vector of the distances to make predictions for.
#' @param priors A list of the priors for each model term.
#' @param nthin A number of the number of thins.
#' @param include_random A flag indicating whether to include coefficients for random terms.
#' @keywords internal
#' @name params
NULL

#' Parameter Descriptions for detrange Functions
#' @param ... Unused parameters.
#' @param data A tibble of the range test data.
#' Data must include columns Station (character), Distance (numeric), Pings (integer) and Detects (integer).
#' @param x The object.
#' @param distance_seq A vector of the distances to make predictions for.
#' @param priors A named list of the priors for each model term.
#' @param nthin A whole number of the number of thins.
#' @param min_random A whole number of the minimum number of Stations required to fit a mixed-effects model.
#' @param random_intercept A flag indicating whether to model intercept as a random effect.
#' In the case of a fixed-effects model, this will be ignored.
#' @param quiet A flag indicating whether to suppress messages and progress bars.
#' @param by A string of the grouping variable to derive predictions for.
#' @param conf_level A number between 0 and 1 of the confidence level. Default is 0.95.
#' @param estimate 	A function to calculate the estimate with. The default is median.
#' @param de A number between 0 and 1 of the detection efficiency.
#' @param random_effects A flag indicating whether to include random effect terms.
#' @param gp A ggplot object returned from `dr_plot`.
#' @param predicted A tibble of the output of `dr_predict`.
#' @param distance_at_de A tibble of the output of `dr_distance_at_de`.
#' @keywords internal
#' @name params
NULL

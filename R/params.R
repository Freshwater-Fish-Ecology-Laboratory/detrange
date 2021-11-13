#' Parameter Descriptions for detrange Functions
#' @param ... Unused parameters.
#' @param data A tibble of the range test data.
#' Data must include columns Station (character), Distance (numeric), Pings (integer) and Detects (integer).
#' @param analysis The analysis object from `dr_analyse`.
#' @param distance_seq A vector of the distances to make predictions for.
#' @param priors A named list of the priors for each model term.
#' @param nthin A number of the number of thins.
#' @param quiet A flag indicating whether to suppress messages and progress bars.
#' @param by A string of the grouping variable to derive predictions for.
#' @param conf_level A number between 0 and 1 of the confidence level. Default is 0.95.
#' @param estimate 	A function to calculate the estimate with. The default is median.
#' @param de_target A number of the target detection efficiency (from 0 to 1) to estimate distance at.
#' @param random_effects A flag indicating whether to include random effects.
#' @param gp A ggplot object returned from `dr_plot`.
#' @param predicted A tibble of the output of `dr_predict`.
#' @param distance_at_de A tibble of the output of `dr_distance_at_de`.
#' @keywords internal
#' @name params
NULL

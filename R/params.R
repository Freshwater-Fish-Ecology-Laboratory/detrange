#' Parameter Descriptions for detrange Functions
#' @param ... Unused parameters.
#' @param data A data.frame of the detection range data (see [`detrange::range_obs`])
#' @param x The object.
#' @param object The object.
#' @param priors A named list of the priors for each model term.
#' @param nthin A whole number of the number of thins.
#' @param min_random A whole number of the minimum number of Stations required to fit a mixed-effects model.
#' @param random_intercept A flag indicating whether to model intercept as a random effect.
#' In the case of a fixed-effects model, this will be ignored.
#' @param quiet A flag indicating whether to suppress messages and progress bars.
#' @param by A string of the column indicating group to derive predictions at.
#' @param conf_level A number between 0 and 1 of the confidence level.
#' @param estimate 	A function to calculate the estimate.
#' @param distance A vector of the distances to predict detection efficiency at.
#' If NULL, a vector of length 30 spanning the range of the Distance in the data will be generated.
#' @param de A vector of numbers between 0 and 1 of the detection efficiency to predict distance at.
#' @param random_effects A flag indicating whether to include random effect terms.
#' @param gp A ggplot object returned from `dr_plot`.
#' @param predict_de A tibble of the output of `dr_predict_de`.
#' @param predict_distance A tibble of the output of `dr_predict_distance`.
#' @param detects A string of the column name containing detections.
#' @param pings A string of the column name containing pings.
#' @param xlab A string of the x-axis title.
#' @param ylab A string of the y-axis title.
#' @param facet A flag indicating whether to facet plot by Station.
#'
#' @keywords internal
#' @name params
NULL

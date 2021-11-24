#' Parameter Descriptions for detrange Functions
#' @param ... Unused parameters.
#' @param data A data.frame of the detection range data (see [`detrange::range_obs`])
#' @param x The object.
#' @param object The object.
#' @param by A string of the column indicating group to derive predictions at.
#' @param conf_level A number between 0 and 1 of the confidence level.
#' @param de A vector of numbers between 0 and 1 of the detection efficiency to predict distance at.
#' @param detects A string of the column name containing detections.
#' @param distance A vector of the distances to predict detection efficiency at.
#' If NULL, a vector of length 30 spanning the range of the Distance in the data is generated.
#' @param distance_min A positive number of the minimum distance.
#' @param distance_max A positive number of the maximum distance.
#' @param estimate 	A function to calculate the estimate.
#' @param facet A flag indicating whether to facet plot by Station.
#' @param min_random_slope A whole number of the minimum number of Stations
#' required to fit slope parameter as a random effect.
#' @param min_random_intercept A whole number of the minimum number of Stations
#' required to fit intercept parameter as a random effect.
#' @param n A whole number of the data points per station.
#' @param nstation A whole number of the number of stations.
#' @param nthin A whole number of the number of thins.
#' @param pings A string of the column name containing pings.
#' @param ping_min A positive whole number of the minimum pings.
#' @param ping_max A positive whole number of the maximum pings.
#' @param predict_de A tibble of the output of `dr_predict_de`.
#' @param predict_distance A tibble of the output of `dr_predict_distance`.
#' @param priors A named list of the priors for each model term.
#' @param quiet A flag indicating whether to suppress messages and progress bars.
#' @param random_effects A flag indicating whether to include random effect terms.
#' @param seed A positive whole number of the seed.
#' @param term A string of the term name.
#' @param params A named list of the parameter names and values to simulate.
#' @param xlab A string of the x-axis title.
#' @param ylab A string of the y-axis title.
#'
#' @keywords internal
#' @name params
NULL

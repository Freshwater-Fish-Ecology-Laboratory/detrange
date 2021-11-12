test_that("analysis functions work", {
  ### dr_analysis_coefficient
  data <- range_test
  model <- "random"
  priors <- priors(model)

  ### check template fun
  template <- template(de_logit = 0.1, model = model, priors = priors)
  expect_type(template, "character")

  ### check that priors can be replaced
  wrong_prior <- list(bInterce = "dnorm(0, 5^-2)")
  new_prior <- list(bIntercept = "dnorm(0, 5^-2)")
  priors2 <- replace_priors(priors, new_prior)
  expect_identical(priors2$bIntercept, new_prior$bIntercept)
  priors2 <- replace_priors(priors, wrong_prior)
  expect_identical(priors, priors2)

  ### check dr_analyse
  expect_chk_error(dr_analyse(data, de_target = 50, priors = priors, nthin = 1L))
  expect_chk_error(dr_analyse(data, de_target = 0.5, priors = wrong_prior, nthin = 1L))
  analysis <- dr_analyse(data, de_target = 0.5, priors = new_prior, nthin = 1L)

  expect_type(analysis, "list")
  expect_identical(names(analysis), c("model", "samples"))
  expect_s3_class(analysis$model, "jags")
  expect_s3_class(analysis$samples, "mcmcr")

  ### check glance
  glance <- dr_glance(analysis)
  expect_s3_class(glance, "data.frame")
  expect_true(all(names(glance) %in% c("n", "K", "nchains", "niters",
                                       "nthin", "ess", "rhat", "converged")))

  # ### dr_analysis_glance
  # glance <- dr_analysis_glance(analysis)
  # expect_s3_class(glance, "tbl")
  #
  #  ### dr_analysis_coef
  # coefs <- dr_analysis_coef(analysis, include_random = TRUE)
  # expect_s3_class(coefs, "tbl")
  # expect_true(all(!is.na(coefs$description)))
  #
  # ### dr_analysis_predict
  # prediction <- dr_analysis_predict(analysis, by_station = FALSE)
  # expect_s3_class(prediction, "tbl")
  # expect_identical(length(unique(prediction$Station)), 1L)
  #
  # prediction <- dr_analysis_predict(analysis, by_station = TRUE)
  # expect_s3_class(prediction, "tbl")
  # expect_identical(length(unique(prediction$Station)), 6L)
  #
  # prediction2 <- dr_analysis_predict(analysis,
  #                                    distance_seq = seq(0, 1000, 100),
  #                                    by_station = FALSE)
  # expect_s3_class(prediction2, "tbl")
  # expect_identical(range(prediction2$Distance), c(0, 1000))
  # expect_identical(names(prediction2), c("Station",
  #                                        "Distance",
  #                                        "Detects",
  #                                        "Pings",
  #                                        "estimate",
  #                                        "lower",
  #                                        "upper",
  #                                        "svalue"))
  # expect_identical(length(unique(prediction2$Station)), 1L)
  #
  # prediction2 <- dr_analysis_predict(analysis,
  #                                    distance_seq = seq(0, 1000, 100),
  #                                    by_station = TRUE)
  # expect_identical(length(unique(prediction2$Station)), 6L)
  # expect_s3_class(prediction2, "tbl")
  #
  # ### test plotting functions work
  # gp <- dr_plot_observed(data)
  # expect_s3_class(gp, "ggplot")
  #
  # gp <- dr_plot_predicted(analysis, de_target = 0.5)
  # expect_s3_class(gp, "ggplot")

})

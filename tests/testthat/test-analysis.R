test_that("analysis functions work", {
  ### dr_analysis_coefficient
  data <- range_test
  template <- jags_template_rsi(priors = rsi_priors, nthin = 1L)

  expect_s3_class(template, "jmb_model")

  analysis <- dr_analyse(data, priors = rsi_priors, nthin = 1L)
  expect_s3_class(analysis, "jmb_analysis")

  ### dr_analysis_glance
  glance <- dr_analysis_glance(analysis)
  expect_s3_class(glance, "tbl")

   ### dr_analysis_coef
  coefs <- dr_analysis_coef(analysis)
  expect_s3_class(coefs, "tbl")

  ### dr_analysis_predict
  prediction <- dr_analysis_predict(analysis)
  expect_s3_class(prediction, "tbl")

  prediction2 <- dr_analysis_predict(analysis, distance_seq = seq(0, 1000, 100))
  expect_s3_class(prediction2, "tbl")
  expect_identical(range(prediction2$Distance), c(0, 1000))
  expect_identical(names(prediction2), c("Station",
                                         "Distance",
                                         "Detects",
                                         "Pings",
                                         "estimate",
                                         "lower",
                                         "upper",
                                         "svalue"))

  ### test plotting functions work
  gp <- dr_plot_observed(data)
  expect_s3_class(gp, "ggplot")

  gp <- dr_plot_predicted(analysis)
  expect_s3_class(gp, "ggplot")

})

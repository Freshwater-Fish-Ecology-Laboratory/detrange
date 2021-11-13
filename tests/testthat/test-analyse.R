test_that("analyse functions work", {
  ### dr_analysis_coefficient
  data <- range_test
  model <- "random"
  priors <- priors(model)

  ### check template fun
  template <- template(model = model, priors = priors)
  expect_type(template, "character")
  expect_true(length(template) > 0)

  ### check that priors can be replaced
  wrong_prior <- list(bInterce = "dnorm(0, 5^-2)")
  new_prior <- list(bIntercept = "dnorm(0, 5^-2)")
  priors2 <- replace_priors(priors, new_prior)
  expect_identical(priors2$bIntercept, new_prior$bIntercept)
  priors2 <- replace_priors(priors, wrong_prior)
  expect_identical(priors, priors2)

  ### check dr_analyse
  expect_chk_error(dr_analyse(data, priors = wrong_prior, nthin = 1L))
  analysis <- dr_analyse(data, priors = new_prior, nthin = 1L)

  expect_type(analysis, "list")
  expect_identical(names(analysis), c("model", "samples"))
  expect_s3_class(analysis$model, "jags")
  expect_s3_class(analysis$samples, "mcmcr")

  ### check glance
  glance <- dr_glance(analysis)
  expect_s3_class(glance, "data.frame")
  expect_true(all(names(glance) %in% c("n", "K", "nchains", "niters",
                                       "nthin", "ess", "rhat", "converged")))
  # test coef
  coef <- dr_coef(analysis)
  expect_s3_class(coef, "data.frame")
  ## conf_level and estimate args work
  coef2 <- dr_coef(analysis, conf_level = 0.8, estimate = mean)

  expect_true(all(coef2$estimate != coef$estimate))
  expect_true(all(coef2$lower > coef$lower))

  # ### test plotting observed data works
  # gp <- dr_plot_observed(data)
  # expect_s3_class(gp, "ggplot")
  #
  # gp <- dr_plot_predicted(analysis, de_target = 0.5)
  # expect_s3_class(gp, "ggplot")

})

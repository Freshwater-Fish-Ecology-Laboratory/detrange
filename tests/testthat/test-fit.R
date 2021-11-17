test_that("fit functions work", {
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

  ### check dr_fit random
  expect_chk_error(dr_fit(data, nthin = 1L, priors = wrong_prior))
  random <- dr_fit(data, priors = new_prior, nthin = 1L)

  expect_type(random, "list")
  expect_identical(names(random), c("model", "samples", "data"))
  expect_s3_class(random$model, "jags")
  expect_s3_class(random$samples, "mcmcr")

  # check dr_fit and fixed model with nrandom argument
  fixed <- dr_fit(data, priors = new_prior, nthin = 1L, min_random = 10)

  ### check glance
  glance <- dr_glance(random)
  expect_s3_class(glance, "data.frame")
  expect_true(all(names(glance) %in% c("n", "K", "nchains", "niters",
                                       "nthin", "ess", "rhat", "converged")))

  glance <- dr_glance(fixed)
  expect_s3_class(glance, "data.frame")
  expect_true(all(names(glance) %in% c("n", "K", "nchains", "niters",
                                       "nthin", "ess", "rhat", "converged")))

  # test param_description
  param <- param_description(2, "random")
  expect_s3_class(param, "data.frame")
  expect_identical(nrow(param), 9L)

  param <- param_description(2, "fixed")
  expect_s3_class(param, "data.frame")
  expect_identical(nrow(param), 5L)

  # test coef
  coef <- dr_coef(fixed)
  expect_s3_class(coef, "data.frame")
  expect_true(all(!is.na(coef$description)))
  expect_false("sDistStation" %in% coef$term)

  coef <- dr_coef(random)
  expect_s3_class(coef, "data.frame")
  expect_true(all(!is.na(coef$description)))
  expect_true("sDistStation" %in% coef$term)

  ## conf_level and estimate args work
  coef2 <- dr_coef(random, conf_level = 0.8, estimate = mean)
  expect_true(all(coef2$estimate != coef$estimate))
  expect_true(all(coef2$lower > coef$lower))

  ## check random_effects
  coef3 <- dr_coef(random, random_effects = TRUE)
  expect_true(nrow(coef3) > nrow(coef2))

})

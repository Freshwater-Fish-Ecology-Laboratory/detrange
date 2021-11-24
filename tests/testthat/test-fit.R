test_that("fit functions work", {
  ### dr_analysis_coefficient
  data <- range_obs
  priors <- priors()

  ### check template funs
  model <- "f"
  template <- template_model(model, priors)
  expect_type(template, "character")
  derived <- template_derived(model)
  expect_type(derived, "character")

  ### check that priors can be replaced
  wrong_prior <- list(bInterce = "dnorm(0, 5^-2)")
  new_prior <- list(bIntercept = "dnorm(0, 5^-2)")
  priors2 <- replace_priors(priors, new_prior)
  expect_identical(priors2$bIntercept, new_prior$bIntercept)
  priors2 <- replace_priors(priors, wrong_prior)
  expect_identical(priors, priors2)

  ### check dr_fit
  expect_chk_error(dr_fit(data, nthin = 1L, priors = wrong_prior))

  # random slope
  random <- dr_fit(data, nthin = 1L)
  expect_identical(.chk_fit(random), random)
  expect_identical(.model_drfit(random), "rsri")

  # check attrs
  attrs <- .attrs_drfit(random)
  expect_identical(names(attrs), c("nthin", "model"))

  # fixed
  fixed <- dr_fit(data, nthin = 1L, min_random_slope = 100, min_random_intercept = 100)
  expect_identical(.chk_fit(fixed), fixed)
  expect_identical(.model_drfit(fixed), "f")

  # random intercept
  random_int <- dr_fit(data, nthin = 1L, min_random_slope = 10)
  expect_identical(.chk_fit(random_int), random_int)
  expect_identical(.model_drfit(random_int), "ri")

  # random slope
  random_slope <- dr_fit(data, nthin = 1L, min_random_intercept = 10)
  expect_identical(.chk_fit(random_slope), random_slope)
  expect_identical(.model_drfit(random_slope), "rs")

  # check seed
  seed1 <- dr_fit(data, nthin = 1L, seed = 1)
  seed2 <- dr_fit(data, nthin = 1L, seed = 2)
  seed3 <- dr_fit(data, nthin = 1L, seed = 2)
  expect_identical(seed2$samples, seed3$samples)
  expect_false(identical(seed1$samples, seed2$samples))

  ### check glance
  glance <- glance(random)
  expect_s3_class(glance, "data.frame")
  expect_true(all(names(glance) %in% c("n", "K", "nchains", "niters",
                                       "nthin", "ess", "rhat", "converged")))

  # test term_description
  desc <- description(2)
  expect_s3_class(desc, "data.frame")
  expect_identical(nrow(desc), 9L)

  # test coef
  coef <- coef(fixed)
  expect_s3_class(coef, "data.frame")
  expect_true(all(!is.na(coef$description)))
  expect_false("sDistanceStation" %in% coef$term)

  coef <- dr_coef(random_int)
  expect_true("sInterceptStation" %in% coef$term)

  coef <- dr_coef(random_slope)
  expect_true("sDistanceStation" %in% coef$term)
  expect_false("sInterceptStation" %in% coef$term)

  ## conf_level and estimate args work
  coef2 <- dr_coef(random_slope, conf_level = 0.8, estimate = mean)
  expect_true(all(coef2$estimate != coef$estimate))
  expect_true(all(coef2$lower > coef$lower))

  ## check random_effects
  coef3 <- dr_coef(random, random_effects = TRUE)
  expect_true(nrow(coef3) > nrow(coef2))

})

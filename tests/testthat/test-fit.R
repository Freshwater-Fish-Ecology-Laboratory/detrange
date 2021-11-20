test_that("fit functions work", {
  ### dr_analysis_coefficient
  data <- range_obs
  model_type <- "random"
  priors <- .priors(.terms())
  random_intercept = TRUE

  ### check template funs
  template <- .template(model_type, random_intercept)
  expect_type(template, "closure")
  model <- .model(template, priors)
  expect_type(model, "character")
  derived <- .derived(template)
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

  # check attrs
  attrs <- .attrs_drfit(random)
  expect_identical(names(attrs), c("nthin", "model_type", "random_intercept"))

  # fixed
  fixed <- dr_fit(data, nthin = 1L, min_random = 10)
  expect_identical(.chk_fit(fixed), fixed)

  # random interecept
  random_int <- dr_fit(data, nthin = 1L, min_random = 1, random_intercept = TRUE)
  expect_identical(.chk_fit(random_int), random_int)

  ### check glance
  glance <- dr_glance(random)
  expect_s3_class(glance, "data.frame")
  expect_true(all(names(glance) %in% c("n", "K", "nchains", "niters",
                                       "nthin", "ess", "rhat", "converged")))

  # test term_description
  desc <- .description(2)
  expect_s3_class(desc, "data.frame")
  expect_identical(nrow(desc), 9L)

  # test coef
  coef <- dr_coef(fixed)
  expect_s3_class(coef, "data.frame")
  expect_true(all(!is.na(coef$description)))
  expect_false("sDistanceStation" %in% coef$term)

  coef <- dr_coef(random_int)
  expect_true("sInterceptStation" %in% coef$term)

  coef <- dr_coef(random)
  expect_true("sDistanceStation" %in% coef$term)
  expect_false("sInterceptStation" %in% coef$term)

  ## conf_level and estimate args work
  coef2 <- dr_coef(random, conf_level = 0.8, estimate = mean)
  expect_true(all(coef2$estimate != coef$estimate))
  expect_true(all(coef2$lower > coef$lower))

  ## check random_effects
  coef3 <- dr_coef(random, random_effects = TRUE)
  expect_true(nrow(coef3) > nrow(coef2))

})

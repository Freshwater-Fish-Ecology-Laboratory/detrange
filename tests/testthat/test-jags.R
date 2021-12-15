test_that("test run_jags function works", {
  data <- format_colnames(detrange::range_obs)
  data <- set_classes(data)
  data_list <- data_list(data)
  priors <- priors()

  model <- template_model("rs", priors)
  monitors <- monitors()

  ### check that setting seed works
  seed <- 1
  fit <- run_jags(model, data_list, monitor = monitors, inits = NULL,
                  niters = 1000, nthin = 1, nchains = 1,
                  quiet = TRUE, seed = seed)
  est <- estimates(samples(fit))

  fit2 <- run_jags(model, data_list, monitor = monitors, inits = NULL,
                  niters = 1000, nthin = 1, nchains = 1,
                  quiet = TRUE, seed = seed)
  est2 <- estimates(samples(fit2))

  expect_identical(est, est2)

  seed <- 2
  fit3 <- run_jags(model, data_list, monitor = monitors, inits = NULL,
                   niters = 1000, nthin = 1, nchains = 1,
                   quiet = TRUE, seed = seed)
  est3 <-  estimates(samples(fit3))

  expect_false(identical(est2$bDistance, est3$bDistance))
})

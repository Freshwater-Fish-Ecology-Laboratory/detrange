test_that("generic functions work", {
  fit <- dr_fit(detrange::range_obs, min_random_intercept = 100)

  gla <- glance(fit)
  expect_identical(dr_glance(fit), gla)

  aug <- augment(fit)
  expect_identical(detrange::range_obs, aug)

  tid <- tidy(fit)
  expect_identical(dr_coef(fit), tid)

  coe <- coef(fit)
  expect_identical(coe, tid)

  sum <- summary(fit)
  expect_type(sum, "list")

  est <- estimates(fit)
  expect_identical(names(sum$arrays[[1]]), names(est))

  bint <- estimates(fit, "bIntercept")
  expect_identical(length(bint), 1L)
  expect_true(is.numeric(bint))

  pa <- pars(fit)
  expect_identical(pa, names(est))

  np <- npars(fit)
  expect_identical(np, 4L)

  ni <- niters(fit)
  expect_identical(ni, 1000L)

  nc <- nchains(fit)
  expect_identical(nc, 3L)

  nt <- nterms(fit)
  expect_identical(nt, 9L)

  rh <- rhat(fit)
  expect_true(is.numeric(rh))

  co <- converged(fit)
  expect_identical(co, FALSE)

  es <- esr(fit)
  expect_true(is.numeric(es))
})

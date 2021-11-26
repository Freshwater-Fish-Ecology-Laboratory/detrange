test_that("checking functions work", {
  dat <- detrange::range_obs

  ### check wont accept non-integer pings and detects
  dat2 <- dat
  dat2$Pings[1] <- 10.5
  chk::expect_chk_error(.chk_data(dat2))
  dat2 <- dat
  dat2$Detects[1] <- 10.5
  chk::expect_chk_error(.chk_data(dat2))

  ### check that accepts additional columns
  dat2 <- dat
  dat2$Year <- 2021
  expect_silent(.chk_data(dat2))

  ### check that wont accept missing required column
  dat2 <- dat
  dat2$Pings <- NULL
  expect_chk_error(.chk_data(dat2))

  ### check priors
  priors <- priors()
  req_params <- template_params("rs")
  # fails because more than required provided
  expect_chk_error(.chk_priors(priors, req_params))

  priors2 <- priors[1:2]
  # passes because some priors provided of the required
  expect_silent(.chk_priors(priors2, req_params))

  priors3 <- c(priors2, list(bInt = "nope"))
  expect_chk_error(.chk_priors(priors3, req_params))
})

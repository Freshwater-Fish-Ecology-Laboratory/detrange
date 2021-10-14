test_that("checking functions work", {
  dat <- detrange::range_test

  ### check wont accept non-integer pings and detects
  dat2 <- dat
  dat2$Pings[1] <- 10.5
  chk::expect_chk_error(chk_range_test(dat2))
  dat2 <- dat
  dat2$Detects[1] <- 10.5
  chk::expect_chk_error(chk_range_test(dat2))

  ### check that accepts additional columns
  dat2 <- dat
  dat2$Year <- 2021
  expect_silent(chk_range_test(dat2))

  ### check that wont accept missing required column
  dat2 <- dat
  dat2$Pings <- NULL
  expect_chk_error(chk_range_test(dat2))


})

test_that("analysis funs work", {
  data <- range_test
  analysis <- dr_analyse(data, de_target = 0.5, nthin = 1L)

  ### test new_data fun
  x <- new_data(analysis, by = "Station", distance_seq = NULL)
  expect_s3_class(x, "data.frame")
  expect_true(all(names(data) %in% names(x)))
  expect_identical(range(x$Distance), range(data$Distance))
  expect_identical(length(unique(x$Station)), length(unique(data$Station)))

  seq1 <- seq(0, 200, 100)
  x <- new_data(analysis, by = NULL, distance_seq = seq1)
  x2 <- new_data(analysis, by = character(0), distance_seq = seq1)
  expect_identical(x, x2)

  expect_s3_class(x, "data.frame")
  expect_true(all(names(data) %in% names(x)))
  expect_identical(range(x$Distance), range(seq1))
  expect_identical(length(unique(x$Station)), 1L)

  ### test predict fun
  y <- predict(analysis, x)
  expect_s3_class(y, "data.frame")
  expect_true(all(c("estimate", "lower", "upper") %in% names(y)))
  y2 <- predict(analysis, x, conf_level = 0.5, estimate = mean)
  expect_true(all(y$lower < y2$lower))
  expect_true(all(y$estimate != y2$estimate))

  ### test predict
  y3 <- dr_predict(analysis, distance_seq = seq1, by = NULL)
  expect_identical(y, y3)

  ### test param_description and coef
  random <- param_description(2, "random")
  expect_s3_class(random, "data.frame")
  expect_identical(nrow(random), 9L)

  fixed <- param_description(2, "fixed")
  expect_s3_class(fixed, "data.frame")
  expect_identical(nrow(fixed), 3L)

  coefs <- dr_coef(analysis)
  expect_s3_class(coefs, "data.frame")
  expect_true(all(names(coefs) %in% c("term", "lower", "upper", "estimate", "svalue", "description")))
})

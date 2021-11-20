test_that("predict funs work", {
  data <- range_obs
  fit <- dr_fit(data, nthin = 1L)

  ### test new_data fun
  data <- .augment(fit)
  x <- .new_data(data, seq = c("Station", "Distance"), ref = list())
  expect_s3_class(x, "data.frame")
  expect_true(all(names(data) %in% names(x)))
  expect_identical(range(x$Distance), range(data$Distance))
  expect_identical(length(unique(x$Station)), length(unique(data$Station)))

  seq1 <- seq(0, 200, 100)
  x2 <- .new_data(data, seq = character(0), ref = list(Distance = seq1))
  expect_s3_class(x, "data.frame")
  expect_identical(length(unique(x2$Station)), 1L)

  expect_s3_class(x, "data.frame")
  expect_true(all(names(data) %in% names(x)))
  expect_identical(range(x2$Distance), range(seq1))
  expect_identical(length(unique(x2$Station)), 1L)

  ### test new_expr
  model_type <- .model_type_drfit(fit)
  random_intercept <- .random_intercept_drfit(fit)
  template <- .template(model_type, random_intercept)
  derived_expr <- .derived(template)
  expect_type(derived_expr, "character")

  ### test predict fun
  x <- .new_data(data, seq = "Station", ref = list(Distance = seq1))
  y <- .predict(fit, x, derived_expr = derived_expr, monitor = "prediction")
  expect_s3_class(y, "data.frame")
  expect_true(all(c("estimate", "lower", "upper") %in% names(y)))
  y2 <- .predict(fit, x, derived_expr = derived_expr, monitor = "prediction",
                 conf_level = 0.5, estimate = mean)
  expect_true(all(y$lower < y2$lower))
  expect_true(all(y$estimate != y2$estimate))

  ### test dr_predict_distance
  de1 <- c(0.1, 0.5)
  de2 <-  0.5
  y1 <- dr_predict_distance(fit, de1)
  y2 <- dr_predict_distance(fit, de2, conf_level = 0.5, estimate = mean)
  expect_identical(round(unique(y1$de), 1), round(de1, 1))
  expect_identical(round(unique(y2$de), 1), round(de2, 1))
  y3 <- y1[y1$de == 0.5,]
  # test that conf_level and estimate work
  expect_true(all(y2$lower > y3$lower))
  expect_true(all(y2$estimate != y3$estimate))

  ### test dr_de_at_distance
  dist <- c(10, 100)
  dist2 <- 100
  y1 <- dr_predict_de(fit, dist)
  y2 <- dr_predict_de(fit, dist2, conf_level = 0.5, estimate = mean)
  expect_identical(unique(y1$Distance), dist)
  expect_identical(unique(y2$Distance), dist2)
  y3 <- y1[y1$de == 100,]
  # test that conf_level and estimate work
  expect_true(all(y2$lower > y3$lower))
  expect_true(all(y2$estimate != y3$estimate))
  expect_identical(nrow(y2), length(unique(data$Station)))

  # test distance = NULL
  y4 <- dr_predict_de(fit, distance = NULL)
  expect_identical(range(y4$Distance), c(0, 900))

  # test by = NULL
  y5 <- dr_predict_de(fit, distance = dist2, by = NULL)
  expect_identical(nrow(y5), 1L)

})

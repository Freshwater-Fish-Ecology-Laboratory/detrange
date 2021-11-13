test_that("analysis funs work", {
  data <- range_test
  analysis <- dr_analyse(data, nthin = 1L)

  ### test new_data fun
  x <- new_data(analysis, seq = c("Station", "Distance"), ref = list())
  expect_s3_class(x, "data.frame")
  expect_true(all(names(data) %in% names(x)))
  expect_identical(range(x$Distance), range(data$Distance))
  expect_identical(length(unique(x$Station)), length(unique(data$Station)))

  seq1 <- seq(0, 200, 100)
  x2 <- new_data(analysis, seq = character(0), ref = list(Distance = seq1))
  expect_s3_class(x, "data.frame")
  expect_identical(length(unique(x2$Station)), 1L)

  expect_s3_class(x, "data.frame")
  expect_true(all(names(data) %in% names(x)))
  expect_identical(range(x2$Distance), range(seq1))
  expect_identical(length(unique(x2$Station)), 1L)

  ### test new_expr
  new_expr <- new_expr("random", "prediction")
  new_expr2 <- new_expr("random", "target", 0)
  new_expr3 <- new_expr("fixed", "target", 0)
  expect_type(new_expr, "character")
  expect_type(new_expr2, "character")
  expect_type(new_expr3, "character")
  expect_true(all(new_expr != new_expr2, new_expr2 != new_expr3, new_expr2 != new_expr3))

  ### test predict fun
  x <- new_data(analysis, seq = "Station", ref = list(Distance = seq1))
  y <- predict(analysis, x, new_expr = new_expr, monitor = "prediction")
  expect_s3_class(y, "data.frame")
  expect_true(all(c("estimate", "lower", "upper") %in% names(y)))
  y2 <- predict(analysis, x, new_expr = new_expr, monitor = "prediction", conf_level = 0.5, estimate = mean)
  expect_true(all(y$lower < y2$lower))
  expect_true(all(y$estimate != y2$estimate))

  ### test predict
  y3 <- dr_predict(analysis, distance_seq = seq1, by = "Station")
  expect_identical(clean_predict(y, "Station"), y3)
  y4 <- dr_predict(analysis, distance_seq = seq1, by = NULL)
  expect_true(nrow(y4) < nrow(y3))
  expect_true(!("Station" %in% names(y4)))
  y5 <- dr_predict(analysis, distance_seq = NULL, by = "Station")
  expect_s3_class(y5, "data.frame")
  expect_identical(range(y5$Distance), range(data$Distance))
  y6 <- dr_predict(analysis, distance_seq = NULL, by = NULL)
  expect_s3_class(y6, "data.frame")
  expect_identical(range(y5$Distance), range(data$Distance))

  ### test dr_distance_at_de
  z <- dr_distance_at_de(analysis)
  expect_s3_class(z, "data.frame")
  expect_identical(unique(z$Station), unique(data$Station))
  z2 <- dr_distance_at_de(analysis, de_target = 0.9)
  expect_true(all(z2$estimate < z$estimate))
  z3 <- dr_distance_at_de(analysis, de_target = 0.1)
  expect_true(all(z3$estimate > z$estimate))
  z4 <- dr_distance_at_de(analysis, by = NULL)
  expect_identical(nrow(z4), 1L)
  z5 <- dr_distance_at_de(analysis, by = NULL, conf_level = 0.5, estimate = mean)
  expect_true(z5$estimate != z4$estimate)
  expect_true(z5$lower > z4$lower)

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

  ### plot
  gp <- dr_plot(data)
  expect_s3_class(gp, "ggplot")
  gp <- gp %>% add_geom_predicted(y5)
  expect_s3_class(gp, "ggplot")
  gp <- gp %>% add_geom_distance_at_de(z)
  expect_s3_class(gp, "ggplot")
})

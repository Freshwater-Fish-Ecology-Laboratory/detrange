test_that("check plot funs work", {
  data <- detrange::range_obs
  data <- data[data$Station %in% c("Station1", "Station2"),]
  fit <- dr_fit(data, min_random_slope = 1, min_random_intercept = 1)

  ### drfit method for predict plot
  gp <- dr_plot_predict(fit)
  chk_s3_class(gp, "ggplot")

  gp2 <- autoplot(fit)
  expect_identical(gp$data, gp2$data)

  ### data.frame method for predict plot
  pred <- dr_predict_de(fit)
  gp2 <- dr_plot_predict(data, pred)
  chk_s3_class(gp2, "ggplot")
  expect_identical(gp$data, gp2$data)

  gp3 <- dr_plot_predict(data, pred, facet = FALSE)
  chk_s3_class(gp2, "ggplot")

  ### data.frame method for plot
  gp <- dr_plot(data)
  chk_s3_class(gp, "ggplot")

  gp <- dr_plot(data, facet = FALSE)
  chk_s3_class(gp, "ggplot")

  ### drfit method for plot
  gp <- dr_plot(fit)
  chk_s3_class(gp, "ggplot")

})

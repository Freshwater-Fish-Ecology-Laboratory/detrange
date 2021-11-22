test_that("check plot funs work", {
  data <- detrange::range_obs
  fit <- dr_fit(data)

  ### drfit method for predict plot
  gp <- dr_plot_predict(fit)
  chk_s3_class(gp, "ggplot")

  ### data.frame method for predict plot
  pred <- dr_predict_de(fit)
  gp2 <- dr_plot_predict(data, pred)
  chk_s3_class(gp2, "ggplot")

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

range <- read.csv("~/onedrive/data/wsgcolr/range-test/range_test.csv")

range <- range[!(range$station %in% c("Rivervale", "HLK")),]
station <- data.frame(station = unique(range$station))
station$depth_receiver <- round(runif(nrow(station), 2, 3), 1)

range <- merge(range, station, "station")
range$depth_tag <- range$depth
range$depth <- NULL
range$pings <- range$detects_expected
range$detects_expected <- NULL
range <- range[c("station", "distance", "pings", "detects", "depth_receiver", "depth_tag")]

range_obs <- range
usethis::use_data(range_obs, overwrite = TRUE)

fit <- dr_fit(range_obs)
range_pred <- dr_predict_de(fit)
usethis::use_data(range_pred, overwrite = TRUE)


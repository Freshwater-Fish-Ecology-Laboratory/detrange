library(SiMRiv)

lake <- fwapgr::fwa_collection("whse_basemapping.fwa_lakes_poly",
                               filter = list(gnis_name_1 = "Horse Lake"))
lake <- lake[1,]

## turning angle concentration (number form 0 to 1 - 0 being uniform dist resulting in random walk)
turn_conc <- 0.98
## perceptual range
pwind <- perceptualRange(type = "circular", 10)
## step length in map units (does this mean raster resolution? or proj units? - must be raster resolution)
step_len <- 1
name <- "CorrelatedRW"

move_state <- state(turn_conc, pwind = pwind, steplen = step_len, name = name)
rest_state <- state.RW()

wsg_movement <- species(list(move_state, rest_state),
                       trans = transitionMatrix(0.005, 0.01),
                       name = "White Sturgeon")

p4s_bc <- CRS('+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0')

lake_sp <- lake %>%
  # sf::st_buffer(1000) %>%
  sf::as_Spatial() %>%
  spTransform(p4s_bc)

resistance <- resistanceFromShape(lake_sp, res = 10)

init = xyFromCell(resistance, sample(which(values(resistance) == 0), 1))
sim_wsg <- simulate(wsg_movement, 1000000, resist = resistance, coords = init)
plot(sim_wsg, type = "l", asp = 1)

plot(resistance, axes = F)
lines(sim_wsg)


run_jags <- function(template, data, monitor, inits, niters, nchains, nthin, quiet) {

  model <- rjags::jags.model(textConnection(template), data, inits = inits,
                             n.adapt = 0, quiet = quiet, n.chains = nchains)

  progress_bar <- if(quiet) "none" else "text"

  niters <- niters * nthin
  adapted <- rjags::adapt(model, n.iter = floor(niters / 2),
                          progress.bar = progress_bar,
                          end.adaptation = TRUE)

  # if (!adapted) warning("incomplete adaptation")

  update(model, n.iter = floor(niters / 2),
         progress.bar = progress_bar)

  monitor <- monitor[monitor %in% stats::variable.names(model)]

  samples <- rjags::jags.samples(model = model, variable.names = monitor,
                                 n.iter = niters, thin = nthin,
                                 progress.bar = progress_bar)
  samples <- mcmcr::as.mcmcr(samples)
  # converged <- mcmcr::converged(samples)
  # if(!converged) warning("model did not converge")
  list(model = model, samples = samples)
}



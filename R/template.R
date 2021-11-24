template_derived <- function(model){
  switch(model,
    f = .derived_f(),
    rs = .derived_rs(),
    ri = .derived_ri(),
    rsri = .derived_rsri()
    )
}

template_model <- function(model, priors){
  switch(model,
    f = .model_f(priors),
    rs = .model_rs(priors),
    ri = .model_ri(priors),
    rsri = .model_rsri(priors))
}



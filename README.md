
<!-- README.md is generated from README.Rmd. Please edit that file -->

# detrange

## Introduction

#### Detection Range and Detection Efficiency

`detrange` estimates detection range (DR) from multiple stations within
a passive acoustic telemetry array using range testing data collected in
the field. DR is defined by Kessel et al. (2014) as

> “… the relationship between detection probability and the distance
> between the receiver and tag…presented graphically in the form of a
> logistic curve of detection probability.”

Given a modeled DR, it is possible to estimate the distance at which a
target detection efficiency (DE) occurs. DE is defined by Brownscombe et
al (2019) as

> “\[t\]he number of acoustic transmitter detections effectively logged
> by an acoustic receiver in a given time period, expressed as a
> percentage (or proportion) of total potential detections based on
> transmission rate.”

Following recommendations from Brownscombe et al (2019) and Huveneers et
al. (2016), it can be useful to estimate the midpoint of the DR
(i.e. distance at 50% DE) in order to place sentinel tags at a sample of
receivers to measure variation in DE over time.

#### The modelling approach

Under the hood, `detrange` uses JAGS software and the
[rjags](https://cran.r-project.org/web/packages/rjags/rjags.pdf) R
package to implement a Bayesian generalized linear model with logit link
and binomial response distribution. If there are 5 or more stations, the
model is fit as a generalized linear mixed-effects model with random
intercept and slope for each Station. Otherwise, Station is treated as a
fixed effect.

A benefit of using a Bayesian approach is that uncertainty can be
quantifed for estimates of the distance at which a specified DE occurs.
In Bayesian lingo, the uncertainty of this derived parameter can be
estimated with the posterior distributions of other parameters in the
model.

Another benefit is the ability to incorporate prior information. By
default, the priors used in the model are non-informative. However, the
user may set custom priors, e.g., if prior information about realistic
detection range in a given system is known or if data is limited.

## Demonstration

### Data

`detrange` expects data typical of detection range testing. Mandatory
columns include:

-   `Station` (factor)  
-   `Distance` (numeric)  
-   `Detects` (integer)  
-   `Pings` (integer)

`Pings` is the expected number of detections and `Detects` is the
observed number of detections over the duration of the range testing
time period at a given distance. An example dataset `range_test` is
included for reference.

``` r
library(detrange)

### view example dataset
data <- range_test
head(data)
#> # A tibble: 6 × 4
#>   Distance Pings Detects Station 
#>      <dbl> <int>   <int> <fct>   
#> 1       50    51      50 Station1
#> 2      155    57      45 Station2
#> 3      275    51      10 Station3
#> 4      409    50       4 Station4
#> 5      564    56       0 Station5
#> 6      659    57      33 Station6
```

### Analysis

Fit a model

``` r
# adjust the `nthin` argument to improve convergence.
fit <- dr_fit(data)
#> Registered S3 method overwritten by 'mcmcr':
#>   method               from 
#>   as.mcmc.list.mcarray rjags
```

The returned object has class `drfit`. A number of generic methods are
defined, including `glance`, `tidy`, `coef`, `augment`, `summary`,
`estimates`, `autoplot`, and `predict`.

``` r
glance(fit)
#> # A tibble: 1 × 8
#>       n     K nchains niters nthin   ess  rhat converged
#>   <dbl> <int>   <int>  <int> <dbl> <int> <dbl> <lgl>    
#> 1    42     4       3   1000    10    39  1.31 FALSE
```

``` r
tidy(fit, conf_level = 0.89)
#> # A tibble: 3 × 6
#>   term         estimate    lower   upper svalue description                     
#>   <term>          <dbl>    <dbl>   <dbl>  <dbl> <chr>                           
#> 1 bDist        -0.0156  -0.0323  -0.0101   11.6 Effect of distance on logit(`eD…
#> 2 bIntercept    4.77     4.41     5.14     11.6 Intercept of logit(`eDetects`)  
#> 3 sDistStation  0.00702  0.00416  0.0194   11.6 Standard deviation of `bDistSta…
```

Predict distance(s) at target levels of detection efficiency

``` r
predicted_dist <- dr_predict_distance(fit, de = c(0.5, 0.8))
head(predicted_dist)
#>    Station  de estimate    lower    upper   svalue
#> 1 Station1 0.5 389.7861 364.3126 415.5707 11.55123
#> 7 Station1 0.8 277.9397 255.1301 300.9553 11.55123
#> 2 Station2 0.5 246.7910 227.5348 267.9408 11.55123
#> 8 Station2 0.8 176.3395 160.0805 193.4942 11.55123
#> 3 Station3 0.5 219.3995 199.2574 238.5806 11.55123
#> 9 Station3 0.8 156.7078 140.8057 173.0853 11.55123
```

Predict detection efficiency at distance(s)

``` r
predicted_de <- dr_predict_de(fit, distance = seq(0, 1000, 50)) 
head(predicted_de)
#>     Station Distance  estimate     lower     upper   svalue
#> 1  Station1        0 0.9915769 0.9871333 0.9947042 11.55123
#> 7  Station1       50 0.9844739 0.9773648 0.9896813 11.55123
#> 13 Station1      100 0.9715376 0.9602559 0.9800477 11.55123
#> 19 Station1      150 0.9483973 0.9311731 0.9621330 11.55123
#> 25 Station1      200 0.9081576 0.8810294 0.9301988 11.55123
#> 31 Station1      250 0.8418280 0.8015368 0.8762597 11.55123
```

Plot results with `dr_plot()`

``` r
# dr_plot(data) |>
#   add_geom_predicted_de(predicted_de) |>
#   add_geom_predicted_distance(predicted_distance)
```

### How to do more

The output of `dr_fit()` is a list with 3 elements:  
1. `fit$model` - the model object of class `jags` created by
`rjags::jags.model()`  
1. `fit$samples` - the MCMC samples generated
from`rjags::jags.samples()` converted to `mcmcr` class  
1. `fit$data` - the detection range data provided

These are the raw materials for any further exploration or analysis. For
example, view trace and density plots with `plot(fit$samples)`.

See [mcmcr](https://github.com/poissonconsulting/mcmcr) and
[mcmcderive](https://github.com/poissonconsulting/mcmcderive) for
working with `mcmcr` objects, or convert samples to an object of class
`mcmc.list`, e,g, with `coda::as.mcmc.list` for working with the
[coda](https://github.com/cran/coda) R package.

## Code of Conduct

Please note that the detrange project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Installation

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Freshwater-Fish-Ecology-Laboratory/detrange")
```

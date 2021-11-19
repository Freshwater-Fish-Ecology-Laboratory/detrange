
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
detrange::range_test
#> # A tibble: 42 × 4
#>    Distance Pings Detects Station 
#>       <dbl> <int>   <int> <fct>   
#>  1       50    51      50 Station1
#>  2      155    57      45 Station2
#>  3      275    51      10 Station3
#>  4      409    50       4 Station4
#>  5      564    56       0 Station5
#>  6      659    57      33 Station6
#>  7      782    59       0 Station1
#>  8       13    59      58 Station2
#>  9      146    51      42 Station3
#> 10      264    58      38 Station4
#> # … with 32 more rows
```

### Analysis

Fit a model

``` r
# adjust the `nthin` argument to improve convergence.
fit <- dr_fit(detrange::range_test)
#> Registered S3 method overwritten by 'mcmcr':
#>   method               from 
#>   as.mcmc.list.mcarray rjags
```

The returned object has class `drfit`. A number of generic methods are
defined, including `glance`, `tidy`, `coef`, `augment`, `summary`,
`estimates`, `autoplot`, and `predict`.

``` r
tidy(fit, conf_level = 0.89)
#> # A tibble: 3 × 6
#>   term         estimate    lower   upper svalue description                     
#>   <term>          <dbl>    <dbl>   <dbl>  <dbl> <chr>                           
#> 1 bDist        -0.0161  -0.0210  -0.0114   11.6 Effect of distance on logit(`eD…
#> 2 bIntercept    4.78     4.42     5.16     11.6 Intercept of logit(`eDetects`)  
#> 3 sDistStation  0.00672  0.00403  0.0133   11.6 Standard deviation of `bDistSta…
```

Predict distance(s) at target levels of detection efficiency

``` r
predicted_dist <- dr_predict_distance(fit, de = c(0.5, 0.8))
head(predicted_dist)
#>    Station  de estimate    lower    upper   svalue
#> 1 Station1 0.5 389.4664 364.6526 415.1351 11.55123
#> 7 Station1 0.8 277.7559 255.7676 300.3175 11.55123
#> 2 Station2 0.5 246.7998 227.7792 268.7735 11.55123
#> 8 Station2 0.8 176.5454 161.0380 193.8171 11.55123
#> 3 Station3 0.5 219.1731 200.3614 239.3453 11.55123
#> 9 Station3 0.8 157.1079 141.1661 173.6261 11.55123
```

Predict detection efficiency at distance(s)

``` r
predicted_de <- dr_predict_de(fit, distance = seq(0, 1000, 50)) 
head(predicted_de)
#>     Station Distance  estimate     lower     upper   svalue
#> 1  Station1        0 0.9916562 0.9874239 0.9948447 11.55123
#> 7  Station1       50 0.9846018 0.9777962 0.9899222 11.55123
#> 13 Station1      100 0.9717131 0.9609102 0.9804452 11.55123
#> 19 Station1      150 0.9486379 0.9316174 0.9626865 11.55123
#> 25 Station1      200 0.9084043 0.8817604 0.9304673 11.55123
#> 31 Station1      250 0.8419906 0.8025500 0.8755837 11.55123
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

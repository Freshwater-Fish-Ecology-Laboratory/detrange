
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
al. (2016), it can be useful to estimate the distance at which a target
level of DE occurs (i.e. midpoint of DR at 50% DE), e.g. to place
sentinel tags at a sample of receivers to measure variation in DE over
time.

#### The modelling approach

Under the hood, `detrange` uses JAGS software and the
[rjags](https://cran.r-project.org/web/packages/rjags/rjags.pdf) R
package to implement a Bayesian generalized linear model with logit link
and binomial response distribution. The user may choose to fit a
generalized linear mixed-effects model with random slope and/or random
intercept for each Station. Otherwise, Station is treated as a fixed
effect.

A benefit of using a Bayesian approach is that uncertainty can be
quantified for estimates of the distance at which a specified DE occurs
(i.e., a derived parameter). Another benefit is the ability to
incorporate prior information. By default, the priors used in the model
are non-informative. However, the user may set custom priors, e.g., if
prior information about realistic detection range in a given system is
known or if data is limited.

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
detrange::range_obs
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
fit <- dr_fit(detrange::range_obs)
#> Registered S3 method overwritten by 'mcmcr':
#>   method               from 
#>   as.mcmc.list.mcarray rjags
```

A number of generic methods are defined for the output object of
`dr_fit()`, including `autoplot` `glance`, `tidy`, `coef`, `augment`,
`summary`, `estimates`, and `predict`.

``` r
glance(fit)
#> # A tibble: 1 × 8
#>       n     K nchains niters nthin   ess  rhat converged
#>   <dbl> <int>   <int>  <int> <dbl> <int> <dbl> <lgl>    
#> 1    42     6       3   1000    10   120  1.01 FALSE
```

``` r
tidy(fit, conf_level = 0.89)
#> # A tibble: 4 × 6
#>   term              estimate    lower   upper svalue description                
#>   <term>               <dbl>    <dbl>   <dbl>  <dbl> <chr>                      
#> 1 bDistance         -0.0162  -0.0219  -0.0111   8.74 Effect of distance on logi…
#> 2 bIntercept         4.77     4.23     5.34    11.6  Intercept of logit(`eDetec…
#> 3 sDistanceStation   0.00685  0.00386  0.0149  11.6  Standard deviation of `bDi…
#> 4 sInterceptStation  0.445    0.0526   1.52    11.6  Standard deviation of `bIn…
```

Plot predicted detection range

``` r
autoplot(fit)
```

![](man/figures/README-unnamed-chunk-5-1.png)<!-- -->

Predict distance(s) at target levels of detection efficiency

``` r
predicted_dist <- dr_predict_distance(fit, de = c(0.5, 0.8))
head(predicted_dist)
#>    Station  de estimate    lower    upper   svalue
#> 1 Station1 0.5 389.3697 364.7692 416.2844 11.55123
#> 7 Station1 0.8 276.8753 247.0259 305.5638 11.55123
#> 2 Station2 0.5 244.7734 222.2829 266.1706 11.55123
#> 8 Station2 0.8 170.0843 143.8369 192.5909 11.55123
#> 3 Station3 0.5 215.9613 195.1305 237.4502 11.55123
#> 9 Station3 0.8 150.3942 124.2386 170.9276 11.55123
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


<!-- README.md is generated from README.Rmd. Please edit that file -->

# detrange

##### \*\*\* Please note that this package is still experimental - API may change in the future \*\*\*

## Installation

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Freshwater-Fish-Ecology-Laboratory/detrange")
```

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
#>    Station  Distance Pings Detects
#>    <fct>       <dbl> <int>   <int>
#>  1 Station1      125   111      95
#>  2 Station1      212   121      61
#>  3 Station1      324   116       6
#>  4 Station1      536   108       0
#>  5 Station1      576   142       0
#>  6 Station1      811   136       0
#>  7 Station1      937   132       0
#>  8 Station2      130   108      93
#>  9 Station2      283   122       6
#> 10 Station2      339   145       1
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
#> 1    42     6       3   1000    10    27  1.09 FALSE
```

``` r
tidy(fit, conf_level = 0.89)
#> # A tibble: 4 × 6
#>   term              estimate    lower   upper svalue description                
#>   <term>               <dbl>    <dbl>   <dbl>  <dbl> <chr>                      
#> 1 bDistance         -0.0203  -0.0277  -0.0137   8.74 Effect of distance on logi…
#> 2 bIntercept         5.33     4.88     5.87    11.6  Intercept of logit(`eDetec…
#> 3 sDistanceStation   0.00933  0.00554  0.0195  11.6  Standard deviation of `bDi…
#> 4 sInterceptStation  0.432    0.0531   1.39    11.6  Standard deviation of `bIn…
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
#> 1 Station1 0.5 214.2234 203.5032 225.6082 11.55123
#> 7 Station1 0.8 157.4464 143.2458 170.2870 11.55123
#> 2 Station2 0.5 189.3641 176.6194 202.8207 11.55123
#> 8 Station2 0.8 144.4096 131.2160 161.0342 11.55123
#> 3 Station3 0.5 398.7436 380.9732 417.9149 11.55123
#> 9 Station3 0.8 294.6026 272.2866 317.6278 11.55123
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

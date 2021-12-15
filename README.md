
<!-- README.md is generated from README.Rmd. Please edit that file -->

# detrange

##### \*\*\* Please note that this package is still experimental. The API may change in the future. Feel free to drop some issues with questions/bugs/ideas/feedback! \*\*\*

## Installation

To use `detrange`, you must have JAGS installed on your system. Go to
<http://mcmc-jags.sourceforge.net> for instructions. On a mac, you can
also install JAGS from homebrew with `brew install jags`.

Once JAGS is installed, install the development version of `detrange`
from [GitHub](https://github.com/) with:

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
quantified for estimates of the distance at which a specified DE occurs.
Another benefit is the ability to incorporate prior information. By
default, the priors used in the model are non-informative. However, the
user may set custom priors, e.g., if prior information about realistic
detection range in a given system is known or if data are limited.

## Demonstration

### Data

`detrange` expects data typical of detection range testing.

Mandatory columns include:

-   `station` (character or factor)  
-   `distance` (positive numeric)  
-   `detects` (whole numeric)  
-   `pings` (whole numeric)

Optional columns include:

-   `depth_receiver` (positive numeric)  
-   `depth_tag` (postive numeric)

`pings` is the expected number of detections and `detects` is the
observed number of detections over the duration of the range testing
time period at a given distance. If `depth_receiver` and `depth_tag` are
provided, distance is corrected to account for depth.

An example dataset `range_test` is included for reference.

``` r
library(detrange)
head(detrange::range_obs)
#>        station distance pings detects depth_receiver depth_tag
#> 1 Border Right      100    90      70            3.0       7.0
#> 2 Border Right      200    96       0            3.0       3.6
#> 3 Border Right      300    78      10            3.0       1.8
#> 4 Border Right      400    90       0            3.0       9.4
#> 5      Genelle      100    78      68            2.3       7.4
#> 6      Genelle      250    78       7            2.3       5.1
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
# model summary
glance(fit)
#> # A tibble: 1 × 8
#>       n     K nchains niters nthin   ess  rhat converged
#>   <dbl> <int>   <int>  <int> <dbl> <int> <dbl> <lgl>    
#> 1    23     6       3   1000    10    51  1.09 FALSE
```

``` r
# parameter estimates
tidy(fit, conf_level = 0.89)
#> # A tibble: 4 × 6
#>   term              estimate   lower    upper svalue description                
#>   <term>               <dbl>   <dbl>    <dbl>  <dbl> <chr>                      
#> 1 bDistance          -0.0248 -0.0406 -0.00992   5.49 Effect of distance on logi…
#> 2 bIntercept          3.92    1.73    5.99      5.62 Intercept of logit(`eDetec…
#> 3 sDistanceStation    0.0201  0.0111  0.0423   11.6  Standard deviation of `bDi…
#> 4 sInterceptStation   2.80    1.60    6.15     11.6  Standard deviation of `bIn…
```

``` r
# original data with corrected distance
head(augment(fit))
#>        Station Distance Pings Detects DepthReceiver DepthTag DistanceRaw
#> 1 Border Right 100.0800    90      70           3.0      7.0         100
#> 2 Border Right 200.0009    96       0           3.0      3.6         200
#> 3 Border Right 300.0024    78      10           3.0      1.8         300
#> 4 Border Right 400.0512    90       0           3.0      9.4         400
#> 5      Genelle 100.1300    78      68           2.3      7.4         100
#> 6      Genelle 250.0157    78       7           2.3      5.1         250
```

Plot predicted detection range

``` r
autoplot(fit)
```

![](man/figures/README-unnamed-chunk-6-1.png)<!-- -->

Predict distance(s) at target levels of detection efficiency

``` r
predicted_dist <- dr_predict_distance(fit, de = c(0.5, 0.8))
head(predicted_dist)
#>        Station  de  estimate     lower     upper   svalue
#> 1 Border Right 0.5 133.78845 119.82756 147.18271 11.55123
#> 7 Border Right 0.8  76.31486  52.11954  96.51069 11.55123
#> 2      Genelle 0.5 180.47057 158.48262 200.90797 11.55123
#> 8      Genelle 0.8 104.23110  70.08540 130.26285 11.55123
#> 3    Glenmarry 0.5 147.58768 134.06424 163.19103 11.55123
#> 9    Glenmarry 0.8 121.75911 109.17899 135.37747 11.55123
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

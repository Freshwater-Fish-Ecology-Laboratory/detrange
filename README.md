
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
#>   Station  Distance Detects Pings
#>   <fct>       <dbl>   <int> <int>
#> 1 Station1       48      98   104
#> 2 Station1      146      72   138
#> 3 Station1      209      28   178
#> 4 Station1      332       0    55
#> 5 Station1      408       1   119
#> 6 Station1      511       0   154
```

### Analysis

To estimate detection range, use `dr_analyse()`

``` r
analysis <- dr_analyse(data)
#> Registered S3 method overwritten by 'mcmcr':
#>   method               from 
#>   as.mcmc.list.mcarray rjags
```

Check model convergence with `dr_glance()`. Try adjusting the `nthin`
argument in `dr_analyse()` to improve convergence. Higher `nthin`
generates more sample iterations.

``` r
dr_glance(analysis)
#> # A tibble: 1 × 8
#>       n     K nchains niters nthin   ess  rhat converged
#>   <int> <dbl>   <int>  <int> <int> <int> <dbl> <lgl>    
#> 1    38     4       3   1000    10    18  1.43 FALSE
```

Look at model coefficient estimates `dr_coef()`

``` r
coef <- dr_coef(analysis, conf_level = 0.89)
coef
#> # A tibble: 4 × 6
#>   term              estimate    lower   upper svalue description                
#>   <term>               <dbl>    <dbl>   <dbl>  <dbl> <chr>                      
#> 1 bDist              -0.0201 -0.0294  -0.0137   11.6 Effect of distance on logi…
#> 2 bIntercept          3.63    2.65     4.72     11.6 Intercept of logit(`eDetec…
#> 3 sDistStation        0.0140  0.00831  0.0273   11.6 Standard deviation of `bDi…
#> 4 sInterceptStation   1.13    0.578    2.49     11.6 Standard deviation of `bIn…
```

Predict distance at which a target level of detection efficiency occurs
with `dr_distance_at_de()`

``` r
midpoint <- dr_distance_at_de(analysis, de_target = 0.5, conf_level = 0.8)
midpoint
#>   Station Distance estimate    lower    upper   svalue
#> 1       1 294.6053 152.2849 145.8452 158.3295 11.55123
#> 2       2 294.6053 170.3947 160.1255 180.2049 11.55123
#> 3       3 294.6053 477.4832 454.6989 501.4925 11.55123
#> 4       4 294.6053 319.6326 306.9906 333.0834 11.55123
#> 5       5 294.6053 289.2352 278.0037 300.1258 11.55123
#> 6       6 294.6053 136.5460 130.4783 142.3214 11.55123
```

Predict detection efficiency at a sequence of distances with
`dr_predict()`

``` r
predicted <- dr_predict(analysis, distance_seq = seq(0, 1000, 100)) 
head(predicted)
#>    Station Distance     estimate        lower        upper   svalue
#> 1        1        0 9.806598e-01 9.620123e-01 0.9913530977 11.55123
#> 7        1      100 7.819315e-01 7.177573e-01 0.8389098768 11.55123
#> 13       1      200 2.029414e-01 1.550577e-01 0.2516542707 11.55123
#> 19       1      300 1.758094e-02 8.635673e-03 0.0327082352 11.55123
#> 25       1      400 1.263482e-03 3.972597e-04 0.0035892538 11.55123
#> 31       1      500 9.052403e-05 1.762997e-05 0.0003864832 11.55123
```

Plot results with `dr_plot_predicted()`

``` r
### coefficient table
# dr_analysis_coef(analysis)
```

### How to do more

The output of `dr_analyse()` is an object of s3 class `dr_model`. It
contains a list with two elements:  
1. `analysis$model` - the model object of class `jags` created by
`rjags::jags.model()`  
1. `analysis$samples` - the MCMC samples generated
from`rjags::jags.samples()` and converted to `mcmcr` class

These objects are the raw materials for any further exploration or
analysis. For example, view trace and density plots with
`plot(analysis$samples)`.

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


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
#> 1    38     4       3   1000    10    15  1.16 FALSE
```

Look at model coefficient estimates `dr_coef()`

``` r
coef <- dr_coef(analysis, conf_level = 0.89)
head(coef)
#> # A tibble: 6 × 6
#>   term            estimate     lower    upper svalue description
#>   <term>             <dbl>     <dbl>    <dbl>  <dbl> <chr>      
#> 1 bDist           -0.0177  -0.0250   -0.00987  11.6  <NA>       
#> 2 bDistStation[1] -0.00872 -0.0171   -0.00103   4.10 <NA>       
#> 3 bDistStation[2] -0.00451 -0.0128    0.00346   1.33 <NA>       
#> 4 bDistStation[3]  0.0122   0.00443   0.0196    9.97 <NA>       
#> 5 bDistStation[4]  0.00481 -0.00308   0.0125    1.44 <NA>       
#> 6 bDistStation[5]  0.00692 -0.000912  0.0143    2.66 <NA>
```

Predict distance at which a target level of detection efficiency occurs
with `dr_distance_at_de()`

``` r
midpoint <- dr_distance_at_de(analysis, de_target = 0.5, conf_level = 0.8)
midpoint
#>   Station estimate    lower    upper   svalue
#> 1       1 152.1880 145.7039 158.1136 11.55123
#> 2       2 170.1580 159.8890 180.2851 11.55123
#> 3       3 476.5847 454.4783 501.2350 11.55123
#> 4       4 319.6113 307.0666 333.4099 11.55123
#> 5       5 289.2454 277.7183 300.7178 11.55123
#> 6       6 136.3924 130.2890 141.9790 11.55123
```

Predict detection efficiency at a sequence of distances with
`dr_predict()`

``` r
predicted <- dr_predict(analysis, distance_seq = seq(0, 1000, 100)) 
head(predicted)
#>    Station Distance     estimate        lower        upper   svalue
#> 1        1        0 9.804819e-01 9.609143e-01 0.9906552218 11.55123
#> 7        1      100 7.817693e-01 7.159707e-01 0.8364171289 11.55123
#> 13       1      200 2.034413e-01 1.594169e-01 0.2515770486 11.55123
#> 19       1      300 1.782497e-02 9.113235e-03 0.0332016355 11.55123
#> 25       1      400 1.292232e-03 4.315830e-04 0.0037830443 11.55123
#> 31       1      500 9.173364e-05 2.003323e-05 0.0004160007 11.55123
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


<!-- README.md is generated from README.Rmd. Please edit that file -->

# detrange

<!-- badges: start -->
<!-- badges: end -->

## Introduction

`detrange` estimates detection range from multiple stations within a
passive acoustic telemetry array. Under the hood is a Bayesian
mixed-effects logistic linear regression model. Each station has a
random intercept and slope.

## Demonstration

### Data

`detrange` expects range test data, which must include columns
`Station`, `Distance`, `Detects` and `Pings`. `Pings` is the expected
number of detections. An example dataset `range_test` is included for
reference.

``` r
library(detrange)
library(jmbr)
#> Registered S3 method overwritten by 'mbr':
#>   method         from
#>   pars.character term

### view example dataset
data <- range_test
data
#> # A tibble: 34 × 4
#>    Station  Distance Detects Pings
#>    <fct>       <dbl>   <int> <int>
#>  1 Station1       44     109   113
#>  2 Station1      105     135   144
#>  3 Station1      203      90   120
#>  4 Station1      326      29   123
#>  5 Station1      431       5   133
#>  6 Station2       40     117   123
#>  7 Station2      135      73   107
#>  8 Station2      209      31    76
#>  9 Station2      300      25   146
#> 10 Station2      433       0   113
#> # … with 24 more rows
```

### Analysis

Detection range is modelled using `dr_analyse`. It is possible for the
user to set their own priors. If the model fails to converge, increase
the value of `nthin`.

``` r
analysis <- dr_analyse(data, nthin = 1L)
#> Registered S3 method overwritten by 'rjags':
#>   method               from 
#>   as.mcmc.list.mcarray mcmcr
#> # A tibble: 1 × 8
#>       n     K nchains niters nthin   ess  rhat converged
#>   <int> <int>   <int>  <int> <int> <int> <dbl> <lgl>    
#> 1    34     4       3   1000     1   138  1.01 FALSE
```

With the analysis object, view various summary tables and plots,
including the detection range midpoint estimates and confidence
intervals.

``` r
### coefficient table
dr_analysis_coef(analysis)
#> # A tibble: 4 × 5
#>   term              estimate   lower  upper svalue
#>   <term>               <dbl>   <dbl>  <dbl>  <dbl>
#> 1 bIntercept           3.93    3.22    4.48   11.6
#> 2 bMidpoint          287.    270.    301.     11.6
#> 3 sInterceptStation    0.495   0.154   1.38   11.6
#> 4 sMidpointStation    15.9    13.8    18.2    11.6
```

``` r
### get midpoint estimates
dr_analysis_midpoint(analysis)
#> # A tibble: 6 × 5
#>   Station  estimate lower upper svalue
#>   <fct>       <dbl> <dbl> <dbl>  <dbl>
#> 1 Station1     263.  249.  276.   11.6
#> 2 Station2     208.  196.  221.   11.6
#> 3 Station3     314.  299.  329.   11.6
#> 4 Station4     373.  353.  395.   11.6
#> 5 Station5     308.  293.  324.   11.6
#> 6 Station6     250.  236.  265.   11.6
```

``` r
### plot predicted values
dr_plot_predicted(analysis)
```

![](man/figures/README-unnamed-chunk-5-1.png)<!-- -->

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


<!-- README.md is generated from README.Rmd. Please edit that file -->

# detrange

<!-- badges: start -->
<!-- badges: end -->

## Introduction

`detrange` estimates detection range from multiple stations within a
passive acoustic telemetry array. We use the definition of detection
range from Kessel et al. (2014):

> “… the relationship between detection probability and the distance
> between the receiver and tag. This can be presented graphically in the
> form of a logistic curve of detection probability, derived from the
> results of detection range testing in the field.”

Given the detection range, `detrange` also estimates the distance (wth
confidence intervals) at which a specified level of detection efficiency
is achieved. Typically, we are interested in the midpoint of the
detection range (i.e. distance at which 50% of pings are detected).

Under the hood, `detrange` uses a Bayesian mixed-effects logistic linear
regression model. Station is treated as a random effect (slope and
intercept) and Distance is the sole covariate.

## Demonstration

### Data

`detrange` expects data typical of detection range testing. These data
must include columns:

-   `Station` (factor)  
-   `Distance` (numeric)  
-   `Detects` (integer)  
-   `Pings` (integer)

`Pings` is the expected number of detections. An example dataset
`range_test` is included for reference.

``` r
library(detrange)
#> Loading required package: mbr
#> Registered S3 method overwritten by 'mbr':
#>   method         from
#>   pars.character term
#> Loading required package: jmbr

### view example dataset
data <- range_test
data
#> # A tibble: 38 × 4
#>    Station  Distance Detects Pings
#>    <fct>       <dbl>   <int> <int>
#>  1 Station1       48      98   104
#>  2 Station1      146      72   138
#>  3 Station1      209      28   178
#>  4 Station1      332       0    55
#>  5 Station1      408       1   119
#>  6 Station1      511       0   154
#>  7 Station1      636       0    85
#>  8 Station2       10      71    71
#>  9 Station2      104      39    52
#> 10 Station2      226      28   142
#> # … with 28 more rows
```

### Analysis

To estimate detection range, use `dr_analyse()`. The `priors` argument
allows the user to change the default priors (in JAGS language),
`de_target` specifies the desired detection efficiency to estimate
distance at and `nthin` can be adjusted to improve model convergence.
Note a single prior can be changed and the default priors will remain
for the rest.

``` r
### set target DE to 50%
de_target <- 0.5
### replace default prior for bIntercept
prior_bIntercept <- list(bIntercept = "dnorm(10, 5^-2)") 

analysis <- dr_analyse(data, de_target = de_target, priors = prior_bIntercept, nthin = 1L)
#> Registered S3 method overwritten by 'rjags':
#>   method               from 
#>   as.mcmc.list.mcarray mcmcr
#> # A tibble: 1 × 8
#>       n     K nchains niters nthin   ess  rhat converged
#>   <int> <int>   <int>  <int> <int> <int> <dbl> <lgl>    
#> 1    38     4       3   1000     1    18  2.70 FALSE
```

The output of `dr_analyse()` is an object of class `mbr`. It can be
manipulated using any functions within the [mbr
package](https://github.com/poissonconsulting/mbr). For convenience,
`detrange` provides some functions to summarise/visualise the analysis.

``` r
### plot predicted values
dr_plot_predicted(analysis, de_target = de_target)
```

![](man/figures/README-unnamed-chunk-3-1.png)<!-- -->

``` r
### get midpoint estimates
dr_analysis_midpoint(analysis)
#> # A tibble: 6 × 5
#>   Station  estimate lower upper svalue
#>   <fct>       <dbl> <dbl> <dbl>  <dbl>
#> 1 Station1     149.  139.  157.   11.6
#> 2 Station2     167.  151.  182.   11.6
#> 3 Station3     470.  437.  511.   11.6
#> 4 Station4     316.  297.  336.   11.6
#> 5 Station5     286.  270.  303.   11.6
#> 6 Station6     132.  124.  140.   11.6
```

``` r
### coefficient table
dr_analysis_coef(analysis)
#> # A tibble: 4 × 5
#>   term              estimate   lower  upper svalue
#>   <term>               <dbl>   <dbl>  <dbl>  <dbl>
#> 1 bIntercept            3.68   2.60    4.61   11.6
#> 2 bMidpoint           230.   146.    348.     11.6
#> 3 sInterceptStation     1.07   0.513   2.30   11.6
#> 4 sMidpointStation    129.    79.9   217.     11.6
```

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

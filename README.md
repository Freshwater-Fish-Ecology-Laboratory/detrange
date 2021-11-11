
<!-- README.md is generated from README.Rmd. Please edit that file -->

# detrange

## Introduction

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

Under the hood, `detrange` uses a Bayesian mixed-effects logistic linear
regression model implemented in the JAGS language. Station is treated as
a random effect (slope and intercept) and Distance is the sole
covariate.

## Demonstration

### Data

`detrange` expects data typical of detection range testing. Mandatory
columns include:

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
analysis <- dr_analyse(data, de_target = 0.5, nthin = 1L)
#> Registered S3 method overwritten by 'rjags':
#>   method               from 
#>   as.mcmc.list.mcarray mcmcr
#> # A tibble: 1 × 8
#>       n     K nchains niters nthin   ess  rhat converged
#>   <int> <int>   <int>  <int> <int> <int> <dbl> <lgl>    
#> 1    38     4       3   1000     1    15  1.77 FALSE
```

The output of `dr_analyse()` is an object of class `mbr`. It can be
manipulated using any functions within the [mbr
package](https://github.com/poissonconsulting/mbr). For convenience,
`detrange` provides some functions to summarise/visualise the analysis.

``` r
### plot predicted values
# dr_plot_predicted(analysis, de_target = de_target)
```

``` r
### get midpoint estimates
# dr_analysis_midpoint(analysis)
```

``` r
### coefficient table
# dr_analysis_coef(analysis)
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

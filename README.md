
<!-- README.md is generated from README.Rmd. Please edit that file -->

# censlm

<!-- badges: start -->
<!-- badges: end -->

The goal of censlm is to simplify fitting censored linear models and
using them to draw plausible imputed values for censored observations.

## Installation

You can install the development version of censlm like so:

``` r
remotes::install_github("mikmart/censlm")
```

## Example

Fit a censored linear model to left-censored data with `clm()`, then
draw random values for censored observations from the fitted
distribution with `imputed()`:

``` r
library(censlm)
#> Loading required package: survival
set.seed(42)

# Simulate left-censored log-normal CRP observations
crp <- rlnorm(10000, 1.355, 1.450)
lloq <- 3
obs <- replace(crp, crp < lloq, lloq)
crpdf <- data.frame(crp, lloq, obs)

# Fit censored linear model and extract (random) imputations
fit <- clm(log(obs) ~ 1, left = log(lloq))
imp <- exp(imputed(fit))

summary(fit)
#> 
#> Call:
#> survreg(formula = Surv(log(obs), log(obs) > log(lloq), type = "left") ~ 
#>     1, dist = "gaussian")
#>              Value Std. Error    z      p
#> (Intercept) 1.3421     0.0168 79.8 <2e-16
#> Log(scale)  0.3749     0.0103 36.3 <2e-16
#> 
#> Scale= 1.45 
#> 
#> Gaussian distribution
#> Loglik(model)= -13460.2   Loglik(intercept only)= -13460.2
#> Number of Newton-Raphson Iterations: 4 
#> n= 10000
summary(cbind(crpdf, imp))
#>       crp                lloq        obs                imp           
#>  Min.   :   0.011   Min.   :3   Min.   :   3.000   Min.   :   0.0056  
#>  1st Qu.:   1.418   1st Qu.:3   1st Qu.:   3.000   1st Qu.:   1.4200  
#>  Median :   3.842   Median :3   Median :   3.842   Median :   3.8418  
#>  Mean   :  11.158   Mean   :3   Mean   :  11.883   Mean   :  11.1576  
#>  3rd Qu.:  10.139   3rd Qu.:3   3rd Qu.:  10.139   3rd Qu.:  10.1394  
#>  Max.   :2060.559   Max.   :3   Max.   :2060.559   Max.   :2060.5585
```

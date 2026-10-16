# Summary method for 'srocsa' objects

This function summarizes the results: the main results (see
[`print.srocsa`](reference/print.srocsa.md)) and the estimates of all
the parameters (`par.all`) of the fitted models at each time point and
each marginal selection probability \\p\\. All the elements of the
fitted models are kept in `blocks` of the returned object.

## Usage

``` r
# S3 method for class 'srocsa'
summary(object, digits = 3, ...)
```

## Arguments

- object:

  A fitted object returned by the function `srocsa.t`, `tsroc`, or
  `tsrocsa.lrt`.

- digits:

  The digits of the results

- ...:

  Other arguments in function
  [`summary`](https://rdrr.io/r/base/summary.html)

## Value

A list that consists of summaries of a srocsa object: call, type of the
model, table of SAUC estimates (`sauc`), table of parameter estimates
and SE (`coef`), and the fitted models at each time point and each \\p\\
(`blocks`)

## See also

[`srocsa.t`](reference/srocsa.t.md),
[`hattori.tsroc`](reference/hattori.tsroc.md),
[`tsrocsa.lrt`](reference/tsrocsa.lrt.md),
[`print.srocsa`](reference/print.srocsa.md),
[`print.summary.srocsa`](reference/print.summary.srocsa.md)

## Examples

``` r
## load data
data(IVD)

fit1 <- srocsa.t(TP = TP, FN = FN, TN = TN, FP = FP, data = IVD, sa.p = c(1, 0.8, 0.6))
summary(fit1)
#> Input:
#> srocsa.t(TP = TP, FN = FN, TN = TN, FP = FP, data = IVD, sa.p = c(1, 
#>     0.8, 0.6))
#> 
#> ==================================================
#> Model optimization
#> 
#> Number of studies : 33 
#> Optimizer         : 1 1 1 
#> 
#> * 1 indicates converged
#> ==================================================
#> 
#> SAUC Estimates
#> -------------------------------------------
#> Marginal p    SAUC      SE   CI.low   CI.up
#> -------------------------------------------
#> p = 1        0.874   0.029    0.806   0.920
#> p = 0.8      0.871   0.030    0.800   0.919
#> p = 0.6      0.822   0.041    0.727   0.889
#> 
#> ==================================================
#> 
#> Parameter Estimates (SE)
#> -------------------------------------------------------------------------------------------------------------------------
#> Marginal p           mu_se           mu_sp          tau_se          tau_sp              rho            beta         alpha
#> -------------------------------------------------------------------------------------------------------------------------
#> p = 1        1.484 (0.177)   1.824 (0.154)   0.597 (0.175)   0.826 (0.117)   -0.424 (0.236)               -             -
#> p = 0.8      1.472 (0.177)   1.818 (0.154)   0.607 (0.179)   0.828 (0.118)   -0.404 (0.241)   5.000 (5.396)    -7.943 (-)
#> p = 0.6      1.234 (0.150)   1.681 (0.153)   0.618 (0.202)   0.850 (0.127)   -0.275 (0.270)   5.000 (4.126)   -10.451 (-)
#> 
#> ==================================================
#> All elements of the fitted models
#> ==================================================
#> 
#> --------------------------------------------------
#> p = 1
#> --------------------------------------------------
#>    mu1    mu2 tau1^2 tau2^2  tau12   c1^2   c2^2 
#>  1.484  1.824  0.357  0.683 -0.209  0.100  0.900 
#>   beta  alpha   sauc   sens   spec 
#>     NA     NA  0.874  0.815  0.861 
#> 
#> --------------------------------------------------
#> p = 0.8
#> --------------------------------------------------
#>    mu1    mu2 tau1^2 tau2^2  tau12   c1^2   c2^2 
#>  1.472  1.818  0.368  0.686 -0.203  0.673  0.327 
#>   beta  alpha   sauc   sens   spec 
#>  5.000 -7.943  0.871  0.813  0.860 
#> 
#> --------------------------------------------------
#> p = 0.6
#> --------------------------------------------------
#>     mu1     mu2  tau1^2  tau2^2   tau12    c1^2 
#>   1.234   1.681   0.382   0.723  -0.145   0.623 
#>    c2^2    beta   alpha    sauc    sens    spec 
#>   0.377   5.000 -10.451   0.822   0.775   0.843 
#> 

## tables of the estimates
res <- summary(fit1)
#> Input:
#> srocsa.t(TP = TP, FN = FN, TN = TN, FP = FP, data = IVD, sa.p = c(1, 
#>     0.8, 0.6))
#> 
#> ==================================================
#> Model optimization
#> 
#> Number of studies : 33 
#> Optimizer         : 1 1 1 
#> 
#> * 1 indicates converged
#> ==================================================
#> 
#> SAUC Estimates
#> -------------------------------------------
#> Marginal p    SAUC      SE   CI.low   CI.up
#> -------------------------------------------
#> p = 1        0.874   0.029    0.806   0.920
#> p = 0.8      0.871   0.030    0.800   0.919
#> p = 0.6      0.822   0.041    0.727   0.889
#> 
#> ==================================================
#> 
#> Parameter Estimates (SE)
#> -------------------------------------------------------------------------------------------------------------------------
#> Marginal p           mu_se           mu_sp          tau_se          tau_sp              rho            beta         alpha
#> -------------------------------------------------------------------------------------------------------------------------
#> p = 1        1.484 (0.177)   1.824 (0.154)   0.597 (0.175)   0.826 (0.117)   -0.424 (0.236)               -             -
#> p = 0.8      1.472 (0.177)   1.818 (0.154)   0.607 (0.179)   0.828 (0.118)   -0.404 (0.241)   5.000 (5.396)    -7.943 (-)
#> p = 0.6      1.234 (0.150)   1.681 (0.153)   0.618 (0.202)   0.850 (0.127)   -0.275 (0.270)   5.000 (4.126)   -10.451 (-)
#> 
#> ==================================================
#> All elements of the fitted models
#> ==================================================
#> 
#> --------------------------------------------------
#> p = 1
#> --------------------------------------------------
#>    mu1    mu2 tau1^2 tau2^2  tau12   c1^2   c2^2 
#>  1.484  1.824  0.357  0.683 -0.209  0.100  0.900 
#>   beta  alpha   sauc   sens   spec 
#>     NA     NA  0.874  0.815  0.861 
#> 
#> --------------------------------------------------
#> p = 0.8
#> --------------------------------------------------
#>    mu1    mu2 tau1^2 tau2^2  tau12   c1^2   c2^2 
#>  1.472  1.818  0.368  0.686 -0.203  0.673  0.327 
#>   beta  alpha   sauc   sens   spec 
#>  5.000 -7.943  0.871  0.813  0.860 
#> 
#> --------------------------------------------------
#> p = 0.6
#> --------------------------------------------------
#>     mu1     mu2  tau1^2  tau2^2   tau12    c1^2 
#>   1.234   1.681   0.382   0.723  -0.145   0.623 
#>    c2^2    beta   alpha    sauc    sens    spec 
#>   0.377   5.000 -10.451   0.822   0.775   0.843 
#> 
res$sauc
#>     p conv      sauc    sauc.se   sauc.lb   sauc.ub
#> 1 1.0    1 0.8735863 0.02875132 0.8057723 0.9200719
#> 2 0.8    1 0.8707545 0.02996087 0.7999308 0.9190442
#> 3 0.6    1 0.8218932 0.04115706 0.7267450 0.8889721
res$coef
#>     p      mu1    mu1.se      mu2    mu2.se      tau1   tau1.se      tau2
#> 1 1.0 1.483992 0.1774775 1.823652 0.1538733 0.5974405 0.1753900 0.8261892
#> 2 0.8 1.472137 0.1766591 1.817753 0.1539493 0.6069136 0.1793773 0.8284942
#> 3 0.6 1.234145 0.1502265 1.680930 0.1529153 0.6182781 0.2015533 0.8500685
#>     tau2.se        rho    rho.se beta  beta.se      alpha alpha.se
#> 1 0.1167857 -0.4244259 0.2363536   NA       NA         NA       NA
#> 2 0.1177810 -0.4038358 0.2410633    5 5.395541  -7.942993       NA
#> 3 0.1274834 -0.2750564 0.2703518    5 4.125752 -10.451160       NA
```

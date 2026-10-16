# Print method for 'srocsa' objects

This function prints the main results: convergence of the optimizer,
SAUC estimates, and parameter estimates with standard errors (SE) for
each marginal selection probability \\p\\. For the time-dependent
results, the results are printed at each time point.

## Usage

``` r
# S3 method for class 'srocsa'
print(x, digits = 3, ...)
```

## Arguments

- x:

  A fitted object returned by the function `srocsa.t`, `tsroc`, or
  `tsrocsa.lrt`.

- digits:

  The digits of the results

- ...:

  Other arguments in function
  [`print.default`](https://rdrr.io/r/base/print.default.html)

## Value

Print the main results of a srocsa object

## Details

- Optimizer:

  1 indicates that `nlminb` converged (`convergence = 0`).

- SAUC:

  The SE is calculated by the delta method. The confidence interval is
  calculated on the logit scale, so it is not symmetric around the SAUC.

- tau_se, tau_sp:

  Between-study standard deviations (not variances).

- beta, alpha:

  "-" indicates not applicable (\\p = 1\\, or the model without
  selection). The SE of alpha is not available.

- Results from `tsroc`:

  Shown as \\p = 1\\, because `tsroc` fits the model without selection.

## See also

[`srocsa.t`](reference/srocsa.t.md),
[`hattori.tsroc`](reference/hattori.tsroc.md),
[`tsrocsa.lrt`](reference/tsrocsa.lrt.md),
[`summary.srocsa`](reference/summary.srocsa.md),
[`plot.srocsa`](reference/plot.srocsa.md)

## Examples

``` r
## load data
data(IVD)

## print the results
fit1 <- srocsa.t(TP = TP, FN = FN, TN = TN, FP = FP, data = IVD, sa.p = c(1, 0.8, 0.6))
print(fit1)
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

fit2 <- srocsa.t(TP = TP, FN = FN, TN = TN, FP = FP, data = IVD, sa.p = c(1, 0.8, 0.6), c11 = 0.5)
print(fit2, digits = 4)
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
#> ----------------------------------------------
#> Marginal p     SAUC       SE   CI.low    CI.up
#> ----------------------------------------------
#> p = 1        0.8736   0.0288   0.8058   0.9201
#> p = 0.8      0.8694   0.0303   0.7978   0.9182
#> p = 0.6      0.8205   0.0087   0.8028   0.8369
#> 
#> ==================================================
#> 
#> Parameter Estimates (SE)
#> --------------------------------------------------------------------------------------------------------------------------------------
#> Marginal p             mu_se             mu_sp            tau_se            tau_sp                rho              beta          alpha
#> --------------------------------------------------------------------------------------------------------------------------------------
#> p = 1        1.4840 (0.1775)   1.8237 (0.1539)   0.5974 (0.1754)   0.8262 (0.1168)   -0.4244 (0.2364)                 -              -
#> p = 0.8      1.4687 (0.1765)   1.8109 (0.1546)   0.6029 (0.1785)   0.8321 (0.1191)   -0.4000 (0.2435)   5.0000 (6.8088)    -9.4733 (-)
#> p = 0.6      1.2565 (0.0765)   1.6280 (0.0834)   0.6025 (0.1907)   0.8698 (0.1273)   -0.2637 (0.2341)       5.0000 (NA)   -11.4867 (-)
#> 
```

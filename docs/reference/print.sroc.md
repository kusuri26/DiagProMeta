# Print method for 'sroc' objects

This function prints the main results of
[`reitsma.sroc`](reference/reitsma.sroc.md) (SROC curve) and
[`hattori.tsroc`](reference/hattori.tsroc.md) (time-dependent SROC
curve; one row for each time point), without considering publication
bias: the number of studies, convergence of the optimizer, the SAUC, the
summary sensitivity and specificity with their confidence intervals, and
the estimates of \\(\mu_1, \mu_2, \tau_1, \tau_2, \rho)\\.

## Usage

``` r
# S3 method for class 'sroc'
print(x, digits = 3, ...)
```

## Arguments

- x:

  A fitted object returned by the function
  [`reitsma.sroc`](reference/reitsma.sroc.md) or
  [`hattori.tsroc`](reference/hattori.tsroc.md).

- digits:

  The number of decimal places of the results.

- ...:

  Other arguments in function
  [`print.default`](https://rdrr.io/r/base/print.default.html).

## Value

`x`, invisibly. Called for the side effect of printing.

## Details

- Conv:

  `"yes"` indicates that [`nlminb`](https://rdrr.io/r/stats/nlminb.html)
  converged (`convergence = 0`).

- SAUC:

  The confidence interval is `sauc.ci` of the fitted object (calculated
  on the logit scale; see [`sauc`](reference/sauc.md)).

- Sens, Spec:

  \\\mathrm{plogis}(\mu_1)\\ and \\\mathrm{plogis}(\mu_2)\\; the
  confidence intervals are the Wald intervals of \\\mu_1\\ and
  \\\mu_2\\, back-transformed.

- tau1, tau2, rho:

  Between-study standard deviations (not variances) and correlation of
  the logit-transformed sensitivity and specificity.

See [`summary.sroc`](reference/summary.sroc.md) for the standard errors
and confidence intervals of all the parameters.

## See also

[`reitsma.sroc`](reference/reitsma.sroc.md),
[`hattori.tsroc`](reference/hattori.tsroc.md),
[`summary.sroc`](reference/summary.sroc.md),
[`plot.sroc`](reference/plot.sroc.md)

## Examples

``` r
## load data
data(IVD)

fit <- reitsma.sroc(TP = TP, FN = FN, FP = FP, TN = TN, data = IVD)
fit
#> SROC curve: bivariate random-effects model (Reitsma et al., 2005)
#> Publication bias is not considered
#> 
#>   K Conv  SAUC         95% CI  Sens         95% CI  Spec         95% CI
#>  33  yes 0.874 [0.806, 0.920] 0.815 [0.757, 0.862] 0.861 [0.821, 0.893]
#> 
#> Estimates (tau1, tau2: between-study SDs; rho: correlation):
#>    mu1   mu2  tau1  tau2    rho
#>  1.484 1.824 0.597 0.826 -0.424
print(fit, digits = 4)
#> SROC curve: bivariate random-effects model (Reitsma et al., 2005)
#> Publication bias is not considered
#> 
#>   K Conv   SAUC           95% CI   Sens           95% CI   Spec
#>  33  yes 0.8736 [0.8058, 0.9201] 0.8152 [0.7570, 0.8620] 0.8610
#>            95% CI
#>  [0.8208, 0.8933]
#> 
#> Estimates (tau1, tau2: between-study SDs; rho: correlation):
#>     mu1    mu2   tau1   tau2     rho
#>  1.4840 1.8236 0.5974 0.8262 -0.4244
```

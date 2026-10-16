# SAUC and its confidence interval

This function calculates the area under the SROC curve (SAUC) of the
bivariate random-effects model, and its confidence interval when the
variance-covariance matrix of the estimates is given.

## Usage

``` r
sauc(mu1, mu2, tau1, tau2, rho, var.matrix = NULL, ci.level)
```

## Arguments

- mu1:

  The mean of the logit-transformed sensitivity.

- mu2:

  The mean of the logit-transformed specificity.

- tau1:

  The between-study standard deviation of the logit-transformed
  sensitivity.

- tau2:

  The between-study standard deviation of the logit-transformed
  specificity.

- rho:

  The between-study correlation of the logit-transformed sensitivity and
  specificity.

- var.matrix:

  The 5 x 5 variance-covariance matrix of the estimates of
  `(mu1, mu2, tau1, tau2, rho)` in this order, such as `var.ml` in the
  output of [`reitsma.sroc`](reference/reitsma.sroc.md). If
  `var.matrix = NULL` (default), the confidence interval is not
  calculated.

- ci.level:

  The confidence level of the confidence interval, within (0, 1). It is
  required when `var.matrix` is given.

## Value

A named numeric vector of `sauc`, `sauc.lb`, and `sauc.ub` (SAUC and the
lower and upper bounds of its confidence interval). `sauc.lb` and
`sauc.ub` are `NA` if `var.matrix = NULL`, and `sauc` is `NA` if the
integration failed.

## Details

- SROC curve:

  The SROC curve is \\\mathrm{Se} = \mathrm{logit}^{-1}(\mu_1 - (\rho
  \tau_1 / \tau_2) (\mathrm{logit}(x) + \mu_2))\\, where \\x\\ is the
  false positive rate (1 - specificity). SAUC is its integral over \\x
  \in (0, 1)\\ by [`integrate`](https://rdrr.io/r/stats/integrate.html).

- Confidence interval:

  The standard error of SAUC is calculated by the delta method. The
  confidence interval is calculated on the logit scale and
  back-transformed, so it is not symmetric around SAUC.

## See also

[`reitsma.sroc`](reference/reitsma.sroc.md),
[`srocsa.t`](reference/srocsa.t.md)

## Examples

``` r
## SAUC without confidence interval
sauc(mu1 = 1.5, mu2 = 2, tau1 = 0.8, tau2 = 0.9, rho = -0.3)
#>      sauc   sauc.lb   sauc.ub 
#> 0.8752776        NA        NA 

## SAUC with confidence interval from the fitted model
data(IVD)
fit <- reitsma.sroc(TP = TP, FN = FN, FP = FP, TN = TN, data = IVD)
est <- fit$par
sauc(mu1 = est[1], mu2 = est[2], tau1 = est[3], tau2 = est[4], rho = est[5],
     var.matrix = fit$var.ml, ci.level = 0.95)
#>      sauc   sauc.lb   sauc.ub 
#> 0.8735863 0.8057723 0.9200719 
```

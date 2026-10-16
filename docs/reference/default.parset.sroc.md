# Default settings for the estimation

Default settings for the estimation of the SROC and time-dependent SROC
models. The elements can be modified through the `parset` argument of
the fitting functions; the user-specified list updates the default list
by [`modifyList`](https://rdrr.io/r/utils/modifyList.html).

- `default.parset.sroc()`: used by
  [`reitsma.sroc`](reference/reitsma.sroc.md) and
  [`srocsa.t`](reference/srocsa.t.md) (bivariate model of the
  logit-transformed sensitivity and specificity).

- `default.parset.tsroc.pb()`: used by
  [`hattori.tsroc`](reference/hattori.tsroc.md) and
  [`tsrocsa.lrt`](reference/tsrocsa.lrt.md) (trivariate model of the
  logit-transformed sensitivity, specificity, and lnHR).

## Usage

``` r
default.parset.sroc()

default.parset.tsroc.pb()
```

## Value

A list of the default settings with the following elements:

- `inital.values`:

  Initial values of the parameters. In `default.parset.sroc()`, a vector
  of length 5: `c(mu1, mu2, tau1, tau2, rho)`
  `= c(0.1, 0.1, 0.1, 0.1, -0.1)`. In `default.parset.tsroc.pb()`, a
  vector of length 9:
  `c(mu1, mu2, mu3, tau1, tau2, tau3, rho1, rho2, rho3)`
  `= c(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, -0.1, -0.1, -0.1)`, where `rho1`,
  `rho2`, and `rho3` are the correlations of (1, 2), (2, 3), and (1, 3)
  (index 1: logit-sensitivity, 2: logit-specificity, 3: lnHR). The
  values are used by the bivariate model
  ([`reitsma.sroc`](reference/reitsma.sroc.md), and
  [`tsrocsa.lrt`](reference/tsrocsa.lrt.md) with \\p = 1\\) only when
  the length is 5; otherwise, the initial values are the estimates by
  [`mixmeta`](https://rdrr.io/pkg/mixmeta/man/mixmeta.html). They are
  not used by [`srocsa.t`](reference/srocsa.t.md).

- `mu.bound`:

  The means \\\mu_k\\ are searched within `[-mu.bound, mu.bound]`. The
  default is 5.

- `tau.bound`:

  The upper bound of the between-study standard deviations \\\tau_k\\.
  The default is 5.

- `beta.interval`:

  The lower and upper bounds of \\\beta\\ in the selection function. The
  default is `c(0, 5)`.

- `alpha.bound`:

  The root of \\\alpha\\ in the selection function is searched starting
  from `[-alpha.bound, alpha.bound]`, which is extended if necessary
  (see [`uniroot`](https://rdrr.io/r/stats/uniroot.html)). The default
  is 5.

- `eps`:

  The lower bound of the between-study standard deviations \\\tau_1\\
  and \\\tau_2\\. The default is `1e-5`.

## See also

[`reitsma.sroc`](reference/reitsma.sroc.md),
[`srocsa.t`](reference/srocsa.t.md),
[`hattori.tsroc`](reference/hattori.tsroc.md),
[`tsrocsa.lrt`](reference/tsrocsa.lrt.md)

## Examples

``` r
default.parset.sroc()
#> $inital.values
#> [1]  0.1  0.1  0.1  0.1 -0.1
#> 
#> $mu.bound
#> [1] 5
#> 
#> $tau.bound
#> [1] 5
#> 
#> $beta.interval
#> [1] 0 5
#> 
#> $alpha.bound
#> [1] 5
#> 
#> $eps
#> [1] 1e-05
#> 
default.parset.tsroc.pb()
#> $inital.values
#> [1]  0.1  0.1  0.1  0.1  0.1  0.1 -0.1 -0.1 -0.1
#> 
#> $mu.bound
#> [1] 5
#> 
#> $tau.bound
#> [1] 5
#> 
#> $beta.interval
#> [1] 0 5
#> 
#> $alpha.bound
#> [1] 5
#> 
#> $eps
#> [1] 1e-05
#> 

## change the bounds of the means
str(utils::modifyList(default.parset.sroc(), list(mu.bound = 10)))
#> List of 6
#>  $ inital.values: num [1:5] 0.1 0.1 0.1 0.1 -0.1
#>  $ mu.bound     : num 10
#>  $ tau.bound    : num 5
#>  $ beta.interval: num [1:2] 0 5
#>  $ alpha.bound  : num 5
#>  $ eps          : num 1e-05
```

# Print the summary of 'sroc' objects

Print the summary of the results of
[`reitsma.sroc`](reference/reitsma.sroc.md) or
[`hattori.tsroc`](reference/hattori.tsroc.md); see
[`summary.sroc`](reference/summary.sroc.md). For
[`hattori.tsroc`](reference/hattori.tsroc.md), the results are printed
for each time point.

## Usage

``` r
# S3 method for class 'summary.sroc'
print(x, digits = 3, ...)
```

## Arguments

- x:

  An object returned by the function
  [`summary.sroc`](reference/summary.sroc.md).

- digits:

  The number of decimal places of the results.

- ...:

  Other arguments in function
  [`print.default`](https://rdrr.io/r/base/print.default.html).

## Value

`x`, invisibly. Called for the side effect of printing.

## See also

[`summary.sroc`](reference/summary.sroc.md)

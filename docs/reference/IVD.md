# Meta-analysis of diagnostic studies: IVD data

A dataset from a meta-analysis of diagnostic studies evaluating methods
for diagnosing intravascular device-related bloodstream infection
(IVD-BSI). The dataset contains study-level 2 x 2 diagnostic accuracy
data together with information on diagnostic type and cutoff values.

## Usage

``` r
IVD
```

## Format

A data frame with 33 rows (studies) and 8 variables:

- study:

  Study identifier.

- TP:

  Number of true positive cases.

- FN:

  Number of false negative cases.

- FP:

  Number of false positive cases.

- TN:

  Number of true negative cases.

- cutoff.grp:

  Cutoff-value group used in the study.

- type:

  Type of diagnostic method or test.

- cutoff:

  Diagnostic cutoff value or cutoff information.

## Source

Safdar N, Fine JP, Maki DG (2005). Meta-analysis: methods for diagnosing
intravascular device-related bloodstream infection. *Annals of Internal
Medicine*, 142(6), 451–466.
[doi:10.7326/0003-4819-142-6-200503150-00011](https://doi.org/10.7326/0003-4819-142-6-200503150-00011)

## Examples

``` r
data(IVD)
```

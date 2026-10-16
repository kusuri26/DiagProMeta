# Meta-analysis of diagnostic or prognostic studies with sensitivity analyses on the SROC Curve anf the tim-dependent SROC curve

This package implements the likelihood-based sensitivity analysis for
publication bias on the summary receiver operating characteristic (SROC)
curve and the area under the SROC curve (SAUC) in meta-analysis of
diagnostic test accuracy, see Zhou et al. (2023)
[doi:10.1002/sim.9643](https://doi.org/10.1002/sim.9643) . It also
provides the sensitivity analysis on the time-dependent SROC curve in
meta-analysis of prognostic studies, where the time-dependent
sensitivity and specificity are reconstructed from the published
survival probabilities, see Combescure et al. (2016)
[doi:10.1177/0962280212464542](https://doi.org/10.1177/0962280212464542)
.

Main functions:

- [`srocsa.t`](reference/srocsa.t.md) Sensitivity analysis for
  publication bias on the SROC curve and SAUC.

- [`tsrocsa.lrt`](reference/tsrocsa.lrt.md) Sensitivity analysis for
  publication bias on the time-dependent SROC curve and SAUC.

- [`reitsma.sroc`](reference/reitsma.sroc.md) Bivariate random-effects
  model for the SROC curve without publication bias.

- [`hattori.tsroc`](reference/hattori.tsroc.md) Time-dependent SROC
  curve without publication bias.

- [`sauc`](reference/sauc.md) SAUC and its confidence interval.

Results output functions:

- [`print.srocsa`](reference/print.srocsa.md) Print the main results
  from 'srocsa' objects.

- [`summary.srocsa`](reference/summary.srocsa.md) Summarize the results
  from 'srocsa' objects.

- [`plot.srocsa`](reference/plot.srocsa.md) Plot the SROC curves from
  'srocsa' objects.

Example data:

- [`IVD`](reference/IVD.md), [`CD64`](reference/CD64.md) Meta-analyses
  of diagnostic studies.

## See also

Useful links:

- <https://https://kusuri26.github.io/DiagProgMeta>

- Report bugs at
  <https://https://kusuri26.github.io/DiagProgMeta/issues>

## Author

**Maintainer**: Zhou Yi <zhouy@people.kobe-u.ac.jp>

Authors:

- Zhou Yi <zhouy@people.kobe-u.ac.jp>

- Ryota Kinugawa \[contributor\]

- Kota Nakaike \[contributor\]

- Yamato Hashimoto \[contributor\]

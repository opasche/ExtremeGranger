# Extreme Granger-causal graph parallelized estimate

This function estimates the causal graph (path diagram) between a set of
time series, using `doFuture` parallellization for computational
efficiency. It does the same as
[`Extreme_causality_graph()`](https://opasche.github.io/ExtremeGranger/reference/Extreme_causality_graph.md),
but potentially faster if appropriate parallelization is used.

## Usage

``` r
Extreme_causality_graph_parallel(
  w,
  max_causal_lag = 1,
  max_confounder_lag = 0,
  nu_x = 0.3,
  q_y = 0.2,
  q_z = 0.1,
  instant = FALSE,
  both_tails = TRUE,
  p_value_based = FALSE,
  p_value_cutoff = 0.05,
  strategy = c("sequential", "multisession", "multicore", "mixed"),
  n_workers = NULL
)
```

## Arguments

- w:

  A `data.frame` of all time series, which should be numeric and of the
  same length.

- max_causal_lag:

  The time delay for the effect from `x` to `y`. This is the coefficient
  'p' in Appendix A of the manuscript.

- max_confounder_lag:

  The lag from \\Z\\ to \\(X, Y)\\. If the common cause has different
  lags to \\X\\ and \\Y\\, it may cause spurious causality between \\X\\
  and \\Y\\. Ensure `max_confounder_lag` is larger than this lag.

- nu_x:

  The coefficient \\\tau_X\\ or \\k_n\\ in the manuscript, defined as
  \\k_n = \lfloor n^{\nu_x} \rfloor\\. If strong hidden confounding is
  expected, set `nu_x` to 0.4 or 0.5.

- q_y:

  The coefficient \\\tau_y = q_y \times n\\, describing the conditioning
  on \\Y_t\\. For large auto-correlation in \\Y\\, set `q_y` to 0.1 or
  less. Note that in the manuscript, \\q_y\\ is defined as `1 - q_y`.

- q_z:

  The coefficient \\\tau_z = q_z \times n\\, describing the conditioning
  on \\Z_t\\. This is irrelevant if `z` is `NULL`. For strong
  confounding effects, set `q_z` to 0.2 or 0.3. Note that in the
  manuscript, \\q_z\\ is defined as `1 - q_z`.

- instant:

  Whether instantaneous effects should be captured; defaults to `FALSE`.

- both_tails:

  Set to `TRUE` to consider both large and extremely negative values.
  For example, in GARCH models, both tails are of interest, while in VAR
  models, only large values might be relevant.

- p_value_based:

  If `FALSE`, Algorithm 1 is used for inferring the edges. If `TRUE`,
  the testing procedure with a cut-off p-value of `p_value_cutoff` is
  used for detecting the presence of an edge. These procedures typically
  output similar results, but the testing procedure is significantly
  slower.

- p_value_cutoff:

  P-value cut-off level to reject the absence of an edge in the
  estimated graph.

- strategy:

  One of `"sequential"` (default), `"multisession"`, `"multicore"`, or
  `"mixed"`.

- n_workers:

  A positive numeric scalar or a function specifying the maximum number
  of parallel futures that can be active at the same time before
  blocking. If a function, it is called without arguments when the
  future is created and its value is used to configure the workers. The
  function should return a numeric scalar. Defaults to
  [`future::availableCores()`](https://parallelly.futureverse.org/reference/availableCores.html)`-1`
  if `NULL` (default), with `"multicore"` constraint in the relevant
  case. Ignored if `strategy=="sequential"`.

## Value

A named list containing:

- G:

  A graph defined by its edges. Each row corresponds to an edge from the
  first column pointing to the second column. Use
  `graph <- graph_from_edgelist(G$G)` from the
  [igraph](https://r.igraph.org/reference/aaa-igraph-package.html)
  package to obtain the graph environment;

- weights:

  Weights corresponding to each edge, representing how close the
  coefficient \\\hat{\Gamma}\_{X\rightarrow Y \| Z}\\ is to 1. If
  \\\hat{\Gamma}\_{X\rightarrow Y \| Z} = 1\\, the weight is 1. The
  weight is 0 if \\\hat{\Gamma}\_{X\rightarrow Y \| Z} = (1 +
  \hat{\Gamma}^{baseline}\_{X\rightarrow Y \| Z}) / 2\\.

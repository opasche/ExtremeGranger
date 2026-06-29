# Extreme Granger-causal test

This function tests whether the tails/extremes of a time series `X`
cause those of a time series `Y`, given potential confounders `Z`.

## Usage

``` r
Extreme_causality_test(
  x,
  y,
  z = NULL,
  max_causal_lag = 1,
  max_confounder_lag = 0,
  nu_x = 0.3,
  q_y = 0.2,
  q_z = 0.1,
  both_tails = TRUE,
  instant = FALSE,
  p_value_computation = FALSE,
  bootstrap_repetitions = 50,
  choice_of_F = 0.5
)
```

## Arguments

- x:

  A numeric vector representing the first time series (potential cause).

- y:

  A numeric vector representing the second time series (potential
  effect).

- z:

  A `data.frame` of potential confounders. Set to `NULL` if there are no
  confounders.

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

- both_tails:

  Set to `TRUE` to consider both large and extremely negative values.
  For example, in GARCH models, both tails are of interest, while in VAR
  models, only large values might be relevant.

- instant:

  Whether instantaneous effects should be captured; defaults to `FALSE`.

- p_value_computation:

  If set to `FALSE` the faster "Algorithm 1" is used. If set to `TRUE`
  the p-value for the hypothesis \\H_0: X \text{ does not cause } Y
  \text{ in extremes given } Z\\ is computed. If `p_value < 0.05`, we
  conclude that \\X\\ causes \\Y\\ given \\Z\\.

- bootstrap_repetitions:

  The number of bootstrap repetitions for p-value computation. More
  repetitions yield more precise p-values but require longer computation
  time.

- choice_of_F:

  Choice of F in the coefficient. Leave default unless you want to
  reproduce the results from the manuscript

## Value

A named list containing:

- is_causal:

  A logical value indicating whether evidence of causality is detected;

- output:

  Either 'Evidence of causality' or 'No causality' based on Algorithm 1
  from the manuscript;

- p_value_tail:

  This is not shown if `p_value_computation==FALSE`. Rejection indicates
  evidence of causality in tail. It corresponds to the p-value for the
  hypothesis H_0: "X does not cause Y in tail given Z", based on
  bootstrapping. Often `p_value==1` which means that `CTC<baseline`;

- p_value_extreme:

  This is not shown if `p_value_computation==FALSE`. Rejection indicates
  evidence of causality in extremes. It corresponds to the p-value for
  the hypothesis H_0: \\\hat{\Gamma}\_{X\rightarrow Y \| Z} \< (1 + 3
  \cdot \hat{\Gamma}^{baseline}\_{X\rightarrow Y \| Z}) / 4\\;

- CTC:

  The coefficient \\\hat{\Gamma}\_{X\rightarrow Y \| Z}\\;

- baseline:

  The baseline coefficient \\\hat{\Gamma}^{baseline}\_{X\rightarrow Y \|
  Z}\\.

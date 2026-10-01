# EconomicScenarioGenerators.jl Release Notes

## v0.7.1

- **FinanceModels 7 support:** compat is now `FinanceModels = "6, 7"`.
- With FinanceModels 7, a curve from `YieldCurve` holds its zero rate flat from
  `t = 0` to the first gridpoint (`timestep`), at the path's initial rate, and
  beyond the last gridpoint (`endtime + timestep`) holds the forward at the
  path's final rate. With 6.x both ends continued the first and last linear pieces
  (the zero rate at `t = 0` was `2r₀ - z(2Δt)` rather than `r₀`). Values at the
  gridpoints do not change.
- With FinanceModels 7, a spline curve's zero rate is flat before its first
  knot, so a `HullWhite` model on such a curve has a constant forward, and θ
  without a forward-slope term, before that knot.
- FinanceModels 7 bootstraps only linear interpolation:
  `fit(Spline.Cubic(), quotes, Fit.Bootstrap())` throws. For `HullWhite`, fit a
  smooth curve to all quotes at once, `fit(Spline.Cubic(), quotes)`, as the
  README and documentation examples now do: a linear curve's forward jumps at
  every knot, and θ with it.

## v0.7.0

This release corrects several simulation-accuracy defects. **Generated scenarios
change relative to v0.6.x** — re-baseline any downstream valuations, hedging
metrics, or stored scenario sets:

- **`CoxIngersollRoss` diffusion was missing `√timestep`**, inflating shock
  variance by `1/timestep` for any timestep ≠ 1 (≈13× at monthly steps). The
  discretization is now partial-truncation Euler: the diffusion uses
  `√(max(r, 0))`, so paths that cross zero no longer throw a `DomainError`.
- **`HullWhite` θ is now evaluated at the gridpoint being generated** (was one
  step beyond it). Under this package's discretization and `YieldCurve`
  discounting, maximum zero-coupon repricing error drops roughly an order of
  magnitude (≈0.6bp vs ≈9bp at monthly steps on a 10y curve with σ = 1%).
- **`YieldCurve` no longer clamps zero rates to `[1e-5, 1]`.** Those bounds were
  meant for discount factors; on low/negative-rate paths the clamp silently
  floored a substantial share of curve nodes. Negative rates now flow through.
- **`Correlated` draws one joint copula sample per timestep** (previously an
  n×n sample matrix per step, using only its first column). Values are
  distributionally identical, but **seeded random streams differ from v0.6.x**
  (less randomness is consumed), so seeded scenario sets will not reproduce
  v0.6.x output. Mismatched copula dimension vs. generator count now fails
  loudly instead of silently mixing joint draws.
- **`ConstantElasticityofVariance` was removed.** It was exported but had no
  `nextvalue` implementation — any generator built on it failed at the first
  step — so it could not have been in working use.
- **`HullWhite` with a flat curve** (`Real` or `FinanceCore.Rate`) now works
  without FinanceModels loaded, via a closed-form θ.
- **Compat:** `FinanceModels = "4.9, 5, 6"` (previously capped at 4.x, which
  made this package uninstallable alongside the current ecosystem),
  `FinanceCore = "2, 3"`, `ForwardDiff = "0.10, 1"`.
- **Maintenance mode:** for single-model interest-rate generation, prefer
  `FinanceModels.ShortRate` with `simulate`/`pv_mc` (FinanceModels ≥ 6).
  `Correlated` remains unique to this package. See the README note.

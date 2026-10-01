# EconomicScenarioGenerators.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaActuary.github.io/EconomicScenarioGenerators.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaActuary.github.io/EconomicScenarioGenerators.jl/dev)
[![Build Status](https://github.com/JuliaActuary/EconomicScenarioGenerators.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaActuary/EconomicScenarioGenerators.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaActuary/EconomicScenarioGenerators.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaActuary/EconomicScenarioGenerators.jl)

> [!NOTE]
> **Frozen: 0.7.1 is the final planned release.** For interest-rate scenarios, use `FinanceModels.ShortRate.{Vasicek, CoxIngersollRoss, HullWhite}` with `FinanceModels.simulate`/`pv_mc` (FinanceModels ≥ 6), the maintained successors of this package's generators. [`Correlated`](#correlated-scenarios) (copula-correlated simulation across multiple models) and equity paths are planned for FinanceModels 7.1; this repository will then be archived. 0.7.1 supports FinanceModels 6 and 7.

Interested in developing economic scenario generators in Julia? Consider contributing to FinanceModels.jl. Open an issue, create a pull request, or discuss on the Julia Zulip's #actuary channel.

## Usage

EconomicScenarioGenerators.jl is available via the General Registry. Install and use in the normal way:
1. Add EconomicScenarioGenerators via Pkg
2. `import EconomicScenarioGenerators` or `using EconomicScenarioGenerators` in your code

## Examples

### Importing packages

First, import both `EconomicScenarioGenerators` and [`FinanceModels`](https://github.com/JuliaActuary/FinanceModels.jl):

```
using EconomicScenarioGenerators
using FinanceModels
```

## Models

### Interest Rate Models

- `Vasicek`
- `CoxIngersollRoss`
- `HullWhite`

### EquityModels

- `BlackScholesMerton`

### Interest Rate Model Examples

#### Vasicek

```julia
m = Vasicek(0.136,0.0168,0.0119,Continuous(0.01)) # a, b, σ, initial Rate
s = ScenarioGenerator(
        1,  # timestep
        30, # projection horizon
        m,  # model
    )
```

You can collect a single generated scenario like so:

```julia
rates = collect(s)
```

And the package integrates with [FinanceModels.jl](https://github.com/JuliaActuary/FinanceModels.jl):

```julia
YieldCurve(s)

```

will produce a yield curve object (if `UnicodePlots.jl` has also been imported):

```julia-repl
              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Yield Curve (FinanceModels.Yield.Spline)⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀           
              ┌────────────────────────────────────────────────────────────┐           
         0.04 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ Zero rates
              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⠀⠀⡠⠎⠉⠉⠊⠉⠑⠦⠤⠤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡠⠤⠤⠔│           
              │⠀⠀⠀⠀⢀⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠦⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⠤⠔⠒⠊⠉⠉⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⢰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠒⠦⠤⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠤⠔⠒⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⠒⠒⠒⠊⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
   Continuous │⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⡸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉│           
              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        -0.01 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              └────────────────────────────────────────────────────────────┘           
              ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀time⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀30⠀        
```

#### CoxIngersollRoss

A CIR model:

```julia
m = CoxIngersollRoss(0.136,0.0168,0.0119,Continuous(0.01))
```

#### Hull White Model using a FinanceModels.jl yield curve

Construct a yield curve and use that as the arbitrage-free forward curve within the Hull-White model. The drift θ follows the curve's instantaneous forward and its slope, so use a smooth curve, such as a cubic spline fit to all quotes at once: a linear curve's forward jumps at every knot.

```julia
using FinanceModels, EconomicScenarioGenerators
rates = [0.01, 0.01, 0.03, 0.05, 0.07, 0.16, 0.35, 0.92, 1.40, 1.74, 2.31, 2.41] ./ 100
mats = [1 / 12, 2 / 12, 3 / 12, 6 / 12, 1, 2, 3, 5, 7, 10, 20, 30]
c = FinanceModels.fit(
    FinanceModels.Spline.Cubic(),
    FinanceModels.ZCBYield.(rates, mats)
)

m = HullWhite(2.0, 0.025, c)

s = EconomicScenarioGenerators.ScenarioGenerator(
    0.01,                              # timestep
    30.0,                             # projection horizon
    m
)

```

Create 1000 yield curves from the scenario generator:

```julia
n = 1000
curves = [YieldCurve(s) for i in 1:n]
```

Plot the result:

```julia
using CairoMakie

times = 1:30

fig = Figure()
axis = Axis(fig[1,1],title="EconomicScenarioGenerators.jl Hull White Model",xlabel="time",ylabel="rate")
# plot the zero rates
for d in curves
    lines!(axis,times,rate.(zero.(d,times)),alpha=0.1,label="")
end
lines!(axis,times,rate.(zero.(c,times)),color=:black,linewidth=7)
fig
```

![image](https://github.com/JuliaActuary/EconomicScenarioGenerators.jl/assets/711879/09ef7136-30bf-44cf-865c-987d0df92a4a)

### Equity Model Examples

#### BlackScholesMerton

```julia
m = BlackScholesMerton(0.01,0.02,.15,100.)

s = ScenarioGenerator(
               1,  # timestep
               30, # projection horizon
               m,  # model
           )
```

Instantiate an array of the projection with `collect(s)`.


##### Plotted BSM Example

Plot 100 paths:

```
using Plots
projections = [collect(s) for _ in 1:100]

p = plot()

for p in projections
    plot!(0:30,p,label="",alpha=0.5)
end

p
```

![BSM Paths](https://user-images.githubusercontent.com/711879/180128072-fe08d285-0edc-4707-a89e-8d14fef23d2a.png)

## Correlated Scenarios

Combined with `using Copulas`, you can create correlated scenarios with a given copula. See `?Correlated` for the docstring on creating a correlated set of scenario generators.

### Example

Create two equity paths that are 90% correlated:

```
using EconomicScenarioGenerators, Copulas

m = BlackScholesMerton(0.01,0.02,.15,100.)
s = ScenarioGenerator(
                      1,  # timestep
                      30, # projection horizon
                      m,  # model
                  )

ss = [s,s] # these don't have to be the exact same, but do need same shape
g = ClaytonCopula(2,7) # highly dependent model
c = Correlated(ss,g)

x = collect(c) # an array of tuples

using Plots

# get the 1st/2nd value from the scenario points
plot(getindex.(x,1))
plot!(getindex.(x,2))
```

![plot_20](https://user-images.githubusercontent.com/711879/183552235-9c44f0a7-932d-4e81-9ac1-9115628d3374.svg)


## Other ESG packages

- Python
  - https://github.com/jason-ash/pyesg

# EconomicScenarioGenerators.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaActuary.github.io/EconomicScenarioGenerators.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaActuary.github.io/EconomicScenarioGenerators.jl/dev)
[![Build Status](https://github.com/JuliaActuary/EconomicScenarioGenerators.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaActuary/EconomicScenarioGenerators.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaActuary/EconomicScenarioGenerators.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaActuary/EconomicScenarioGenerators.jl)

Help wanted!

This package is very early in its development cycle. It may not work if you try to run it at this point.

Interested in developing economic scenario generators in Julia? Consider contributing to this package. Open an issue, create a pull request, or discuss on the Julia Zulip's #actuary channel.

## Usage

This package is in a pre-release stage and is not well tested and the API may change.

EconoicScenarioGenerators.jl is now available via the General Registry. Install and use in the normal way:
1. Add EconomicScenarioGenerators via Pkg
2. `import EconomicScenarioGenerators` or `using EconomicScenarioGenerators` in your code

## Examples

### Importing packages

First, import both `EconomicScenarioGenerators` and [`Yields`](https://github.com/JuliaActuary/Yields.jl):

```
using EconomicScenarioGenerators
using Yields
```


### Interest Rate Models

#### Vasicek

```julia
m = Vasicek(0.136,0.0168,0.0119,Continuous(0.01)) # a, b, σ, initial Rate
s = ScenarioGenerator(
        1,  # timestep
        30, # projection horizon
        m,  # model
    )
```

This can be iterated over, or you can collect all of the rates like:

```julia
rates = collect(s)
```

or 

```julia
for r in s
    # do something with r
end
```

And the package integrates with [Yields.jl](https://github.com/JuliaActuary/Yields.jl) if loaded:

```julia
Yields.Forward(s)

```

will produce a yield curve object:

```

               ⠀⠀⠀⠀⠀⠀⠀⠀⠀Yield Curve (Yields.BootstrappedYieldCurve)⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀           
               ┌────────────────────────────────────────────────────────────┐           
          0.02 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ Zero rates
               │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
               │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
               │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
               │⠀⠀⠀⢀⡔⠦⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
               │⠀⠀⠀⡜⠀⠀⠈⠣⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
               │⠀⠀⢸⠁⠀⠀⠀⠀⠀⠱⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠│           
   Periodic(1) │⢆⡠⠃⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠒⠁⠀│           
               │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡔⠃⠀⠀⠀⠀│           
               │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠤⢄⡠⠔⠒⠒⠋⠉⠑⠒⠢⠤⠔⠒⠒⠒⠒⠒⠒⠁⠀⠀⠀⠀⠀⠀│           
               │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⡠⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
               │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
               │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⣀⠤⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
               │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡄⠀⠀⣀⣀⡠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
             0 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠤⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
               └────────────────────────────────────────────────────────────┘           
               ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀time⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀30⠀           

```

#### CoxIngersolRoss

A CIR model:

```julia
m = CoxIngersollRoss(0.136,0.0168,0.0119,Continuous(0.01))
```

#### Hull White Model using a Yields.jl YieldCurve

Construct a yield curve and use that as the arbitrage-free forward curve within the Hull-White model.

```julia
using Yields, EconomicScenarioGenerators
rates =[0.01, 0.01, 0.03, 0.05, 0.07, 0.16, 0.35, 0.92, 1.40, 1.74, 2.31, 2.41] ./ 100
mats = [1/12, 2/12, 3/12, 6/12, 1, 2, 3, 5, 7, 10, 20, 30]
c = Yields.CMT(rates,mats)


m = HullWhite(.1,.005,c) # a, σ, curve

s = ScenarioGenerator(
        1,  # timestep
        30, # projection horizon
        m,  # model
    )
```

Create 1000 yield curves from the scenario generator:

```julia
n = 1000
curves = [Yields.Forward(s) for i in 1:n]
```julia

Plot the result:

```julia
using Plots

times = 1:30
p=plot(title="EconomicScenarioGenerators.jl Hull White Model")
for d in curves
    plot!(p,times,Yields.rate.(Yields.zero.(d,times)),alpha=0.2,label="")
end

plot!(times,Yields.rate.(Yields.zero.(c,times)),line=(:black, 5), label="Given Yield Curve")
p
    
```

![image](https://user-images.githubusercontent.com/711879/171550813-e3a57557-c7f8-4080-a6c7-88691d5c1be6.png)

### Equity Models

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

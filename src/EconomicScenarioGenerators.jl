"""
    EconomicScenarioGenerators

Economic scenario generation: short-rate models (`Vasicek`, `CoxIngersollRoss`,
`HullWhite`), an equity model (`BlackScholesMerton`), and copula-correlated
multi-model simulation (`Correlated`).

!!! note "Maintenance mode"
    For single-model interest-rate scenario generation, prefer
    `FinanceModels.ShortRate.{Vasicek, CoxIngersollRoss, HullWhite}` together
    with `FinanceModels.simulate`/`pv_mc` (FinanceModels ≥ 6), which are the
    maintained successors of this package's generators. This package remains
    the home of `Correlated` — copula-correlated simulation across multiple
    models — which FinanceModels does not provide.
"""
module EconomicScenarioGenerators

import ForwardDiff
import FinanceCore
using Transducers
using Transducers: @next, complete, __foldl__, asfoldable, next
using Random
using Copulas
using Distributions

abstract type EconomicModel end

include("interest.jl")
include("equity.jl")

abstract type AbstractScenarioGenerator end


"""
    ScenarioGenerator(timestep::M,endtime::N,model,RNG::AbstractRNG) where {M<:Real, N<:Real}

A `ScenarioGenerator` yields the time series of the model at gridpoints `0:timestep:endtime`. It takes the parameters of the scenario generation such as `timestep` and `endtime` (the time horizon). `model` is any EconomicModel from the `EconomicScenarioGenerators` package.

A `ScenarioGenerator` is a [Transducers.jl-foldable](https://juliafolds2.github.io/Transducers.jl/stable/howto/reducibles/) collection: it can be `collect`ed or used with transducer pipelines (`sg |> Map(f) |> collect`). It does not implement Julia's `iterate` protocol, so `for x in sg` is not supported.

# Examples

```julia
using EconomicScenarioGenerators, FinanceModels

m = Vasicek(0.136,0.0168,0.0119,Continuous(0.01)) # a, b, σ, initial Rate
s = ScenarioGenerator(
        1,  # timestep
        30, # projection horizon
        m,  # model
    )
```

"""
struct ScenarioGenerator{M<:Real,N<:Real,T,R<:AbstractRNG} <: AbstractScenarioGenerator
    timestep::M
    endtime::N
    model::T
    RNG::R

    function ScenarioGenerator(timestep::M, endtime::N, model::T, RNG::R=Random.GLOBAL_RNG) where {M<:Real,N<:Real,T<:EconomicModel,R<:AbstractRNG}
        new{M,N,T,R}(timestep, endtime, model, RNG)
    end
end

@inline function Transducers.__foldl__(rf, val, sg::ScenarioGenerator{M,N,T,R}) where {M,N,T,R}
    Δt = sg.timestep
    prior = __initial_value(sg)
    for t in 0:Δt:sg.endtime
        if iszero(t)
            val = @next(rf, val, prior)
        else
            variate = rand(sg.RNG) # a quantile
            prior = nextvalue(sg.model, prior, t, Δt, variate)
            val = @next(rf, val, prior)
        end
    end
    return complete(rf, val)
end

Base.collect(s::AbstractScenarioGenerator) = s |> Map(identity) |> collect

"""
    Correlated(v::Vector{ScenarioGenerator},copula,RNG::AbstractRNG)

Uses the given copula to correlate the outcomes of the underlying ScenarioGenerators. The copula returns the sampled CDF which the individual models will interpret according to their own logic (e.g. the random variate for the BlackScholesMerton model assumes a normal variate within the diffusion process).

The `time` and `timestep` of the underlying ScenarioGenerators are asserted to be the same upon construction.

Like `ScenarioGenerator`, a `Correlated` is a Transducers.jl-foldable collection (`collect`able; no `iterate` protocol). Each element is an `NTuple` holding all models' values at one timestep — `collect(c)` returns a vector over timesteps of n-tuples, **not** one time series per model.

# Examples

```julia
using EconomicScenarioGenerators, Copulas

m = BlackScholesMerton(0.01,0.02,.15,100.)
s = ScenarioGenerator(
                      1,  # timestep
                      30, # projection horizon
                      m,  # model
                  )

ss = [s,s] # these don't have to be the exact same
g = ClaytonCopula(2,7)
c = Correlated(ss,g)

# collect a vector of two correlated paths.
collect(c)
```

"""
struct Correlated{T,U,R} <: AbstractScenarioGenerator
    sg::Vector{T}
    copula::U
    RNG::R
    function Correlated(generators::Vector{T}, copula::U, RNG::R=Random.GLOBAL_RNG) where {T<:ScenarioGenerator,U,R<:AbstractRNG}
        fst = first(generators)
        @assert all(fst.timestep == g.timestep for g in generators) "All component generators must have the same `timestep`."
        @assert all(fst.endtime == g.endtime for g in generators) "All component generators must have the same `endpoint`."
        new{T,U,R}(generators, copula, RNG)
    end
end
Base.Broadcast.broadcastable(x::T) where {T<:Correlated} = Ref(x)


@inline function Transducers.__foldl__(rf, val, sgc::Correlated)
    n = length(sgc.sg)
    Δt = first(sgc.sg).timestep
    prior = [__initial_value(sg) for sg in sgc.sg]
    for t in 0:Δt:first(sgc.sg).endtime
        if iszero(t)
            val = @next(rf, val, tuple(prior...))
        else
            # one joint sample (length-n vector of uniforms) per timestep; the
            # previous `rand(RNG, copula, n)` drew n full samples (an n×n
            # matrix) and used only the first column
            variates = rand(sgc.RNG, sgc.copula) # CDF
            map!(prior, 1:n) do i
                nextvalue(sgc.sg[i].model, prior[i], t, Δt, variates[i])
            end
            val = @next(rf, val, tuple(prior...))
        end
    end
    return complete(rf, val)
end

__initial_value(sg::ScenarioGenerator) = __initial_value(sg.model, sg.timestep)
__initial_value(m, timestep) = m.initial

YieldCurve() = error("Must have FinanceModels imported and call this function on a ScenarioGenerator.")

export Vasicek, CoxIngersollRoss, HullWhite,
    BlackScholesMerton,
    ScenarioGenerator, Correlated, YieldCurve

end

module EconomicScenarioGenerators

import ForwardDiff
import FinanceModels
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
    ScenarioGenerator(timestep::N,endtime::N,model,RNG::AbstractRNG) where {N<:Real}

A `ScenarioGenerator` is an iterator which yields the time series of the model. It takes the parameters of the scenario generation such as `timestep` and `endtime` (the time horizon). `model` is any EconomicModel from the `EconomicScenarioGenerators` package.

A `ScenarioGenerator` can be `iterate`d or `collect`ed. 

# Examples

```julia
m = Vasicek(0.136,0.0168,0.0119,Continuous(0.01)) # a, b, σ, initial Rate
s = ScenarioGenerator(
        1,  # timestep
        30, # projection horizon
        m,  # model
    )
```

"""
struct ScenarioGenerator{N<:Real,T,R<:AbstractRNG} <: AbstractScenarioGenerator
    timestep::N
    endtime::N
    model::T
    RNG::R

    function ScenarioGenerator(timestep::N, endtime::N, model::T, RNG::R=Random.GLOBAL_RNG) where {N<:Real,T<:EconomicModel,R<:AbstractRNG}
        new{N,T,R}(timestep, endtime, model, RNG)
    end
end


function Transducers.__foldl__(rf, val, sg::ScenarioGenerator{N,T,R}) where {N,T<:BlackScholesMerton,R}
    Δt = sg.timestep
    prior = sg.model.initial
    for t in 0:Δt:sg.endtime
        if iszero(t)
            val = @next(rf, val, prior)
        else
            variate = rand(sg.RNG) # a quantile
            prior = nextvalue(sg.model, prior, t, Δt, variate)
            val = next(rf, val, prior)
            val isa Reduced && return val
            val
        end
    end
    return complete(rf, val)
end

Base.collect(s::ScenarioGenerator) = s |> Map(identity) |> collect

"""
    Correlated(v::Vector{ScenarioGenerator},copula,RNG::AbstractRNG)

An iterator which uses the given copula to correlate the outcomes of the underling ScenarioGenerators. The copula returns the sampled CDF which the individual models will interpret according to their own logic (e.g. the random variate for the BlackScholesMerton model assumes a normal variate within the diffusion process).

The `time` and `timestep` of the underlying ScenarioGenerators are asserted to be the same upon construction.

A `Correlated` can be `iterate`d or `collect`ed. It will iterate through each sub-scenario generator and yield the time series of each (as opposed to iterating through each timestep for all models at each step).

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

function Base.iterate(sgc::Correlated)
    n = 1
    sg = sgc.sg[n]
    variates = rand(sgc.RNG, sgc.copula, length(sg)) # CDF
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    scenariovalue = initial_value(sg.model, first(times))
    values = map(enumerate(times)) do (i, t)
        scenariovalue = nextvalue(sg.model, scenariovalue, t, sg.timestep, variates[n, i])
        scenariovalue
    end

    state = (
        variates=variates,
        n=2,
    )

    return (values, state)
end

function Base.iterate(sgc::Correlated, state)
    if state.n > length(sgc.sg)
        return nothing
    else
        n = state.n
        sg = sgc.sg[n]
        times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
        scenariovalue = initial_value(sg.model, first(times))
        values = map(enumerate(times)) do (i, t)
            scenariovalue = nextvalue(sg.model, scenariovalue, t, sg.timestep, state.variates[n, i])
            scenariovalue
        end
        state = (
            variates=state.variates,
            n=n + 1,
        )
        return (values, state)
    end
end

Base.length(sgc::Correlated) = length(sgc.sg)
Base.eltype(::Type{Correlated{N,T,R}}) where {N,T,R} = Vector{eltype(N)}

include("Yields.jl")
export Vasicek, CoxIngersollRoss, HullWhite,
    BlackScholesMerton, ConstantElasticityofVariance,
    ScenarioGenerator, YieldCurve, Correlated

end

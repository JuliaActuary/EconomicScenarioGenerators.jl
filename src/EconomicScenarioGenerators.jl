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


@inline function Transducers.__foldl__(rf, val, sgc::Correlated)
    n = length(sgc.sg)
    Δt = first(sgc.sg).timestep
    prior = [__initial_value(sg) for sg in sgc.sg]
    for t in 0:Δt:first(sgc.sg).endtime
        if iszero(t)
            val = @next(rf, val, tuple(prior...))
        else
            variates = rand(sgc.RNG, sgc.copula, n) # CDF
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
    BlackScholesMerton, ConstantElasticityofVariance,
    ScenarioGenerator, Correlated, YieldCurve

end

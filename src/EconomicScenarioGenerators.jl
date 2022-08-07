module EconomicScenarioGenerators

import ForwardDiff
import Yields
import IterTools
using Random
using Copulas
using Distributions
using SplitApplyCombine

abstract type EconomicModel end

function initial_value(m::T) where {T<:EconomicModel}
    m.initial
end

# This is the version that gets called by the iterator as some models depend
# on the presented timestep and for those specific methods can be written
function initial_value(m::T,timestep) where {T<:EconomicModel}
    initial_value(m)
end

include("interest.jl")
include("equity.jl")

abstract type AbstractScenarioGenerator end

struct ScenarioGenerator{N<:Real,T,R<:AbstractRNG}
    timestep::N
    endtime::N
    model::T
    RNG::R

    function ScenarioGenerator(timestep::N,endtime::N,model::T,RNG::R=Random.GLOBAL_RNG) where {N<:Real,T<:EconomicModel,R<:AbstractRNG}
        new{N,T,R}(timestep,endtime,model,RNG)
    end
end

function Base.length(sg::ScenarioGenerator{N,T,R}) where {N,T<:EconomicModel,R}
    return length(0:sg.timestep:sg.endtime)
end

function Base.iterate(sg::ScenarioGenerator{N,T,R}) where {N,T<:EconomicModel,R}
    initial = initial_value(sg.model,sg.timestep)
    state = (variate=randn(sg.RNG),time=zero(sg.timestep)::N,value=initial)
    return (state.value,state) # TODO: Implement intitial conditions for models
end

function Base.iterate(sg::ScenarioGenerator{N,T,R},state) where {N,T<:EconomicModel,R}
    if (state.time > sg.endtime) || (state.time ≈ sg.endtime)
        return nothing
    else
        new_rate = nextrate(sg.RNG,state.kind,sg.model,state.value,state.time,sg.timestep,state.variate)
        state = (
            time = state.time + sg.timestep,
            value = new_rate
        )
        return (state.value, state)
    end
end

function Base.eachindex(sg::ScenarioGenerator{N,T,R}) where {N,T<:EconomicModel,R}
    return Base.OneTo(length(sg))
end


function Base.getindex(sg::ScenarioGenerator{N,T,R},i) where {N,T<:EconomicModel,R}
    return IterTools.nth(sg,i)
end

function Base.lastindex(sg::ScenarioGenerator{N,T,R}) where {N,T<:EconomicModel,R}
    return length(sg)
end

Base.eltype(::Type{ScenarioGenerator{N,T,R}}) where {N,T,R} = __outputtype(T)

struct Correlated{T,U,R} <: AbstractScenarioGenerator
    sg::Vector{T}
    copula::U
    RNG::R
    function Correlated(generators::Vector{T},copula::U,RNG::R=Random.GLOBAL_RNG) where {T<:ScenarioGenerator,U,R<:AbstractRNG}
        @assert allequal(generators.timestep) "All component generators must have the same `timestep`."
        @assert allequal(generators.endtime) "All component generators must have the same `endpoint`."
        new{T,U,R}(generators,copula,RNG)
    end
end


function Base.iterate(sgc::Correlated) 
    n = 1
    sg = sgc.sg[n]
    variates = rand(sgc.RNG,sgc.copula,length(sg)) # CDF
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    scenariovalue = initial_value(sg.model,first(times))
    values = map(enumerate(times)) do (i,t)
        scenariovalue = nextrate(sg.model,scenariovalue,t,sg.timestep,variates[n,i])
        scenariovalue 
    end
    # initial = map(s->initial_value(s.model,s.timestep), sgc.sg)
    # [nextrate(sg.model,state.value[i],state.time,fst.timestep,state.variates[i]) for (i,sg) in enumerate(sgc.sg[1]]
    # values = [(variate=variates[i],variates = variates,time=zero(fst.timestep),value=x) for (i,x) in enumerate(initial)]
    
    state = (
        variates = variates,
        n = 2,
        )
        
    return (values,state)
end

function Base.iterate(sgc::Correlated,state)
    if state.n > length(sgc.sg)
        return nothing
    else
        n = state.n
        sg = sgc.sg[n]
        times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
        scenariovalue = initial_value(sg.model,first(times))
        values = map(enumerate(times)) do (i,t)
            scenariovalue = nextrate(sg.model,scenariovalue,t,sg.timestep,state.variates[n,i])
            scenariovalue 
        end
        state = (
            variates = state.variates,
            n = n+1,
            )
        return (values, state)
    end
end

Base.length(sgc::Correlated) = length(sgc.sg)
Base.eltype(::Type{Correlated{N,T,R}}) where {N,T,R} = Vector{eltype(N)}

include("Yields.jl")
export Vasicek, CoxIngersollRoss, HullWhite,
        BlackScholesMerton,ConstantElasticityofVariance,
        ScenarioGenerator, YieldCurve, Correlated

end

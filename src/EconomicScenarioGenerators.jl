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
    fst = first(sgc.sg)
    initial = map(s->initial_value(s.model,s.timestep), sgc.sg)
    variates = rand(sgc.RNG,sgc.copula) # CDF
    # values = [(variate=variates[i],variates = variates,time=zero(fst.timestep),value=x) for (i,x) in enumerate(initial)]
    
    state = (
        variates = variates,
        time = zero(fst.timestep),
        value = initial,        
        )
        
    return (state.value,state)
end

function Base.iterate(sgc::Correlated,state)
    fst = first(sgc.sg)
    if (state.time > fst.endtime) || (state.time ≈ fst.endtime)
        return nothing
    else
        new_vals = [nextrate(sg.model,state.value[i],state.time,fst.timestep,state.variates[i]) for (i,sg) in enumerate(sgc.sg)]

        state = (
            variates = rand!(sgc.RNG,sgc.copula,state.variates),
            time = state.time + fst.timestep,
            value = new_vals,
            )
        return (state.value, state)
    end
end

Base.length(sgc::Correlated) = length(first(sgc.sg))
Base.eltype(::Type{Correlated{N,T,R}}) where {N,T,R} = Vector{eltype(N)}

include("Yields.jl")
export Vasicek, CoxIngersollRoss, HullWhite,
        BlackScholesMerton,ConstantElasticityofVariance,
        ScenarioGenerator, YieldCurve, Correlated

end

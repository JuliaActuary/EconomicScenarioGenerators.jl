module EconomicScenarioGenerators

import ForwardDiff
import Yields
import IterTools
using Random

using LabelledArrays

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
    state = @LArray [0,initial] (:time,:rate)
    return (state.rate,state) # TODO: Implement intitial conditions for models
end

function Base.iterate(sg::ScenarioGenerator{N,T,R},state) where {N,T<:EconomicModel,R}
    if (state.time > sg.endtime) || (state.time ≈ sg.endtime)
        return nothing
    else
        new_rate = nextrate(sg.RNG,sg.model,state.rate,state.time,sg.timestep)
        state.time += sg.timestep
        state.rate = new_rate
        return (state.rate, state)
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

Base.eltype(::Type{ScenarioGenerator{N,T,R}}) where {N,T,R} = outputtype(T)


export Vasicek, CoxIngersollRoss, HullWhite,
        BlackScholesMerton,ConstantElasticityofVariance,
        ScenarioGenerator

end

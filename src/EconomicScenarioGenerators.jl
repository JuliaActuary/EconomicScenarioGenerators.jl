module EconomicScenarioGenerators

import ForwardDiff
import Yields

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

struct ScenarioGenerator{N<:Real,T}
    timestep::N
    endtime::N
    model::T
end

function Base.length(sg::ScenarioGenerator{N,T}) where {N,T<:EconomicModel}
    return length(0:sg.timestep:sg.endtime) 
end

function Base.iterate(sg::ScenarioGenerator{N,T}) where {N,T<:EconomicModel}
    initial = initial_value(sg.model,sg.timestep)
    state = @LArray [0,initial] (:time,:rate)
    return (state.rate,state) # TODO: Implement intitial conditions for models
end

function Base.iterate(sg::ScenarioGenerator{N,T},state) where {N,T<:EconomicModel}
    if state.time >= sg.endtime
        return nothing
    else
        new_rate = nextrate(sg.model,state.rate,state.time,sg.timestep)
        state.time += sg.timestep
        state.rate = new_rate
        return (state.rate, state)
    end
end

Base.eltype(::Type{ScenarioGenerator{N,T}}) where {N,T} = outputtype(T)


export Vasicek, CoxIngersollRoss, HullWhite,
        BlackScholesMerton,ConstantElasticityofVariance,
        ScenarioGenerator

end

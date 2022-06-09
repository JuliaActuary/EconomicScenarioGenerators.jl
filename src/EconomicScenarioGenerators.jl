module EconomicScenarioGenerators

import ForwardDiff

using LabelledArrays
using Requires

abstract type EconomicModel end

function initial_value(m::T) where {T<:AbstractEconomicModel}
    m.initial
end

# This is the version that gets called by the iterator as some models depend
# on the presented timestep and for those specific methods can be written
function initial_value(m::T,timestep) where {T<:AbstractEconomicModel}
    initial_value(m)
end

include("interest.jl")
include("equity.jl")

struct ScenarioGenerator{N<:Real,T}
    timestep::N
    endtime::N
    model::T
end

function Base.length(sg::ScenarioGenerator{N,T}) where {N,T<:AbstractEconomicModel}
    return length(0:sg.timestep:sg.endtime) 
end

function Base.iterate(sg::ScenarioGenerator{N,T}) where {N,T<:AbstractEconomicModel}
    initial = initial_value(sg.model,sg.timestep)
    state = @LArray [0,initial] (:time,:rate)
    return (state.rate,state) # TODO: Implement intitial conditions for models
end

function Base.iterate(sg::ScenarioGenerator{N,T},state) where {N,T<:AbstractEconomicModel}
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


function __init__()
    @require Yields="d7e99b2f-e7f3-4d9e-9f01-2338fc023ad3" include("Yields.jl")
end

export Vasicek, CoxIngersollRoss, HullWhite,
        BlackScholesMerton,ConstantElasticityofVariance,
        ScenarioGenerator, yieldcurve

end

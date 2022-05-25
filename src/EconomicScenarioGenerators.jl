module EconomicScenarioGenerators

using LabelledArrays
using Requires

abstract type InterestRateModel end

abstract type ShortRateModel <: InterestRateModel end


"""
Via Wikipedia: https://en.wikipedia.org/wiki/Vasicek_model
"""
struct Vasicek <: ShortRateModel
    a::Float64 # 0.136
    b::Float64 # .0168
    σ::Float64 # .0119
    initial::Float64 # 0.01
end

function nextrate(M::Vasicek,prior,time,timestep) 
    prior + M.a * (M.b - prior) * timestep + M.σ * sqrt(timestep) * randn()
end

"""
outputtype defines what the iterator's type output is for each element
"""
outputtype(::Type{Vasicek}) = Float64

"""
Via Wikipedia: https://en.wikipedia.org/wiki/Cox%E2%80%93Ingersoll%E2%80%93Ross_model
"""
struct CoxIngersollRoss <: ShortRateModel
    a::Float64 # 0.136
    b::Float64 # .0168
    σ::Float64 # .0119
    initial::Float64 # 0.01
end

function nextrate(M::CoxIngersollRoss,prior,time,timestep) 
    prior + M.a * (M.b - prior) * timestep + M.σ * sqrt(prior) * randn()
end

"""
outputtype defines what the iterator's type output is for each element
"""
outputtype(::Type{CoxIngersollRoss}) = Float64

"""
Via Wikipedia: https://en.wikipedia.org/wiki/Hull%E2%80%93White_model
"""
struct HullWhite{T} <: ShortRateModel
    a::Float64 # 0.136
    b::Float64 # .0168
    σ::Float64 # .0119
    Θ::T
end
# See Yields.jl for HullWhite with a YieldCurve defining theta

# this is when \theta is a function
function nextrate(M::HullWhite,prior,time,timestep) where {T}
    prior + (M.θ(time)+ M.a * prior) * timestep + M.σ * randn()
end


"""
outputtype defines what the iterator's type output is for each element
"""
outputtype(::Type{HullWhite}) = Float64



struct ScenarioGenerator{N<:Real,T}
    timestep::N
    endtime::N
    model::T
end

function Base.length(sg::ScenarioGenerator{N,T}) where {N,T<:InterestRateModel}
    return length(0:sg.timestep:sg.endtime) 
end
function Base.iterate(sg::ScenarioGenerator{N,T}) where {N,T<:InterestRateModel}

    state = @LArray [0,sg.model.initial] (:time,:rate)
    return (state.rate,state) # TODO: Implement intitial conditions for models
end

function Base.iterate(sg::ScenarioGenerator{N,T},state) where {N,T<:InterestRateModel}
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

#iteration example
struct Squares
    count::Int
end

Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)
Base.eltype(::Type{Squares}) = Int 
Base.length(S::Squares) = S.count


function __init__()
    @require Yields="d7e99b2f-e7f3-4d9e-9f01-2338fc023ad3" include("Yields.jl")
end

export Vasicek, CoxIngersollRoss, HullWhite,
        ScenarioGenerator, yieldcurve

end

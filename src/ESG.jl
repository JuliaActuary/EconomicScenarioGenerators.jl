module ESG

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
end

function nextrate(M::Vasicek,prior,timestep) 
    prior + M.a * (M.b - prior) * timestep + M.σ * sqrt(timestep) * randn()
end


"""
outputtype defines what the iterator's type output is for each element
"""
outputtype(::Type{Vasicek}) = Float64

struct ScenarioGenerator{T,U}
    timestep::Float64
    length::Float64
    model::T
    initial::U
end

function Base.length(sg::ScenarioGenerator{T}) where {T<:InterestRateModel}
    return round(Int,sg.length/ sg.timestep)
end
function Base.iterate(sg::ScenarioGenerator{T}) where {T<:InterestRateModel}

    state = @LArray [1,sg.initial] (:count,:rate)
    return (state.rate,state) # TODO: Implement intitial conditions for models
end

function Base.iterate(sg::ScenarioGenerator{T},state) where {T<:InterestRateModel}
    if state.count >= round(Int, sg.length / sg.timestep) #TODO avoid this calc in loop
        return nothing
    else
        new_rate = nextrate(sg.model,state.rate,sg.timestep)
        state.count += 1
        state.rate = new_rate
        return (state.rate, state)
    end
end

Base.eltype(::Type{ScenarioGenerator{T}}) where {T<:InterestRateModel} = outputtype(T)

struct Squares
    count::Int
end

#iteration example
Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)
Base.eltype(::Type{Squares}) = Int 
Base.length(S::Squares) = S.count


function __init__()
    @require Yields="d7e99b2f-e7f3-4d9e-9f01-2338fc023ad3" include("Yields.jl")
end

export Vasicek, ScenarioGenerator, yieldcurve

end

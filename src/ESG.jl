module ESG

using LabelledArrays

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

struct ScenarioGenerator{T}
    timestep
    length
    model::T
end

function Base.length(sg::ScenarioGenerator{T}) where {T<:InterestRateModel}
    return sg.timestep * sg.length
end
function Base.iterate(sg::ScenarioGenerator{T}) where {T<:InterestRateModel}

    state = @LArray [1,0.01] (:count,:rate)
    return (state.rate,state) # TODO: Implement intitial conditions for models
end

function Base.iterate(sg::ScenarioGenerator{T},state) where {T<:InterestRateModel}
    if state.count >= sg.timestep * sg.length
        return nothing
    else
        new_rate = nextrate(sg.model,state.rate,sg.timestep)
        state.count += state.count 
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
end

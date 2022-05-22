module ESG

abstract type InterestRateModel end

abstract type ShortRateModel <: InterestRateModel end


"""
Via Wikipedia: https://en.wikipedia.org/wiki/Vasicek_model
"""
struct Vasicek <: ShortRateModel
    a # 0.136
    b # .0168
    σ # .0119
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
    return (1,1)
end

function Base.iterate(sg::ScenarioGenerator{T},state) where {T<:InterestRateModel}
    if state >= sg.timestep * sg.length
        return nothing
    else
        return (state+1, state+1)
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

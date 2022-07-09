abstract type EquityModel <: EconomicModel end

"""
    BlackScholesMerton(r,q,σ,initial)

Where `initial` is the initial value of the security.
"""
struct BlackScholesMerton{T,U,V} <:EquityModel
    r::T # risk free rate
    q::U # dividend yield
    σ::V # roughly equivalent to the volatility in the usual lognormal model multiplied by F^{1-β}_{0}
    initial::Float64
end
function nextrate(M::BlackScholesMerton,prior,time,timestep)
    r, q, σ = M.r, M.q, M.σ
    prior + (r-q)*prior * timestep + prior * σ * sqrt(timestep) * randn()
end

"""
outputtype defines what the iterator's type output is for each element
"""
outputtype(::Type{T}) where {T<:EquityModel} = Float64
function __initial_short_rate(M::BlackScholesMerton,timestep)
    M.initial
end

"""
    ConstantElasticityofVariance(r,q,σ,β,initial)

Where `initial` is the initial value of the security.
"""
struct ConstantElasticityofVariance{T,U,V,W} <:EquityModel
    r::T # risk free rate
    q::U # dividend yield
    σ::V # roughly equivalent to the volatility in the usual lognormal model multiplied by F^{1-β}_{0}
    β::W # elasticity of variance
    initial::Float64
end

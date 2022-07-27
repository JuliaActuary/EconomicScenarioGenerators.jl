abstract type InterestRateModel <: EconomicModel end

abstract type ShortRateModel <: InterestRateModel end


"""

    Vasicek(a,b,σ,initial::Yields.Rate)

A one-factor interest rate model. Parameters:

- `a` characterizes the speed of mean reversion
- `b` is the long term mean level
- `σ` is the instantaneous volatility

See more on Wikipedia: https://en.wikipedia.org/wiki/Vasicek_model
"""
struct Vasicek{T<:Yields.Rate} <: ShortRateModel
    a::Float64 # 0.136
    b::Float64 # .0168
    σ::Float64 # .0119
    initial::T # 0.01
end

function nextrate(RNG,M::Vasicek{T},prior,time,timestep) where T
    prior + M.a * (M.b - prior) * timestep + M.σ * sqrt(timestep) * randn(RNG)
end

"""
outputtype defines what the iterator's type output is for each element
"""
outputtype(::Type{T}) where {T<:ShortRateModel} = Yields.Rate{Float64, Yields.Continuous}

"""
    CoxIngersollRoss(a,b,σ,initial::Yields.Rate)

Via Wikipedia: https://en.wikipedia.org/wiki/Cox%E2%80%93Ingersoll%E2%80%93Ross_model
"""
struct CoxIngersollRoss{T<:Yields.Rate} <: ShortRateModel
    a::Float64 # 0.136
    b::Float64 # .0168
    σ::Float64 # .0119
    initial::T # 0.01
end

function nextrate(RNG,M::CoxIngersollRoss{T},prior,time,timestep) where {T}
    prior + M.a * (M.b - prior) * timestep + M.σ * sqrt(Yields.rate(prior)) * randn(RNG)
end

"""
    HullWhite(a,σ,curve::Yields.AbstractYield)

Via Wikipedia: https://en.wikipedia.org/wiki/Hull%E2%80%93White_model
"""
struct HullWhite{T} <: ShortRateModel
    a::Float64 # 0.136
    σ::Float64 # .0168
    curve::T
end
# See Yields.jl for HullWhite with a YieldCurve defining theta

# how would HullWhite be constructed if not giving it a curve?
function nextrate(RNG,M::HullWhite{T},prior,time,timestep) where {T}
    θ_t = θ(M,time)
    # https://quantpie.co.uk/srm/hull_white_sr.php
    prior + (θ_t - M.a * prior) * timestep + M.σ * √(timestep) * randn(RNG)
end

function θ(M::HullWhite{T},time) where {T<:Yields.AbstractYield}
    # https://quantpie.co.uk/srm/hull_white_sr.php
    # https://quant.stackexchange.com/questions/8724/how-to-calibrate-hull-white-from-zero-curve
    f(t) = Yields.rate(Yields.forward(M.curve,t))
    a = M.a
    δf = ForwardDiff.derivative(f, time)
    f_t = f(time)

    return δf + f_t * a  + M.σ^2 / (2*a)*(1-exp(-2*a*time))

end

function θ(M::HullWhite{T},time) where {T<:Real}
    # https://quantpie.co.uk/srm/hull_white_sr.php
    # https://quant.stackexchange.com/questions/8724/how-to-calibrate-hull-white-from-zero-curve
    a = M.a
    δf = 0
    f_t = M.θ

    return δf + f_t * a  + M.σ^2 / (2*a)*(1-exp(-2*a*time))

end

"""
outputtype defines what the iterator's type output is for each element
"""
outputtype(::Type{HullWhite{T}}) where {T} = Yields.__ratetype(T)

function initial_value(M::HullWhite{T},timestep) where {T}
    Yields.forward(M.curve,0,timestep)
end
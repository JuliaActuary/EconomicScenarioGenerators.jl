abstract type EquityModel <: EconomicModel end

"""
    BlackScholesMerton(r,q,σ,initial)

An equity price model where `initial` is the initial value of the security.

- `r` is the risk free rate
- `q` is the dividend yield
- `σ` is the volatility for the unit period

# Example

```julia-repl
julia> m = BlackScholesMerton(0.01,0.02,.15,100.)
BlackScholesMerton{Float64, Float64, Float64}(0.01, 0.02, 0.15, 100.0)

julia> s = ScenarioGenerator(1/252,1.,m,Random.Xoshiro(123))
ScenarioGenerator{Float64, BlackScholesMerton{Float64, Float64, Float64}, Xoshiro}(0.003968253968253968, 1.0, BlackScholesMerton{Float64, Float64, Float64}(0.01, 0.02, 0.15, 100.0), Xoshiro(0xfefa8d41b8f5dca5, 0xf80cc98e147960c1, 0x20e2ccc17662fc1d, 0xea7a7dcb2e787c01))

julia> collect(s)
253-element Vector{Float64}:
 100.0
  99.38331866043562
  98.01039338118557
   ⋮
  88.57032295705861
  88.40149667285587
```

"""
struct BlackScholesMerton{T,U,V} <: EquityModel
    r::T # risk free rate
    q::U # dividend yield
    σ::V # roughly equivalent to the volatility in the usual lognormal model multiplied by F^{1-β}_{0}
    initial::Float64
end



function nextvalue(M::BlackScholesMerton, prior, time, timestep, variate)
    variate = quantile(Normal(), variate)
    r, q, σ = M.r, M.q, M.σ
    # Hull Options, Futures, & Other Derivatives, 10th ed., pg 470
    return (
        prior *
        exp((r - q - σ^2 / 2) * timestep +
            σ * sqrt(timestep) * variate)
    )
end

"""
__outputtype defines what the iterator's type output is for each element
"""
function __initial_short_rate(M::BlackScholesMerton, timestep)
    M.initial
end

"""
    ConstantElasticityofVariance(r,q,σ,β,initial)

Where `initial` is the initial value of the security.
"""
struct ConstantElasticityofVariance{T,U,V,W} <: EquityModel
    r::T # risk free rate
    q::U # dividend yield
    σ::V # roughly equivalent to the volatility in the usual lognormal model multiplied by F^{1-β}_{0}
    β::W # elasticity of variance
    initial::Float64
end

abstract type EquityModel <: EconomicModel end

"""
    BlackScholesMerton(r,q,σ,initial)

An equity price model where `initial` is the initial value of the security.

- `r` is the risk free rate
- `q` is the dividend yield
- `σ` is the volatility for the unit period

# Example

```julia-repl
julia> using EconomicScenarioGenerators, Random

julia> m = BlackScholesMerton(0.01,0.02,.15,100.)
BlackScholesMerton{Float64, Float64, Float64}(0.01, 0.02, 0.15, 100.0)

julia> s = ScenarioGenerator(1/252, 1.0, m, Xoshiro(123));

julia> prices = collect(s);

julia> length(prices)
253

julia> first(prices), last(prices)
(100.0, 85.41947139805312)
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


# n.b. a ConstantElasticityofVariance model was previously exported here, but it
# had no `nextvalue` method — any ScenarioGenerator built on it failed at the
# first step — so it has been removed rather than ship non-functional API.

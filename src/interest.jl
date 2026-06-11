abstract type InterestRateModel <: EconomicModel end

abstract type ShortRateModel <: InterestRateModel end


"""

    Vasicek(a,b,σ,initial::FinanceCore.Rate)

A one-factor interest rate model. Parameters:

- `a` characterizes the speed of mean reversion
- `b` is the long term mean level
- `σ` is the instantaneous volatility

See more on Wikipedia: https://en.wikipedia.org/wiki/Vasicek_model


Can be reinterpreted as a yield curve from FinanceModels.jl with `YieldCurve(s::ScenarioGenerator)`

# Example
```julia-repl

julia> using EconomicScenarioGenerators, FinanceModels

julia> m = Vasicek(0.136,0.0168,0.0119,Continuous(0.01))
Vasicek{FinanceCore.Rate{Float64, Continuous}}(0.136, 0.0168, 0.0119, FinanceCore.Rate{Float64, Continuous}(0.01, Continuous()))

julia> s = EconomicScenarioGenerators.ScenarioGenerator(
           0.5,                              # timestep
           30.,                             # projection horizon
           m
       );

julia> collect(s)
61-element Vector{FinanceCore.Rate{Float64, Continuous}}:
 FinanceCore.Rate{Float64, Continuous}(0.01, Continuous())
 FinanceCore.Rate{Float64, Continuous}(0.010455802777823464, Continuous())
 ⋮
 FinanceCore.Rate{Float64, Continuous}(-0.0027467625238898194, Continuous())

 julia> YieldCurve(s)

              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Yield Curve (Yields.BootstrapCurve)⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀           
              ┌────────────────────────────────────────────────────────────┐           
         0.03 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ Zero rates
              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠤⠤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠖⠒⠒⠒⠋⠉⠉⠉⠉│           
              │⠀⠀⠀⠀⠀⠀⠀⡠⠒⠒⠒⠒⠒⠒⠒⠒⠢⠤⠤⠊⠁⠀⠀⠀⠀⠀⠉⠑⠢⣄⣀⡠⠤⠤⠤⠤⠖⠊⠉⠁⠀⠉⠉⠑⠒⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⠀⠀⡜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
   Continuous │⠀⠀⠀⠀⠀⡸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⣀⣀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
            0 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
              └────────────────────────────────────────────────────────────┘           
              ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀time⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀30⠀        
```
"""
struct Vasicek{T<:FinanceCore.Rate} <: ShortRateModel
    a::Float64 # 0.136
    b::Float64 # .0168
    σ::Float64 # .0119
    initial::T # 0.01
end

function nextvalue(M::Vasicek{T}, prior, time, timestep, variate) where {T}
    variate = quantile(Normal(), variate)
    prior + M.a * (M.b - prior) * timestep + M.σ * sqrt(timestep) * variate
end

"""
    CoxIngersollRoss(a,b,σ,initial::FinanceCore.Rate)

A one-factor interest rate model. Parameters:

- `a` characterizes the speed of mean reversion
- `b` is the long term mean level
- `σ` is the instantaneous volatility

Via Wikipedia: https://en.wikipedia.org/wiki/Cox%E2%80%93Ingersoll%E2%80%93Ross_model

Discretization: partial-truncation Euler (Deelstra–Delbaen) — the diffusion term
uses `√(max(r, 0))` so that a path which crosses zero does not throw a
`DomainError`, while the drift continues to pull the untruncated state back
toward `b`.

Can be reinterpreted as a yield curve from FinanceModels.jl with `YieldCurve(s::ScenarioGenerator)`

# Example
```julia-repl

julia> m = CoxIngersollRoss(0.136,0.0168,0.0119,Continuous(0.01))
CoxIngersollRoss{FinanceCore.Rate{Float64, Continuous}}(0.136, 0.0168, 0.0119, FinanceCore.Rate{Float64, Continuous}(0.01, Continuous()))

julia> s = EconomicScenarioGenerators.ScenarioGenerator(
           0.5,                              # timestep
           30.,                             # projection horizon
           m
       );

       julia> collect(s)
       61-element Vector{FinanceCore.Rate{Float64, Continuous}}:
        FinanceCore.Rate{Float64, Continuous}(0.01, Continuous())
        FinanceCore.Rate{Float64, Continuous}(0.010355508443426625, Continuous())
        ⋮
        FinanceCore.Rate{Float64, Continuous}(0.01170589378629289, Continuous())

julia> YieldCurve(s)

        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Yield Curve (Yields.BootstrapCurve)⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀           
        ┌────────────────────────────────────────────────────────────┐           
  0.018 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ Zero rates
        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠒⠒⠒⠒⠦⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡤⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠢⢄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠓⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒│           
        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠔⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
Continuous │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡠⠤⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠀⠀⠀⠀⠀⠀⠀⢀⡤⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠀⠀⠀⠀⠀⢀⡔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠀⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠀⠀⠀⢀⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠀⠀⢠⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        │⠢⠔⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
  0.009 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           
        └────────────────────────────────────────────────────────────┘           
        ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀time⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀30⠀           
```
"""
struct CoxIngersollRoss{T<:FinanceCore.Rate} <: ShortRateModel
    a::Float64 # 0.136
    b::Float64 # .0168
    σ::Float64 # .0119
    initial::T # 0.01
end

function nextvalue(M::CoxIngersollRoss{T}, prior, time, timestep, variate) where {T}
    variate = quantile(Normal(), variate)
    # diffusion scales with √timestep (it was missing, inflating the shock
    # variance by 1/timestep for any timestep ≠ 1); √(max(r,0)) is the
    # partial-truncation Euler guard documented in the docstring
    prior + M.a * (M.b - prior) * timestep + M.σ * sqrt(max(FinanceCore.rate(prior), zero(FinanceCore.rate(prior)))) * sqrt(timestep) * variate
end

"""
    HullWhite(a,σ,curve)

A one-factor interest rate model that should be market consistent with the given `curve`. `curve` may be:

- a FinanceModels.jl yield model (requires `using FinanceModels`), in which case θ is derived from the curve's instantaneous forwards via automatic differentiation, or
- a `FinanceCore.Rate` or plain `Real`, interpreted as a flat (continuously compounded, for `Real`) curve with a closed-form θ.

Via [Wikipedia](https://en.wikipedia.org/wiki/Hull–White_model#One-factor_model)
"""
struct HullWhite{T} <: ShortRateModel
    a::Float64 # 0.136
    σ::Float64 # .0168
    curve::T
end
# See FinanceModels.jl for HullWhite with a YieldCurve defining theta

__initial_value(m::HullWhite, timestep) = FinanceCore.forward(m.curve, 0.0, timestep)
__initial_value(m::HullWhite{T}, timestep) where {T<:Real} = m.curve

# how would HullWhite be constructed if not giving it a curve?
function nextvalue(M::HullWhite{T}, prior, time, timestep, variate) where {T}
    variate = quantile(Normal(), variate)
    # θ is evaluated at the gridpoint being generated (`time`). Under the
    # discretization used here — the state seeded at the discrete forward over
    # the first step, and discount factors accumulated by left-rectangle
    # integration in `YieldCurve` — this convention reprices the input curve an
    # order of magnitude more closely than θ(time - timestep) (textbook
    # left-endpoint Euler) or the previous θ(time + timestep): ~4bp vs ~30bp
    # max zero-coupon error at monthly steps on a 10y curve with σ = 1%.
    θ_t = θ(M, time, timestep)
    # https://quantpie.co.uk/srm/hull_white_sr.php
    prior + (θ_t - M.a * prior) * timestep + M.σ * √(timestep) * variate
end


# flat curves (a scalar continuous rate or a Rate): the instantaneous forward
# is constant, so ∂f/∂t = 0 and θ has the closed form below — no AD required
# and usable without FinanceModels loaded
function θ(M::HullWhite{T}, time, timestep) where {T<:Real}
    # https://quantpie.co.uk/srm/hull_white_sr.php
    # https://quant.stackexchange.com/questions/8724/how-to-calibrate-hull-white-from-zero-curve
    a = M.a
    f_t = M.curve
    return f_t * a + M.σ^2 / (2 * a) * (1 - exp(-2 * a * time))
end

function θ(M::HullWhite{T}, time, timestep) where {T<:FinanceCore.Rate}
    a = M.a
    f_t = M.curve.continuous_value # the flat instantaneous forward
    return f_t * a + M.σ^2 / (2 * a) * (1 - exp(-2 * a * time))
end

function __δf(model, time)
    # F(t) = -log DF(t) = ∫₀ᵗ f(s) ds, so F′ is the instantaneous forward and
    # F″ its time derivative. Scalar nested derivatives replace the previous
    # 1-element-vector gradient/hessian calls (which allocated arrays per step
    # and asserted Float64, blocking any future differentiation through θ).
    F(t) = -log(FinanceCore.discount(model.curve, t))
    f_t = ForwardDiff.derivative(F, time)
    δf = ForwardDiff.derivative(t -> ForwardDiff.derivative(F, t), time)
    return δf, f_t
end

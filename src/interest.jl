abstract type InterestRateModel <: EconomicModel end

abstract type ShortRateModel <: InterestRateModel end


"""

    Vasicek(a,b,σ,initial::Yields.Rate)

A one-factor interest rate model. Parameters:

- `a` characterizes the speed of mean reversion
- `b` is the long term mean level
- `σ` is the instantaneous volatility

See more on Wikipedia: https://en.wikipedia.org/wiki/Vasicek_model


Can be reinterpreted as a yield curve from Yields.jl with `Yields.Forward(s::ScenarioGenerator)`

# Example
```julia-repl

julia> m = Vasicek(0.136,0.0168,0.0119,Yields.Continuous(0.01))
Vasicek{Yields.Rate{Float64, Continuous}}(0.136, 0.0168, 0.0119, Yields.Rate{Float64, Continuous}(0.01, Continuous()))

julia> s = EconomicScenarioGenerators.ScenarioGenerator(
           0.5,                              # timestep
           30.,                             # projection horizon
           m
       );

julia> collect(s)
61-element Vector{Yields.Rate{Float64, Continuous}}:
 Yields.Rate{Float64, Continuous}(0.01, Continuous())
 Yields.Rate{Float64, Continuous}(0.010455802777823464, Continuous())
 ⋮
 Yields.Rate{Float64, Continuous}(-0.0027467625238898194, Continuous())

 julia> Yields.Forward(s)

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
__outputtype defines what the iterator's type output is for each element
"""
__outputtype(::Type{T}) where {T<:ShortRateModel} = Yields.Rate{Float64, Yields.Continuous}

"""
    CoxIngersollRoss(a,b,σ,initial::Yields.Rate)
    
    A one-factor interest rate model. Parameters:
    
    - `a` characterizes the speed of mean reversion
    - `b` is the long term mean level
    - `σ` is the instantaneous volatility
    
Via Wikipedia: https://en.wikipedia.org/wiki/Cox%E2%80%93Ingersoll%E2%80%93Ross_model


Can be reinterpreted as a yield curve from Yields.jl with `Yields.Forward(s::ScenarioGenerator)`

# Example
```julia-repl

julia> m = CoxIngersollRoss(0.136,0.0168,0.0119,Yields.Continuous(0.01))
CoxIngersollRoss{Yields.Rate{Float64, Continuous}}(0.136, 0.0168, 0.0119, Yields.Rate{Float64, Continuous}(0.01, Continuous()))

julia> s = EconomicScenarioGenerators.ScenarioGenerator(
           0.5,                              # timestep
           30.,                             # projection horizon
           m
       );

       julia> collect(s)
       61-element Vector{Yields.Rate{Float64, Continuous}}:
        Yields.Rate{Float64, Continuous}(0.01, Continuous())
        Yields.Rate{Float64, Continuous}(0.010355508443426625, Continuous())
        ⋮
        Yields.Rate{Float64, Continuous}(0.01170589378629289, Continuous())

julia> Yields.Forward(s)

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

An interest model that should be market consistent with the given `curve`.

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
    θ_t = θ(M,time,timestep)
    # https://quantpie.co.uk/srm/hull_white_sr.php
    prior + (θ_t - M.a * prior) * timestep + M.σ * √(timestep) * randn(RNG)
end

function θ(M::HullWhite{T},time,timestep) where {T<:Yields.AbstractYield}
    # https://quantpie.co.uk/srm/hull_white_sr.php
    # https://quant.stackexchange.com/questions/8724/how-to-calibrate-hull-white-from-zero-curve
    f(t) = Yields.rate(Yields.forward(M.curve,t))
    a = M.a
    δf = ForwardDiff.derivative(f, time)
    f_t = f(time)

    return δf/timestep + f_t * a  + M.σ^2 / (2*a)*(1-exp(-2*a*time))

end

function θ(M::HullWhite{T},time,timestep) where {T<:Real}
    # https://quantpie.co.uk/srm/hull_white_sr.php
    # https://quant.stackexchange.com/questions/8724/how-to-calibrate-hull-white-from-zero-curve
    a = M.a
    δf = 0
    f_t = M.θ

    return δf + f_t * a  + M.σ^2 / (2*a)*(1-exp(-2*a*time))

end

"""
__outputtype defines what the iterator's type output is for each element
"""
__outputtype(::Type{HullWhite{T}}) where {T} = Yields.__ratetype(T)

function initial_value(M::HullWhite{T},timestep) where {T}
    Yields.forward(M.curve,0,timestep)
end
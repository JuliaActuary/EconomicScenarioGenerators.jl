function yieldcurve(sg::ScenarioGenerator{N,T}) where {N,T<:InterestRateModel}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)

    Yields.Forward(sg,times)
end


function nextrate(M::HullWhite{T},prior,time,timestep) where {T<:Yields.AbstractYield}
    θ_t = θ(M,time)
    # https://quantpie.co.uk/srm/hull_white_sr.php
    prior + (θ_t - M.a * prior) * timestep + M.σ * √(timestep) * randn()
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
function yieldcurve(sg::ScenarioGenerator{N,T}) where {N,T<:InterestRateModel}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)

    Yields.Forward(sg,times)
end


function nextrate(M::HullWhite,prior,time,timestep) where {T<:Yields.YieldCurve}
    θ_t = Yields.forward(M.θ,time,time+timestep)
    prior + (θ_t - M.a * prior) * timestep + M.σ * randn()
end
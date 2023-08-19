function YieldCurve(sg::ScenarioGenerator{N,T,R}; model=FinanceModels.Spline.Linear()) where {N,T<:InterestRateModel,R}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    # compute the accumulated discount factor (ZCB price)
    zeros = cumsum(FinanceCore.rate.(sg .* sg.timestep)) ./ times

    zero_vec = clamp.(zeros, 0.00001, 1)
    return FinanceModels.Yield.Spline(model, times, zero_vec)

end
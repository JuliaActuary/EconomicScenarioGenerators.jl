function YieldCurve(sg::ScenarioGenerator{M,N,T,R}; model=FinanceModels.Spline.Linear()) where {M,N,T<:InterestRateModel,R}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    # compute the accumulated discount factor (ZCB price)
    zeros = cumsum(FinanceCore.rate.(sg .* sg.timestep)) ./ times

    zero_vec = clamp.(zeros, 0.00001, 1)
    return FinanceModels.Yield.Spline(model, times, zero_vec)

end

function YieldCurve(c::C; model=FinanceModels.Spline.Linear()) where {C<:Correlated}
    fsg = first(c.sg)
    Δt = fsg.timestep
    times = Δt:Δt:(fsg.endtime+Δt)
    # compute the accumulated discount factor (ZCB price)
    rs = collect(c)
    ycs = map(eachindex(c.sg)) do i
        r = [x[i] for x in rs]
        zeros = cumsum(FinanceCore.rate.(r .* Δt)) ./ times

        zero_vec = clamp.(zeros, 0.00001, 1)

        FinanceModels.Yield.Spline(model, times, zero_vec)
    end

    return ycs
end
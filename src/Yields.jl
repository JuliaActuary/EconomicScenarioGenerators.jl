function YieldCurve(sg::ScenarioGenerator{N,T,R}) where {N,T<:InterestRateModel,R}
    rates, times = __zeros_times(sg)
    Yields.Zero(rates,times)

end

function __disc_rate_to_fwd(rate,time)
    log(rate) / -time
end

function __zeros_times(sg::ScenarioGenerator{N,T,R}) where {N,T<:InterestRateModel,R}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    # compute the accumulated discount factor (ZCB price)
    zeros = cumsum(sg .* sg.timestep) ./ times

    return zeros, times
end
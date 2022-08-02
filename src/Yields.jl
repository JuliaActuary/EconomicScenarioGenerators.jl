function YieldCurve(sg::ScenarioGenerator{N,T,R}) where {N,T<:InterestRateModel,R}
    rates, times = __zeros_times(sg)
    Yields.Zero(rates,times)

end

function __disc_rate_to_fwd(rate,time)
    log(rate) / -time
end

function __zeros_times(sg::ScenarioGenerator{N,T,R}) where {N,T<:InterestRateModel,R}
    # times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    # compute the accumulated discount factor (ZCB price)
    # floor at zero in order to avoid having a negative discount factor 
    # return 1 .- cumsum(Yields.rate.(sg) .* sg.timestep)
    # rates = __disc_rate_to_fwd.(1 .- cumsum(Yields.rate.(sg) .* sg.timestep),times)
    zeros = cumsum(sg .* sg.timestep) ./ times

    return zeros, times
end
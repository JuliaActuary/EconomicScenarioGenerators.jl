function YieldCurve(sg::ScenarioGenerator{N,T,R}) where {N,T<:InterestRateModel,R}
    rates, times = __fwd_times(sg)
    Yields.Zero(rates,times)

end

function __disc_rate_to_fwd(rate,time)
    log(rate) / -time
end

function __fwd_times(sg::ScenarioGenerator{N,T,R}) where {N,T<:InterestRateModel,R}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    rates = __disc_rate_to_fwd.(1 .- cumsum(Yields.rate.(sg) .* sg.timestep),times)
    return rates, times
end
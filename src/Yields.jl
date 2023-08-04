function YieldCurve(sg::ScenarioGenerator{N,T,R}; model=FinanceModels.Spline.Cubic(), method=FinanceModels.Fit.Bootstrap()) where {N,T<:InterestRateModel,R}
    qs = Quotes(sg)
    FinanceModels.fit(model, qs, method)

end

# function YieldCurve(C::T) where {T<:Correlated}
#     timestep = first(C.sg).timestep
#     _, times = __zeros_times(first(C.sg))
#     _zeros(v) = cumsum(v .* timestep) ./ times
#     rates = collect(C)
#     zs = _zeros.(rates)
#     map(r->Yields.Zero(r,times),zs)

# end

# function __disc_rate_to_fwd(rate,time)
#     log(rate) / -time
# end

function Quotes(sg::ScenarioGenerator{N,T,R}) where {N,T<:InterestRateModel,R}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    # compute the accumulated discount factor (ZCB price)
    zeros = cumsum(sg .* sg.timestep) ./ times
    # the broadcasting versions is about 1/3 fewer allocations
    # zeros = Iterators.map(/,Iterators.accumulate(+,sg),times)

    return FinanceModels.ZCBYield.(zeros, times)
end
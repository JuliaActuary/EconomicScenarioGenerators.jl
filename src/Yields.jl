function yieldcurve(sg::ScenarioGenerator{T}) where {T<:InterestRateModel}
    times = sg.timestep:sg.timestep:sg.length

    Yields.Forward(sg,times)
end
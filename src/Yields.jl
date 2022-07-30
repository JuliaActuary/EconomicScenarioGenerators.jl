function Yields.Forward(sg::T) where {T<:ScenarioGenerator}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)

    Yields.Forward(sg,times)

end

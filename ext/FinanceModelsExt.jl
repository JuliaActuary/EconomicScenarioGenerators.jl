module FinanceModelsExt
import FinanceModels
import FinanceCore
import ForwardDiff

using EconomicScenarioGenerators
const ESG = EconomicScenarioGenerators

export YieldCurve

# make this an extension w/ FinanceModels?
function ESG.θ(M::ESG.HullWhite{T}, time, timestep) where {T<:Union{FinanceModels.Yield.AbstractYieldModel,FinanceCore.Rate}}
    # https://quantpie.co.uk/srm/hull_white_sr.php
    # https://quant.stackexchange.com/questions/8724/how-to-calibrate-hull-white-from-zero-curve
    # https://mdpi-res.com/d_attachment/mathematics/mathematics-08-01719/article_deploy/mathematics-08-01719-v2.pdf?version=1603181408
    a = M.a
    δf, f_t = ESG.__δf(M, time)

    return δf + f_t * a + M.σ^2 / (2 * a) * (1 - exp(-2 * a * time))

end

function ESG.YieldCurve(sg::ESG.ScenarioGenerator{M,N,T,R}; model=FinanceModels.Spline.Linear()) where {M,N,T<:ESG.InterestRateModel,R}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    # compute the accumulated discount factor (ZCB price)
    zeros = cumsum(FinanceCore.rate.(sg .* sg.timestep)) ./ times

    zero_vec = clamp.(zeros, 0.00001, 1)
    return FinanceModels.Yield.Spline(model, times, zero_vec)

end

function ESG.YieldCurve(c::C; model=FinanceModels.Spline.Linear()) where {C<:ESG.Correlated}
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
end
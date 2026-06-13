module FinanceModelsExt
import FinanceModels
import FinanceCore
import ForwardDiff

using EconomicScenarioGenerators
const ESG = EconomicScenarioGenerators

export YieldCurve

# Rate (flat) curves are handled by the closed-form θ in src; the AD-based θ is
# only needed for genuine curve objects
function ESG.θ(M::ESG.HullWhite{T}, time, timestep) where {T<:FinanceModels.Yield.AbstractYieldModel}
    # https://quantpie.co.uk/srm/hull_white_sr.php
    # https://quant.stackexchange.com/questions/8724/how-to-calibrate-hull-white-from-zero-curve
    # https://mdpi-res.com/d_attachment/mathematics/mathematics-08-01719/article_deploy/mathematics-08-01719-v2.pdf?version=1603181408
    a = M.a
    δf, f_t = ESG.__δf(M, time)

    return δf + f_t * a + M.σ^2 / (2 * a) * (1 - exp(-2 * a * time))

end

function ESG.YieldCurve(sg::ESG.ScenarioGenerator{M,N,T,R}; model=FinanceModels.Spline.Linear()) where {M,N,T<:ESG.InterestRateModel,R}
    times = sg.timestep:sg.timestep:(sg.endtime+sg.timestep)
    # continuously-compounded zero rates from the left-rectangle integral of the
    # short-rate path: z(t_k) = (Σ_{j<k} r_j Δt) / t_k. No clamping: negative
    # rates are legitimate model output (the previous clamp to [1e-5, 1] — bounds
    # meant for discount factors — silently floored negative-rate paths)
    zs = cumsum(FinanceCore.rate.(sg .* sg.timestep)) ./ times
    return FinanceModels.Yield.Spline(model, times, zs)

end

function ESG.YieldCurve(c::C; model=FinanceModels.Spline.Linear()) where {C<:ESG.Correlated}
    fsg = first(c.sg)
    Δt = fsg.timestep
    times = Δt:Δt:(fsg.endtime+Δt)
    rs = collect(c)
    ycs = map(eachindex(c.sg)) do i
        r = [x[i] for x in rs]
        zs = cumsum(FinanceCore.rate.(r .* Δt)) ./ times
        FinanceModels.Yield.Spline(model, times, zs)
    end

    return ycs
end
end
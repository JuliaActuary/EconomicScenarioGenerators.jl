# http://www.timworrall.com/fin-40008/bscholes.pdf

function Distributions.LogNormal(m::BlackScholesMerton,T)
    r, q, σ = m.r, m.q, m.σ
    return LogNormal(
        log(m.initial) + (r-q-σ^2/2) * T,
        sqrt(T) * σ
        )
end

function Distributions.LogNormal(s::ScenarioGenerator{N,T}) where {N,T<:BlackScholesMerton}
    m = s.model
    t = s.endtime
    LogNormal(m,t)
end
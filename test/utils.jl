# http://www.timworrall.com/fin-40008/bscholes.pdf

function price_distribution(m::BlackScholesMerton,T)
    r, q, σ = m.r, m.q, m.σ
    return LogNormal(
        log(m.initial) + (r-q-σ^2/2) * T,
        sqrt(T) * σ
        )
end

function price_distribution(s::ScenarioGenerator{N,T}) where {N,T<:BlackScholesMerton}
    m = s.model
    t = s.endtime
    price_distribution(m,t)
end
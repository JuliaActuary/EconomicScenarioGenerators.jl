#TODO test that non-congruent component generators are not allowed
@testset "Correlated" begin
    using EconomicScenarioGenerators, Copulas

    m = BlackScholesMerton(0.01,0.02,.15,100.)
    s = ScenarioGenerator(
                        1,  # timestep
                        30, # projection horizon
                        m,  # model
                    )

    ss = [s,s] # these don't have to be the exact same
    g = GaussianCopula([1. 0.9; 0.9 1.])
    c = Correlated(ss,g,StableRNG(1))

    x = collect(c)

    ρ = cor(hcat(ratio.(x)...))
    @test ρ[1,2] ≈ 0.9 atol = 0.03
end
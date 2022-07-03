@testset "EquityModel" begin

    @testset "Vasicek" begin
        m = BlackScholesMerton(0.01,0.02,.15,100.)

        s = ScenarioGenerator(
                       1,  # timestep
                       30, # projection horizon
                       m,  # model
                   )

        @test length(s) == 31

        s = EconomicScenarioGenerators.ScenarioGenerator(
            0.5,                              # timestep
            30.,                             # projection horizon
            m
        )

        @test length(s) == 61

        prices = [last(collect(s)) for _ in 1:10_000]
        dist = LogNormal(
            log(m.initial) + (m.r-m.σ^2) * s.endtime,
            √(s.endtime) * m.σ
            )

        t = HypothesisTests.ExactOneSampleKSTest(prices,dist)
        @test HypothesisTests.pvalue(t) > 0.01


    end
end
@testset "EquityModel" begin

    @testset "BlackScholesMerton" begin
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
        
        dist = price_distribution(s)

        # we expect that the prices are lognormally distributed
        # and reject the null hypothesis that they are not if p less than some threshold
        # therefore, for test to pass we should fail to reject the null hypothesis and p
        # should be large
        t = HypothesisTests.ExactOneSampleKSTest(prices,dist)
        @test HypothesisTests.pvalue(t) > 0.05


    end
end
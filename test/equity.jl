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

        @testset "#14 - odd time steps" begin
            m = BlackScholesMerton(0.01,0.02,.15,100.)

            s = ScenarioGenerator(
                           1/252,  # timestep
                           1., # projection horizon
                           m,  # model
                       )

            @test length(collect(s)) == 253
        end
            

    end
end
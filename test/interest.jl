
@testset "InterestRateModel" begin

    @testset "Vasicek" begin
        m = Vasicek(0.136,0.0168,0.0119,Continuous(0.01))
        s = ScenarioGenerator(
                1.,                              # timestep
                30.,                             # projection horizon
                m
            )

        @test length(s) == 31

        s = EconomicScenarioGenerators.ScenarioGenerator(
            0.5,                              # timestep
            30.,                             # projection horizon
            m
        )

        @test length(s) == 61

        @test yieldcurve(s) isa Yields.AbstractYield
    end

    @testset "CoxIngersollRoss" begin
        m = CoxIngersollRoss(0.136,0.0168,0.0119,Continuous(0.01))
        s = ScenarioGenerator(
                1.,                              # timestep
                30.,                             # projection horizon
                m
            )

        @test length(s) == 31

        s = EconomicScenarioGenerators.ScenarioGenerator(
            0.5,                              # timestep
            30.,                             # projection horizon
            m
        )

        @test length(s) == 61

        @test yieldcurve(s) isa Yields.AbstractYield
    end
    
    @testset "Hull White" begin

        @testset "with AbstractYield" begin
            rates =[0.01, 0.01, 0.03, 0.05, 0.07, 0.16, 0.35, 0.92, 1.40, 1.74, 2.31, 2.41] ./ 100
            mats = [1/12, 2/12, 3/12, 6/12, 1, 2, 3, 5, 7, 10, 20, 30]
            c = Yields.CMT(rates,mats)

            m = HullWhite(.1,.005,c)

            s = ScenarioGenerator(
                1.,                              # timestep
                30.,                             # projection horizon
                m
            )

            @test length(s) == 31

            s = EconomicScenarioGenerators.ScenarioGenerator(
                0.5,                              # timestep
                30.,                             # projection horizon
                m
            )

            @test length(s) == 61

            @test yieldcurve(s) isa Yields.AbstractYield
        end

        @testset "with Rate" begin
            m = HullWhite(.1,.005,Continuous(0.05))

            s = ScenarioGenerator(
                1.,                              # timestep
                30.,                             # projection horizon
                m
            )

            @test length(s) == 31

            s = EconomicScenarioGenerators.ScenarioGenerator(
                0.5,                              # timestep
                30.,                             # projection horizon
                m
            )

            @test length(s) == 61

            @test yieldcurve(s) isa Yields.AbstractYield

        end
    end

    
    
end


@testset "InterestRateModel" begin

    @testset "Vasicek" begin
        m = Vasicek(0.136,0.0168,0.0119,Yields.Continuous(0.01))
        s = ScenarioGenerator(
                1.,                              # timestep
                30.,                             # projection horizon
                m
            )

        @test length(s) == 31

        @test eltype(s) == Yields.Rate{Float64, Yields.Continuous}

        s = EconomicScenarioGenerators.ScenarioGenerator(
            0.5,                              # timestep
            30.,                             # projection horizon
            m,
            StableRNG(1)
        )

        @test length(s) == 61

        @test Yields.Forward(s) isa Yields.AbstractYield

        E(m,t) = Yields.rate(m.initial) * exp(-m.a*t) + m.b * (1 - exp(-m.a*t))
        V(m,t) = (m.σ ^2) / (2 * m.a) * (1 - exp(-m.a*t))

        samples = [Yields.rate(last(s)) for _ in 1:10000]

        # https://en.wikipedia.org/wiki/Vasicek_model#Asymptotic_mean_and_variance
        @test mean(samples) ≈ E(m,s.endtime) atol = 0.01 
        @test var(samples) ≈ V(m,s.endtime) atol = 0.001  
    end

    @testset "CoxIngersollRoss" begin
        m = CoxIngersollRoss(0.136,0.0168,0.0119,Yields.Continuous(0.01))
        s = ScenarioGenerator(
                1.,                              # timestep
                30.,                             # projection horizon
                m
            )

        @test length(s) == 31

        @test eltype(s) == Yields.Rate{Float64, Yields.Continuous}

        s = EconomicScenarioGenerators.ScenarioGenerator(
            0.5,                              # timestep
            30.,                             # projection horizon
            m,
            StableRNG(1)
        )

        @test length(s) == 61

        @test Yields.Forward(s) isa Yields.AbstractYield

        E(m,t) = Yields.rate(m.initial) * exp(-m.a*t) + m.b * (1 - exp(-m.a*t))
        V(m,t) = Yields.rate(m.initial) * (m.σ ^2) / m.a * (exp(-m.a*t) - exp(-2*m.a*t)) + m.b * m.σ^2 / (2*m.a)*(1-exp(-m.a*t))^2

        samples = [Yields.rate(last(s)) for _ in 1:10000]

        # https://en.wikipedia.org/wiki/Vasicek_model#Asymptotic_mean_and_variance
        @test mean(samples) ≈ E(m,s.endtime) atol = 0.01 
        @test var(samples) ≈ V(m,s.endtime) atol = 0.001 
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
                m,
                StableRNG(1)
            )

            @test length(s) == 61

            @test Yields.Forward(s) isa Yields.AbstractYield

            cfs = [10 for _ in 1:20]

            @testset "Market Consistency" begin
                market_price = pv(c,cfs)

                samples = [pv(Yields.Forward(s),cfs) for _ in 1:5000]

                @test mean(samples) ≈ market_price rtol = 0.01
            end
        end

        @testset "with Rate" begin
            m = HullWhite(.1,.005,Yields.Continuous(0.05))

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

            @test Yields.Forward(s) isa Yields.AbstractYieldCurve

        end
    end

    
    
end

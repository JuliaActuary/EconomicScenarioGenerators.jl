
@testset "InterestRateModel" begin

    @testset "Vasicek" begin
        m = Vasicek(0.136, 0.0168, 0.0119, FinanceCore.Continuous(0.01))
        s = ScenarioGenerator(
            1.0,                              # timestep
            30.0,                             # projection horizon
            m
        )

        v = collect(s)
        @test length(v) == 31

        @test eltype(v) == FinanceCore.Rate{Float64,FinanceCore.Continuous}

        s = EconomicScenarioGenerators.ScenarioGenerator(
            0.5,                              # timestep
            30.0,                             # projection horizon
            m,
            StableRNG(1)
        )

        v = collect(s)
        @test length(v) == 61

        @test YieldCurve(s) isa FinanceModels.Yield.AbstractYieldModel

        E(m, t) = FinanceCore.rate(m.initial) * exp(-m.a * t) + m.b * (1 - exp(-m.a * t))
        V(m, t) = (m.σ^2) / (2 * m.a) * (1 - exp(-m.a * t))

        samples = [s |> TakeLast(1) |> collect |> only |> FinanceCore.rate for _ in 1:10000]

        # https://en.wikipedia.org/wiki/Vasicek_model#Asymptotic_mean_and_variance
        @test mean(samples) ≈ E(m, s.endtime) atol = 0.01
        @test var(samples) ≈ V(m, s.endtime) atol = 0.001
    end

    @testset "CoxIngersollRoss" begin
        m = CoxIngersollRoss(0.136, 0.0168, 0.0119, FinanceCore.Continuous(0.01))
        s = ScenarioGenerator(
            1.0,                              # timestep
            30.0,                             # projection horizon
            m
        )

        v = collect(s)
        @test length(v) == 31

        @test eltype(v) == FinanceCore.Rate{Float64,FinanceCore.Continuous}

        s = EconomicScenarioGenerators.ScenarioGenerator(
            0.5,                              # timestep
            30.0,                             # projection horizon
            m,
            StableRNG(1)
        )

        v = collect(s)
        @test length(v) == 61

        @test YieldCurve(s) isa FinanceModels.Yield.AbstractYieldModel

        E(m, t) = FinanceCore.rate(m.initial) * exp(-m.a * t) + m.b * (1 - exp(-m.a * t))
        V(m, t) = FinanceCore.rate(m.initial) * (m.σ^2) / m.a * (exp(-m.a * t) - exp(-2 * m.a * t)) + m.b * m.σ^2 / (2 * m.a) * (1 - exp(-m.a * t))^2

        samples = [s |> TakeLast(1) |> collect |> only |> FinanceCore.rate for _ in 1:10000]

        # https://en.wikipedia.org/wiki/Vasicek_model#Asymptotic_mean_and_variance
        @test mean(samples) ≈ E(m, s.endtime) atol = 0.01
        @test var(samples) ≈ V(m, s.endtime) atol = 0.001
    end

    @testset "Hull White" begin

        @testset "with AbstractYield" begin
            rates = [0.01, 0.01, 0.03, 0.05, 0.07, 0.16, 0.35, 0.92, 1.40, 1.74, 2.31, 2.41] ./ 100
            mats = [1 / 12, 2 / 12, 3 / 12, 6 / 12, 1, 2, 3, 5, 7, 10, 20, 30]
            c = FinanceModels.fit(
                FinanceModels.Spline.Cubic(),
                FinanceModels.ZCBYield.(rates, mats),
                FinanceModels.Fit.Bootstrap()
            )

            m = HullWhite(2.0, 0.01, c)

            s = ScenarioGenerator(
                1.0,                              # timestep
                30.0,                             # projection horizon
                m
            )

            v = collect(s)
            @test length(v) == 31


            s = EconomicScenarioGenerators.ScenarioGenerator(
                0.01,                              # timestep
                30.0,                             # projection horizon
                m,
                StableRNG(1)
            )

            v = collect(s)
            @test length(v) == 3001

            @test YieldCurve(s) isa FinanceModels.Yield.AbstractYieldModel

            cfs = [10 for _ in 1:20]

            @testset "Market Consistency" begin
                market_price = pv(c, cfs)

                samples = [pv(YieldCurve(s), cfs) for _ in 1:100]

                @test mean(samples) ≈ market_price rtol = 0.01
            end
        end

        @testset "with Rate" begin
            c = FinanceCore.Continuous(0.03)
            m = HullWhite(2.0, 0.001, c)

            s = ScenarioGenerator(
                1.0,                              # timestep
                30.0,                             # projection horizon
                m,
                StableRNG(1)
            )

            @test length(collect(s)) == 31

            s = EconomicScenarioGenerators.ScenarioGenerator(
                0.5,                              # timestep
                30.0,                             # projection horizon
                m,
                StableRNG(1)
            )

            @test length(collect(s)) == 61

            @test YieldCurve(s) isa FinanceModels.Yield.AbstractYieldModel

            cfs = [10 for _ in 1:20]

            @testset "Market Consistency" begin
                market_price = pv(c, cfs)

                μ = mean(pv(YieldCurve(s), cfs) for _ in 1:100)

                @test μ ≈ market_price rtol = 0.005
            end

        end
        @testset "constant derivative" begin

            import FinanceModels: AbstractYieldModel, discount

            # a yield curve where the rate of change of the instantaneous forward is constant
            struct ConstDeriv <: FinanceModels.Yield.AbstractYieldModel
                d::Float64
                initial::Float64
            end

            FinanceCore.discount(c::ConstDeriv, time) = exp(-(time^2 * c.d) / 2 - c.initial * time)


            m = HullWhite(0.1, 0.001, ConstDeriv(0.01, 0.02))
            a, b = EconomicScenarioGenerators.__δf(m, 1)
            @test a ≈ 0.01
            @test b ≈ 0.02 + 0.01 * 1
            a, b = EconomicScenarioGenerators.__δf(m, 2)
            @test a ≈ 0.01
            @test b ≈ 0.02 + 0.01 * 2

        end

        @testset "other functional forms" begin

            # discount = exp(-time^power/denom)
            struct Power <: FinanceModels.Yield.AbstractYieldModel
                p::Float64
                denom::Float64
            end

            FinanceCore.discount(c::Power, time) = exp(-(time)^c.p / c.denom)

            m = HullWhite(0.1, 0.001, Power(2, 10))
            a, b = EconomicScenarioGenerators.__δf(m, 1)
            @test a ≈ 1 / 5
            @test b ≈ 1 / 5
            a, b = EconomicScenarioGenerators.__δf(m, 2)
            @test a ≈ 1 / 5
            @test b ≈ 2 / 5




        end
    end


end

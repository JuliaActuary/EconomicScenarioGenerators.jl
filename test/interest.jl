
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
        # https://en.wikipedia.org/wiki/Vasicek_model#Asymptotic_mean_and_variance
        # (the exponent is -2at: the prior formula here used -at, which the old
        # loose atol could not distinguish)
        V(m, t) = (m.σ^2) / (2 * m.a) * (1 - exp(-2 * m.a * t))

        samples = [s |> TakeLast(1) |> collect |> only |> FinanceCore.rate for _ in 1:10000]

        @test mean(samples) ≈ E(m, s.endtime) atol = 0.001
        # rtol sized to Euler discretization bias at Δt = 0.5 (~+3.5%) plus
        # MC error (~1.4%); a wrong diffusion scaling is a ~2x error
        @test var(samples) ≈ V(m, s.endtime) rtol = 0.1
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

        # https://en.wikipedia.org/wiki/Cox%E2%80%93Ingersoll%E2%80%93Ross_model
        @test mean(samples) ≈ E(m, s.endtime) atol = 0.001
        # relative tolerance: the missing √timestep diffusion scaling this
        # guards against is a 1/timestep (2x at Δt = 0.5) variance error
        @test var(samples) ≈ V(m, s.endtime) rtol = 0.1

        @testset "terminal distribution is timestep-invariant" begin
            # the same model simulated at different timesteps must converge to
            # the same terminal moments; a diffusion mis-scaled by timestep
            # makes the variance ratio 1/Δt instead of ~1
            terminal(Δt) = [
                ScenarioGenerator(Δt, 30.0, m, StableRNG(7 + i)) |> TakeLast(1) |> collect |> only |> FinanceCore.rate
                for i in 1:10000
            ]
            v_coarse = var(terminal(1.0))
            v_fine = var(terminal(0.1))
            @test v_coarse ≈ v_fine rtol = 0.15
            @test v_fine ≈ V(m, 30.0) rtol = 0.1
        end

        @testset "partial truncation: zero-crossing paths do not throw" begin
            # near-zero initial rate with Feller condition violated: untruncated
            # Euler would take sqrt of a negative rate
            m0 = CoxIngersollRoss(0.05, 0.001, 0.05, FinanceCore.Continuous(0.0001))
            s0 = ScenarioGenerator(0.25, 30.0, m0, StableRNG(42))
            v = collect(s0)
            @test length(v) == 121
            @test all(isfinite(FinanceCore.rate(r)) for r in v)
        end
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

                # observed deviation ≈ 0.17% with θ evaluated at the generated
                # gridpoint (the prior θ(t+Δt) convention had ~10x the
                # repricing bias); deterministic given the StableRNG seed
                @test mean(samples) ≈ market_price rtol = 0.005
            end
        end

        @testset "negative rates are preserved in YieldCurve" begin
            # a Vasicek model pinned deep below zero: the curve built from its
            # paths must carry the negative zero rates (they were previously
            # clamped to [1e-5, 1], silently flooring them)
            mneg = Vasicek(0.5, -0.02, 0.0005, FinanceCore.Continuous(-0.02))
            sneg = ScenarioGenerator(0.5, 10.0, mneg, StableRNG(11))
            yc = YieldCurve(sneg)
            @test FinanceCore.rate(zero(yc, 5.0)) < 0
            @test FinanceCore.discount(yc, 5.0) > 1
        end

        @testset "with Real (flat curve)" begin
            m = HullWhite(2.0, 0.001, 0.03)
            s = ScenarioGenerator(0.5, 30.0, m, StableRNG(1))
            v = collect(s)
            @test length(v) == 61
            @test all(isfinite, v)
            # mean reversion towards the flat forward: terminal mean near 3%
            terminals = [ScenarioGenerator(0.5, 30.0, m, StableRNG(100 + i)) |> TakeLast(1) |> collect |> only for i in 1:1000]
            @test mean(terminals) ≈ 0.03 atol = 0.001
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

                # observed deviation ≈ 0.011%; deterministic given the seed
                @test μ ≈ market_price rtol = 0.001
            end

        end
        @testset "constant derivative" begin

            import FinanceModels: discount

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

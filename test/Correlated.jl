#TODO test that non-congruent component generators are not allowed
@testset "Correlated" begin
    using EconomicScenarioGenerators, Copulas

    @testset "Equity" begin
        @testset "BSM" begin
            m = BlackScholesMerton(0.01, 0.02, 0.15, 100.0)
            s = ScenarioGenerator(
                1,  # timestep
                30, # projection horizon
                m,  # model
            )

            ss = [s, s] # these don't have to be the exact same
            g = GaussianCopula([1.0 0.9; 0.9 1.0])
            c = Correlated(ss, g, StableRNG(1))

            x = collect(c)

            ρ = cor(hcat(ratio.(x)...))
            @test ρ[1, 2] ≈ 0.9 atol = 0.03
        end
    end

    @testset "Interest" begin
        @testset "HullWhite" begin
            rates = [0.01, 0.01, 0.03, 0.05, 0.07, 0.16, 0.35, 0.92, 1.40, 1.74, 2.31, 2.41] ./ 100
            mats = [1 / 12, 2 / 12, 3 / 12, 6 / 12, 1, 2, 3, 5, 7, 10, 20, 30]
            c = Yields.CMT(rates, mats)

            m = HullWhite(0.1, 0.01, c)

            s = ScenarioGenerator(
                0.1,                              # timestep
                30.0,                             # projection horizon
                m,
                StableRNG(1)
            )

            g = GaussianCopula([1.0 0.9; 0.9 1.0])
            c = Correlated([s, s], g, StableRNG(1))

            x = collect(c)

            ρ = cor(hcat(diff.(map(y->Yields.rate.(y),x))...))
            @test ρ[1, 2] ≈ 0.9 atol = 0.03
        end

        @testset "Vasicek" begin
            m = Vasicek(0.136, 0.0168, 0.0119, Yields.Continuous(0.01))
            s = ScenarioGenerator(
                .1,                              # timestep
                30.0,                             # projection horizon
                m
            )
            g = GaussianCopula([1.0 0.9; 0.9 1.0])
            c = Correlated([s, s], g, StableRNG(1))

            x = collect(c)

            ρ = cor(hcat(diff.(map(y->Yields.rate.(y),x))...))
            @test ρ[1, 2] ≈ 0.9 atol = 0.03
        end
        @testset "CIR" begin
            m = CoxIngersollRoss(0.136, 0.0168, 0.0119, Yields.Continuous(0.01))
            s = ScenarioGenerator(
                .1,                              # timestep
                30.0,                             # projection horizon
                m
            )
            g = GaussianCopula([1.0 0.9; 0.9 1.0])
            c = Correlated([s, s], g, StableRNG(1))

            x = collect(c)

            ρ = cor(hcat(diff.(map(y->Yields.rate.(y),x))...))
            @test ρ[1, 2] ≈ 0.9 atol = 0.03


            @test first(YieldCurve.(c)) isa Yields.AbstractYield
        end
    end
end
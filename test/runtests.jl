using ESG
using Test
using Yields

@testset "ESG.jl" begin
    m = ESG.Vasicek(0.136,0.0168,0.0119)
    s = ESG.ScenarioGenerator(
               1.,                              # timestep
               30.,                             # projection horizon
               ESG.Vasicek(0.136,.0168,.0119), # ESG model
               0.01                            # starting rate
           )

    @test length(s) == 30

    s = ESG.ScenarioGenerator(
        0.5,                              # timestep
        30.,                             # projection horizon
        ESG.Vasicek(0.136,.0168,.0119), # ESG model
        0.01                            # starting rate
    )

    @test length(s) == 60

    @test yieldcurve(s) isa Yields.YieldCurve


    
    
end

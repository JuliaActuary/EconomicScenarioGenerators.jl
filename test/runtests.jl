using EconomicScenarioGenerators
using Test
using Yields

@testset "EconomicScenarioGenerators.jl" begin
    m = Vasicek(0.136,0.0168,0.0119,0.01)
    s = ScenarioGenerator(
               1.,                              # timestep
               30.,                             # projection horizon
               Vasicek(0.136,.0168,.0119, 0.01), # EconomicScenarioGenerators model
           )

    @test length(s) == 31

    s = EconomicScenarioGenerators.ScenarioGenerator(
        0.5,                              # timestep
        30.,                             # projection horizon
        EconomicScenarioGenerators.Vasicek(0.136,.0168,.0119, 0.01) # EconomicScenarioGenerators model
    )

    @test length(s) == 61

    @test yieldcurve(s) isa Yields.YieldCurve


    
    
end

@testset "indexing" begin
    m = BlackScholesMerton(0.01,0.00,.15,100.)
    s = ScenarioGenerator(
        1/252,  # timestep
        1., # projection horizon
        m,  # model
    ) 
    @test last(s) isa Real
    @test first(s) isa Real
    @test s[10] isa Real
end
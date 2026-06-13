using EconomicScenarioGenerators
using Test
using FinanceCore
using FinanceModels
using Distributions
using Copulas
using HypothesisTests
using StatsBase
using StableRNGs
using Transducers

include("utils.jl")
include("interest.jl")
include("equity.jl")
include("Correlated.jl")

using Aqua
@testset "Aqua.jl" begin
    Aqua.test_all(EconomicScenarioGenerators)
end
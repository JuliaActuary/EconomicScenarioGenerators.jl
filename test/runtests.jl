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
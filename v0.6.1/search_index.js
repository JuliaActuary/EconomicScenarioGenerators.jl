var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = EconomicScenarioGenerators","category":"page"},{"location":"#EconomicScenarioGenerators.jl","page":"Home","title":"EconomicScenarioGenerators.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"(Image: Stable) (Image: Dev) (Image: Build Status) (Image: Coverage)","category":"page"},{"location":"","page":"Home","title":"Home","text":"This package is in Technical Preview Stage: The API is stabilizing and tests are passing but it has not been used in practice for very long. Please report any issues, provide feedback, and request specific features using the Discussions or Issues in this repository.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Interested in developing economic scenario generators in Julia? Consider contributing to this package. Open an issue, create a pull request, or discuss on the Julia Zulip's #actuary channel.","category":"page"},{"location":"#Usage","page":"Home","title":"Usage","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"EconoicScenarioGenerators.jl is now available via the General Registry. Install and use in the normal way:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Add EconomicScenarioGenerators via Pkg\nimport EconomicScenarioGenerators or using EconomicScenarioGenerators in your code","category":"page"},{"location":"#Examples","page":"Home","title":"Examples","text":"","category":"section"},{"location":"#Importing-packages","page":"Home","title":"Importing packages","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"First, import both EconomicScenarioGenerators and FinanceModels:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using EconomicScenarioGenerators\nusing FinanceModels","category":"page"},{"location":"#Models","page":"Home","title":"Models","text":"","category":"section"},{"location":"#Interest-Rate-Models","page":"Home","title":"Interest Rate Models","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Vasicek\nCoxIngersolRoss\nHullWhite","category":"page"},{"location":"#EquityModels","page":"Home","title":"EquityModels","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"BlackScholesMerton","category":"page"},{"location":"#Interest-Rate-Model-Examples","page":"Home","title":"Interest Rate Model Examples","text":"","category":"section"},{"location":"#Vasicek","page":"Home","title":"Vasicek","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"m = Vasicek(0.136,0.0168,0.0119,Continuous(0.01)) # a, b, σ, initial Rate\ns = ScenarioGenerator(\n        1,  # timestep\n        30, # projection horizon\n        m,  # model\n    )","category":"page"},{"location":"","page":"Home","title":"Home","text":"You can collect a single generated scenario lik so:","category":"page"},{"location":"","page":"Home","title":"Home","text":"rates = collect(s)","category":"page"},{"location":"","page":"Home","title":"Home","text":"And the package integrates with FinanceModels.jl:","category":"page"},{"location":"","page":"Home","title":"Home","text":"YieldCurve(s)\n","category":"page"},{"location":"","page":"Home","title":"Home","text":"will produce a yield curve object:","category":"page"},{"location":"","page":"Home","title":"Home","text":"              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Yield Curve (FinanceModels.Yield.Spline)⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀           \n              ┌────────────────────────────────────────────────────────────┐           \n         0.04 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ Zero rates\n              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⠀⠀⡠⠎⠉⠉⠊⠉⠑⠦⠤⠤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡠⠤⠤⠔│           \n              │⠀⠀⠀⠀⢀⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠦⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⠤⠔⠒⠊⠉⠉⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⢰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠒⠦⠤⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠤⠔⠒⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⠒⠒⠒⠊⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n   Continuous │⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⡸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉│           \n              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        -0.01 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              └────────────────────────────────────────────────────────────┘           \n              ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀time⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀30⠀        ","category":"page"},{"location":"#CoxIngersolRoss","page":"Home","title":"CoxIngersolRoss","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A CIR model:","category":"page"},{"location":"","page":"Home","title":"Home","text":"m = CoxIngersollRoss(0.136,0.0168,0.0119,Continuous(0.01))","category":"page"},{"location":"#Hull-White-Model-using-a-Yields.jl-YieldCurve","page":"Home","title":"Hull White Model using a Yields.jl YieldCurve","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Construct a yield curve and use that as the arbitrage-free forward curve within the Hull-White model.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using FinanceModels, EconomicScenarioGenerators\nrates =[0.01, 0.01, 0.03, 0.05, 0.07, 0.16, 0.35, 0.92, 1.40, 1.74, 2.31, 2.41] ./ 100\nmats = [1/12, 2/12, 3/12, 6/12, 1, 2, 3, 5, 7, 10, 20, 30]\n\n\ncurve = FinanceModels.fit(\n    Spline.Cubic(),\n    CMTYield.(rates,mats),\n    Fit.Bootstrap()\n)\n\n\nm = HullWhite(.1,.002,curve) # a, σ, curve\n\ns = ScenarioGenerator(\n        1/12,  # timestep\n        30., # projection horizon\n        m,  # model\n    )","category":"page"},{"location":"","page":"Home","title":"Home","text":"Create 1000 yield curves from the scenario generator:","category":"page"},{"location":"","page":"Home","title":"Home","text":"n = 1000\ncurves = [YieldCurve(s) for i in 1:n]","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia","category":"page"},{"location":"","page":"Home","title":"Home","text":"Plot the result:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Plots\n\ntimes = 1:30\np=plot(title=\"EconomicScenarioGenerators.jl Hull White Model\")\n\n# plot the zero rates\nfor d in curves\n    plot!(p,times,rate.(zero.(d,times)),alpha=0.2,label=\"\")\nend\n\nplot!(times,rate.(zero.(curve,times)),line=(:black, 5), label=\"Given Yield Curve\")\np\n    ","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: image)","category":"page"},{"location":"#Equity-Model-Examples","page":"Home","title":"Equity Model Examples","text":"","category":"section"},{"location":"#BlackScholesMerton","page":"Home","title":"BlackScholesMerton","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"m = BlackScholesMerton(0.01,0.02,.15,100.)\n\ns = ScenarioGenerator(\n               1,  # timestep\n               30, # projection horizon\n               m,  # model\n           )","category":"page"},{"location":"","page":"Home","title":"Home","text":"Instantiate an array of the projection with collect(s).","category":"page"},{"location":"#Plotted-BSM-Example","page":"Home","title":"Plotted BSM Example","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Plot 100 paths:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Plots\nprojections = [collect(s) for _ in 1:100]\n\np = plot()\n\nfor p in projections\n    plot!(0:30,p,label=\"\",alpha=0.5)\nend\n\np","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: BSM Paths)","category":"page"},{"location":"#Correlated-Scenarios","page":"Home","title":"Correlated Scenarios","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Combined with using Copulas, you can create correlated scenarios with a given copula. See ?Correlated for the docstring on creating a correlated set of scenario generators.","category":"page"},{"location":"#Example","page":"Home","title":"Example","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Create two equity paths that are 90% correlated:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using EconomicScenarioGenerators, Copulas\n\nm = BlackScholesMerton(0.01,0.02,.15,100.)\ns = ScenarioGenerator(\n                      1,  # timestep\n                      30, # projection horizon\n                      m,  # model\n                  )\n\nss = [s,s] # these don't have to be the exact same, but do need same shape\ng = ClaytonCopula(2,7) # highly dependendant model\nc = Correlated(ss,g)\n\nx = collect(c) # an array of tuples\n\nusing Plots\n\n# get the 1st/2nd value from the scenario points\nplot(getindex.(x,1))\nplot!(getindex.(x,2))","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: plot_20)","category":"page"},{"location":"#Other-ESG-packages","page":"Home","title":"Other ESG packages","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Python\nhttps://github.com/jason-ash/pyesg","category":"page"},{"location":"API/","page":"API","title":"API","text":"Modules = [EconomicScenarioGenerators]","category":"page"},{"location":"API/#EconomicScenarioGenerators.BlackScholesMerton","page":"API","title":"EconomicScenarioGenerators.BlackScholesMerton","text":"BlackScholesMerton(r,q,σ,initial)\n\nAn equity price model where initial is the initial value of the security.\n\nr is the risk free rate\nq is the dividend yield\nσ is the volatility for the unit period\n\nExample\n\njulia> m = BlackScholesMerton(0.01,0.02,.15,100.)\nBlackScholesMerton{Float64, Float64, Float64}(0.01, 0.02, 0.15, 100.0)\n\njulia> s = ScenarioGenerator(1/252,1.,m,Random.Xoshiro(123))\nScenarioGenerator{Float64, BlackScholesMerton{Float64, Float64, Float64}, Xoshiro}(0.003968253968253968, 1.0, BlackScholesMerton{Float64, Float64, Float64}(0.01, 0.02, 0.15, 100.0), Xoshiro(0xfefa8d41b8f5dca5, 0xf80cc98e147960c1, 0x20e2ccc17662fc1d, 0xea7a7dcb2e787c01))\n\njulia> collect(s)\n253-element Vector{Float64}:\n 100.0\n  99.38331866043562\n  98.01039338118557\n   ⋮\n  88.57032295705861\n  88.40149667285587\n\n\n\n\n\n","category":"type"},{"location":"API/#EconomicScenarioGenerators.ConstantElasticityofVariance","page":"API","title":"EconomicScenarioGenerators.ConstantElasticityofVariance","text":"ConstantElasticityofVariance(r,q,σ,β,initial)\n\nWhere initial is the initial value of the security.\n\n\n\n\n\n","category":"type"},{"location":"API/#EconomicScenarioGenerators.Correlated","page":"API","title":"EconomicScenarioGenerators.Correlated","text":"Correlated(v::Vector{ScenarioGenerator},copula,RNG::AbstractRNG)\n\nAn iterator which uses the given copula to correlate the outcomes of the underling ScenarioGenerators. The copula returns the sampled CDF which the individual models will interpret according to their own logic (e.g. the random variate for the BlackScholesMerton model assumes a normal variate within the diffusion process).\n\nThe time and timestep of the underlying ScenarioGenerators are asserted to be the same upon construction.\n\nA Correlated can be iterated or collected. It will iterate through each sub-scenario generator and yield the time series of each (as opposed to iterating through each timestep for all models at each step).\n\nExamples\n\nusing EconomicScenarioGenerators, Copulas\n\nm = BlackScholesMerton(0.01,0.02,.15,100.)\ns = ScenarioGenerator(\n                      1,  # timestep\n                      30, # projection horizon\n                      m,  # model\n                  )\n\nss = [s,s] # these don't have to be the exact same\ng = ClaytonCopula(2,7)\nc = Correlated(ss,g)\n\n# collect a vector of two correlated paths.\ncollect(c)\n\n\n\n\n\n","category":"type"},{"location":"API/#EconomicScenarioGenerators.CoxIngersollRoss","page":"API","title":"EconomicScenarioGenerators.CoxIngersollRoss","text":"CoxIngersollRoss(a,b,σ,initial::FinanceCore.Rate)\n\nA one-factor interest rate model. Parameters:\n\n- `a` characterizes the speed of mean reversion\n- `b` is the long term mean level\n- `σ` is the instantaneous volatility\n\nVia Wikipedia: https://en.wikipedia.org/wiki/Cox%E2%80%93Ingersoll%E2%80%93Ross_model\n\nCan be reinterpreted as a yield curve from Yields.jl with YieldCurve(s::ScenarioGenerator)\n\nExample\n\n\njulia> m = CoxIngersollRoss(0.136,0.0168,0.0119,Yields.Continuous(0.01))\nCoxIngersollRoss{FinanceCore.Rate{Float64, Continuous}}(0.136, 0.0168, 0.0119, FinanceCore.Rate{Float64, Continuous}(0.01, Continuous()))\n\njulia> s = EconomicScenarioGenerators.ScenarioGenerator(\n           0.5,                              # timestep\n           30.,                             # projection horizon\n           m\n       );\n\n       julia> collect(s)\n       61-element Vector{FinanceCore.Rate{Float64, Continuous}}:\n        FinanceCore.Rate{Float64, Continuous}(0.01, Continuous())\n        FinanceCore.Rate{Float64, Continuous}(0.010355508443426625, Continuous())\n        ⋮\n        FinanceCore.Rate{Float64, Continuous}(0.01170589378629289, Continuous())\n\njulia> YieldCurve(s)\n\n        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Yield Curve (Yields.BootstrapCurve)⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀           \n        ┌────────────────────────────────────────────────────────────┐           \n  0.018 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ Zero rates\n        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠒⠒⠒⠒⠦⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡤⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠢⢄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠓⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒│           \n        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠔⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \nContinuous │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡠⠤⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠀⠀⠀⠀⠀⠀⠀⢀⡤⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠀⠀⠀⠀⠀⢀⡔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠀⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠀⠀⠀⢀⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠀⠀⢠⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        │⠢⠔⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n  0.009 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n        └────────────────────────────────────────────────────────────┘           \n        ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀time⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀30⠀           \n\n\n\n\n\n","category":"type"},{"location":"API/#EconomicScenarioGenerators.HullWhite","page":"API","title":"EconomicScenarioGenerators.HullWhite","text":"HullWhite(a,σ,curve::Yields.AbstractYield)\n\nAn interest model that should be market consistent with the given curve.\n\nVia Wikipedia: https://en.wikipedia.org/wiki/Hull%E2%80%93White_model\n\n\n\n\n\n","category":"type"},{"location":"API/#EconomicScenarioGenerators.ScenarioGenerator","page":"API","title":"EconomicScenarioGenerators.ScenarioGenerator","text":"ScenarioGenerator(timestep::M,endtime::N,model,RNG::AbstractRNG) where {M<:Real, N<:Real}\n\nA ScenarioGenerator is an iterator which yields the time series of the model. It takes the parameters of the scenario generation such as timestep and endtime (the time horizon). model is any EconomicModel from the EconomicScenarioGenerators package.\n\nA ScenarioGenerator can be iterated or collected. \n\nExamples\n\nm = Vasicek(0.136,0.0168,0.0119,Continuous(0.01)) # a, b, σ, initial Rate\ns = ScenarioGenerator(\n        1,  # timestep\n        30, # projection horizon\n        m,  # model\n    )\n\n\n\n\n\n","category":"type"},{"location":"API/#EconomicScenarioGenerators.Vasicek","page":"API","title":"EconomicScenarioGenerators.Vasicek","text":"Vasicek(a,b,σ,initial::FinanceCore.Rate)\n\nA one-factor interest rate model. Parameters:\n\na characterizes the speed of mean reversion\nb is the long term mean level\nσ is the instantaneous volatility\n\nSee more on Wikipedia: https://en.wikipedia.org/wiki/Vasicek_model\n\nCan be reinterpreted as a yield curve from Yields.jl with YieldCurve(s::ScenarioGenerator)\n\nExample\n\n\njulia> m = Vasicek(0.136,0.0168,0.0119,Yields.Continuous(0.01))\nVasicek{FinanceCore.Rate{Float64, Continuous}}(0.136, 0.0168, 0.0119, FinanceCore.Rate{Float64, Continuous}(0.01, Continuous()))\n\njulia> s = EconomicScenarioGenerators.ScenarioGenerator(\n           0.5,                              # timestep\n           30.,                             # projection horizon\n           m\n       );\n\njulia> collect(s)\n61-element Vector{FinanceCore.Rate{Float64, Continuous}}:\n FinanceCore.Rate{Float64, Continuous}(0.01, Continuous())\n FinanceCore.Rate{Float64, Continuous}(0.010455802777823464, Continuous())\n ⋮\n FinanceCore.Rate{Float64, Continuous}(-0.0027467625238898194, Continuous())\n\n julia> YieldCurve(s)\n\n              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Yield Curve (Yields.BootstrapCurve)⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀           \n              ┌────────────────────────────────────────────────────────────┐           \n         0.03 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ Zero rates\n              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠤⠤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠖⠒⠒⠒⠋⠉⠉⠉⠉│           \n              │⠀⠀⠀⠀⠀⠀⠀⡠⠒⠒⠒⠒⠒⠒⠒⠒⠢⠤⠤⠊⠁⠀⠀⠀⠀⠀⠉⠑⠢⣄⣀⡠⠤⠤⠤⠤⠖⠊⠉⠁⠀⠉⠉⠑⠒⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⠀⠀⡜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n   Continuous │⠀⠀⠀⠀⠀⡸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⣀⣀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n            0 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│           \n              └────────────────────────────────────────────────────────────┘           \n              ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀time⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀30⠀        \n\n\n\n\n\n","category":"type"}]
}
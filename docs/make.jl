using EconomicScenarioGenerators
using Documenter

DocMeta.setdocmeta!(EconomicScenarioGenerators, :DocTestSetup, :(using EconomicScenarioGenerators); recursive=true)

makedocs(;
    modules=[EconomicScenarioGenerators],
    authors="Alec Loudenback <alecloudenback@gmail.com> and contributors",
    repo="https://github.com/JuliaActuary/EconomicScenarioGenerators.jl/blob/{commit}{path}#{line}",
    sitename="EconomicScenarioGenerators.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaActuary.github.io/EconomicScenarioGenerators.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaActuary/EconomicScenarioGenerators.jl",
    devbranch="main",
)

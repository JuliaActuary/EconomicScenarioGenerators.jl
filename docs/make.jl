using ESG
using Documenter

DocMeta.setdocmeta!(ESG, :DocTestSetup, :(using ESG); recursive=true)

makedocs(;
    modules=[ESG],
    authors="Alec Loudenback <alecloudenback@gmail.com> and contributors",
    repo="https://github.com/alecloudenback/ESG.jl/blob/{commit}{path}#{line}",
    sitename="ESG.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://alecloudenback.github.io/ESG.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/alecloudenback/ESG.jl",
    devbranch="main",
)

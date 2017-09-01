push!(LOAD_PATH,"../src/")

using Documenter, LabConnections
# makedocs()
# deploydocs(
# deps   = Deps.pip("pygments", "mkdocs", "python-markdown-math", "mkdocs-cinder"),
# repo   = "gitlab.control.lth.se/processes/LabProcesses.jl",
# branch = "gh-pages",
# julia  = "0.6",
# osname = "linux"
# )

makedocs(
    format = :html,
    sitename = "LabConnections",
    pages = [
        "index.md",
        "installation.md",
        "systemConfiguration.md",
    ]
)

deploydocs(
    repo   = "gitlab.control.lth.se/labdev/LabConnections.jl.git",
    target = "build",
    deps   = nothing,
    make   = nothing
)

push!(LOAD_PATH,"../src/")
println(LOAD_PATH)
using Documenter, LabConnections, DocumenterMarkdown

makedocs(modules=[LabConnections],format=Markdown(),sitename="LabConnections")

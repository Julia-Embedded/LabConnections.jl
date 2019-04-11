## Package Development

### LabConnections.jl Development

If you want to develop the code in LabConnections.jl, then this is how you setup a development environment. First, open up a Julia REPL and type
```
] dev https://gitlab.control.lth.se/labdev/LabConnections.jl
```
Open a new terminal and navigate to `.julia/dev/LabConnections`, where the package source code is now located. Then type
```
git checkout julia1
git pull
```
to ensure that you are working on the correct development branch for Julia v1.0.X.

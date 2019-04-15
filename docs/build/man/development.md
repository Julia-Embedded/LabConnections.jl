
<a id='Package-Development-1'></a>

# Package Development


<a id='Development-environment-1'></a>

## Development environment


If you want to develop the code in LabConnections.jl, then this is how you setup a development environment. First, open up a Julia REPL and type


```
] dev https://gitlab.control.lth.se/labdev/LabConnections.jl
```


Open a new terminal and navigate to `.julia/dev/LabConnections`, where the package source code is now located. Then type


```
git checkout julia1
git pull
```


to ensure that you are working on the correct development branch for Julia v1.0.X. You can now edit the code in `.julia/dev/LabConnections` and run it using a Julia REPL. When you are satisfied with your changes, simply commit and push the changes in the `.julia/dev/LabConnections` directory to the GitLab server.


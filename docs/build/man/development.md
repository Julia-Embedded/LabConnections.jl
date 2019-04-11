
<a id='Package-Development-1'></a>

## Package Development


<a id='LabConnections.jl-Development-1'></a>

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


<a id='SPI-Development-1'></a>

### SPI Development


If you plan on working with the SPI devices to debug the ADC/DAC, then you will need a forked `serbus` repository which wraps the`linux/spi/spidev`. Simply


```
`cd && cd .julia/v0.6'
`git clone https://github.com/mgreiff/serbus'
```


to get the latest revision of the serbus fork.


[![pipeline status](https://gitlab.control.lth.se/labdev/LabConnections.jl/badges/master/pipeline.svg)](https://gitlab.control.lth.se/labdev/LabConnections.jl/commits/master)
[![coverage report](https://gitlab.control.lth.se/labdev/LabConnections.jl/badges/master/coverage.svg)](https://gitlab.control.lth.se/labdev/LabConnections.jl/commits/master)

Documentation available at [Documentation](https://gitlab.control.lth.se/labdev/LabConnections.jl/blob/master/docs/build/index.html)

# OBS!
If you wish to work on the SPI implementation, simply clone the repository
"serbus", a small C stack available at `github.com/mgreiff/serbus` into your
julia package directory (for example "~/.julia/v0.6"). Then, in the
LabConnections package on the host computer, run `flash_BB.sh` in the "/utils"
directory transferring both LabCOnnections and serbus to the BB.

On the BB, run

  cp /home/debian/juliapackages/serbus/bb_spi.sh /home/debian

and then execute
  
  ./bb_spi.sh

in the `/home/debian` directory to run the SPI example with the ADC from SPI0.

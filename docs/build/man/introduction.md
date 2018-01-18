<a id='Introduction-1'></a>

# Introduction


<a id='Installation-1'></a>

## Installation

## Future Work

### SPI Development
The SPI development is done in C and in a forked repository, currently
separated from the julia project. If you wish to work on the SPI implementation,
simply clone the repository "serbus", a small C stack available at
`github.com/mgreiff/serbus` into your julia package directory (for example
`~/.julia/v0.6`). Then, in the LabConnections package on the host computer, run
`flash_BB.sh` in the `/utils` directory transferring both LabConnections and
serbus to the BB.

On the BB, run

    cp /home/debian/juliapackages/serbus/bb_spi.sh /home/debian

and then execute

    ./bb_spi.sh

in the `/home/debian` directory to run the SPI example with the ADC from SPI0.


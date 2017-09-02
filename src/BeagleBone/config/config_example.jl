include("config_library.jl")

####################### Example script #######################
# Read a configuration from a specified file
print("Reading YAML file...\n\n")
configuration = YAML.load(open("example_configuration.yml"))

# Load configuration and
# 1) Assert consistency of the specified yml file
# 2) Instantiate the component types
# 3) Set up the file system enabling each component (export using setup)
# 4) Open component specific IOStream objects stored in IO_Object.file_handles
# 5) Store objects in a list where they are accessed as
print("Loading configuration...\n\n")
IO_Objects = load_configuration(configuration)

# Now pins may be read and written to by the simple command
ID = 7         # A specific unique integer ID assigned to each component (HERE ADC channel 0)
operation = 1  # An operation specific to each component
print("\n\nRunning example...\n\n")
write(IO_Objects[ID].file_handles[operation], "Hello world");

# Retreiving the handle by accessing known elements in two small arrays (fast)
# and the operation is designed to acces a specific file of a specific pin, where
# for instance in the PWM pins (here ID = {5,6} as specified in the
#example_configuration yaml file) we could have
#
# operation ||     explanation
# =========================================
#     1     || read/write duty cycle
#     2     || read/write carrier frequency
#     3     || read/write polariy
#     4     || read/write enable

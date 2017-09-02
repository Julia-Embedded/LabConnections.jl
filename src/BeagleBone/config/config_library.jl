import YAML

abstract type IO_Object end

type GPIO <: IO_Object
    ID::Int32
    pins::Array{String, 1}
    InOut::String
    file_handles::Array{IOStream}
end
GPIO(ID, pins, InOut; file_handles=[])=GPIO(ID, pins, InOut, file_handles)

# The PWM type
type PWM <: IO_Object
    ID::Int32
    pins::Array{String, 1}
    file_handles::Array{IOStream}
end
PWM(ID, pins; file_handles=[])=PWM(ID, pins, file_handles)

# The analog to digital converter type
type ADC <: IO_Object
    ID::Int32
    pins::Array{String, 1}
    channel::String
    file_handles::Array{IOStream,}
end
ADC(ID, pins, channel; file_handles=[])=ADC(ID, pins, channel, file_handles)

# The quadrature encoder type
type QEP <: IO_Object
    ID::Int32
    pins::Array{String, 1}
    file_handles::Array{IOStream}
end
QEP(ID, pins; file_handles=[])=QEP(ID, pins, file_handles)

function to_log(log::String, entry)
    return string(log, " * ", entry, "\n")
end

"""
    This function loads a specified configuration. If the configuration
    passes the assetion, an array of IO objects are ccreated. In doing so,
    each object in the configuration is

        (1) Exported - such that the necessary filesystem is created. This is
            done using the setup(device) method, which needs to be written for
            each component independently.
        (2) Opened - The file objects are opened for each object, allowing
            fast reding and writing by simply finding the object in an array
            where it is identitfied by an internal identifier.

    Once the IO_Objects list has been created, each component may be accessed by
    direct reference with

        write(IO_Objects[ID].file_handles[INDEX], ENTRY)

    or

        read(IO_Objects[ID].file_handles[INDEX])

    which may be done directly from the stream
"""
function load_configuration(configuration::Dict)

    # Check if the configuration is consistent, if not return empty list
    flag, log = assert_configuration(configuration)
    if !flag
        return []
    end

    # Iterate over all configured objects and find the maximum id
    maxID = 0
    for component in keys(configuration)
        for element in configuration[component]
            if element["ID_internal"] > maxID
                maxID = element["ID_internal"]
            end
        end
    end

    # This list contains objects with open files for fast IO manipulation
    IO_Objects = Array{IO_Object}(1,maxID)

    # Populate IO_Object array
    for component in keys(configuration)
        for element in configuration[component]
            id = element["ID_internal"]
            pins = element["Location"]

            if component == "gpio"
                InOut = element["Setting"]
                object = GPIO(id, pins, InOut)
            elseif component == "pwm"
                object = PWM(id, pins)
            elseif component == "adc"
                channel = element["Setting"]
                object = ADC(id, pins, channel)
            elseif component == "qep"
                object = QEP(id, pins)
            end

            # This sets up the specific object, expoting the filesystem
            setup(object)

            # Adds the object to the IO_Objects array
            IO_Objects[id] = object
        end
    end
    return IO_Objects
end

function assert_configuration(configuration::Dict)
    log = ""
    interface = YAML.load(open("pins.yml"))

    # Check that the file contains keys
    if isempty(keys(configuration))
        return false, log
    end

    # Check validity of keys
    taken_pins = []
    taken_SPI_pins = []
    taken_internal_ids = []
    for component in keys(configuration)
        if component in ["gpio", "pwm", "qep"]
            ############# Check GPIOs #############
            for element in configuration[component]
                # Check thet the
                pins = element["Location"]
                id = element["ID_internal"]
                for pin in pins
                    if !(pin in keys(interface["available_pins"]["gpio"]))
                        log = to_log(log, "The pin $pin is not supported for $component functionality")
                    end
                    if pin in taken_pins
                        log = to_log(log, "The pin $pin has been defined for multiple uses")
                    end
                end
                if id in taken_internal_ids
                    log = to_log(log, "The internal ID $id has been defined for multiple uses")
                end
                append!(taken_pins, pins)
                append!(taken_internal_ids, [id])
            end
        elseif component == "adc"
            #Check ADCs
        else
            log = to_log("The componenet $component is not supported")
        end
    end
    return isempty(log), log
end

function setup(object::GPIO)
    id = object.ID
    print("Setup GPIO with ID=$id\n")

    # TODO: Export filesystem

    # TODO: Find the correct directory, currently opens dummy file
    filename = "testfile.txt"

    # Open IOStream object
    print("Open IOStream A")
    object.file_handles = [open(filename, "r+")]
end

function setup(object::PWM)
    id = object.ID
    print("Setup PWM with ID=$id\n")

    # TODO: Export filesystem

    # TODO: Find the correct directory, currently opens dummy file
    filename = "testfile.txt"

    # Open IOStream object
    print("Open IOStream for PWM with ID=$id\n")
    object.file_handles = [open(filename, "r+")]
end

function setup(object::ADC)
    id = object.ID
    print("Setup ADC with ID=$id\n")

    # TODO: Export filesystem

    # TODO: Find the correct directory, currently opens dummy file
    filename = "testfile.txt"

    # Open IOStream object
    print("Open IOStream for ADC with ID=$id\n")
    object.file_handles = [open(filename, "r+")]
end

function setup(object::QEP)
    id = object.ID
    print("Setup QEP with ID=$id\n")

    # TODO: Export filesystem

    # TODO: Find the correct directory, currently opens dummy file
    filename = "testfile.txt"

    # Open IOStream object
    print("Open IOStream for QEP with ID=$id\n")
    object.file_handles = [open(filename, "r+")]
end

# Command line consistency functionality can be enabled
if false
    if !isempty(ARGS)
        filename = ARGS[1]
        if isfile(filename)
            print("\nLoading configuration file...\n")
            data = YAML.load(open(filename))
            print("Running consistency checks...\n")
            flag, log = assert_configuration(data)
            if flag
                print("\nAll checks passed!\n")
            else
                print("\n", log)
                print("\nSome checks failed!\n")
            end
        else
            error("Invalid filename provided")
        end
    else
        error("No input file provided")
    end
end

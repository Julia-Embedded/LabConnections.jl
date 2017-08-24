"""
    Debug
Type for debugging and precompile
"""

type Debug
end
write!(::Debug, ind::Int32, val, debug::Bool=false) = nothing
read(::Debug, ind::Int32, debug::Bool=false) = -1

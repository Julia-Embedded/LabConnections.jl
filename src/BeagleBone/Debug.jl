"""
    Debug(i::Int32)
Type for debugging and precompile.
"""
type Debug <: IO_Object
    i::Int32
end
write!(::Debug, val, debug::Bool=false) = nothing
read(::Debug, debug::Bool=false) = -1
teardown(::Debug, debug::Bool=false) = nothing

module ModelingToolkitDeriv

using ModelingToolkit
using DataStructures
include("types.jl")
include("calculus.jl")

Base.:^(x::Union{Variable, Operation}, y::Int) = Operation(^, [x, y])

export D

end


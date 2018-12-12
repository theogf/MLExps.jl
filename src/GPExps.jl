"""
    Module to handle Machine Learning experiments in general
"""
module GPExps

using JSON
using DataFrames
using Plots
using Interact, Blink

include("workspace.jl")
include("config.jl")
include("init.jl")
include("train.jl")

end # module

"""
    Module to handle Machine Learning experiments in general
"""
module GPExps

using JSON
using DataFrames
using Plots
using Interact, Blink
using CSV, HDF5
using Random

include("workspace.jl")
include("config.jl")
include("init.jl")
include("train.jl")

end # module

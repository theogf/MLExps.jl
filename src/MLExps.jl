"""
    Module to handle Machine Learning experiments in general
"""
module MLExps

using JSON
using DataFrames
using Plots
using Interact, Blink
using CSV, HDF5
using Random
import Base.convert, Base.show

include("types.jl")
include("workspace.jl")
include("config.jl")
include("data_process.jl")
include("results_process.jl")

end # module

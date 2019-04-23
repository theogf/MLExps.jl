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

export Workspace, ExpConfig
export write_config, load_config
export create_template_config, gui_config_file

include("types.jl")
include("workspace.jl")
include("config.jl")
include("gui_config.jl")
include("data_process.jl")
include("results_process.jl")

end # module

"""
    Module to handle Machine Learning experiments in general
"""
module MLExps

using JSON
using DrWatson
using DataFrames
using Plots
using Interact, Blink
using CSV, HDF5
using Random
import Base.convert, Base.show

export create_template_config, edit_template_config, gui_config_file

include("types.jl")
include("fields_gui.jl")
include("config_gui.jl")
include("template_gui.jl")
end # module

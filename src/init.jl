"""
Template file for `init.jl`
"""


### This function should return a collection of models Dict{String,Model} and a ExpData objrct

function init(w::Workspace, θ::ExpConfig)
    models = Dict{String,Model}()
    ### Create the models given the parameters in θ here and add them to models
    return models,ExpData()
end

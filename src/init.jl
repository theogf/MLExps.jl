"""
Template file for `init.jl`
"""


### This function should return a collection of models Dict{String,Model} and a ExpData objrct

function init(w::Workspace, θ::ExpConfig)
    models = Dict{String,Model}()
    ### Create the models given the parameters in θ here and add them to models
    return models,ExpData()
end


"""Make every model type inherit from Model"""
abstract type myAbstractModel <: Model end

"""And construct custom wrappers for your actual models inside"""
mutable struct myCustomModel <: myAbstractModel
    field1::Any
    field2::Any
end

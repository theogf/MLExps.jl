struct Workspace
    dir::String
    name::String
    init::String
end

abstract type ExpData end

mutable struct X_Y <: ExpData
    X::AbstractArray
    Y::AbstractArray
end

mutable struct Data <:ExpData
    data::AbstractArray
end

mutable struct Train_Test <: ExpData
    train::AbstractArray
    test::AbstractArray
end

mutable struct X_Y_Train_Test <: ExpData
    X_train::AbstractArray
    X_test::AbstractArray
    Y_train::AbstractArray
    Y_test::AbstractArray
end

"""Type"""
mutable struct ExpResults
    data::Dict{Any,DataFrame}
    function ExpResults()
        return ExpResults(Dict{Any,DataFrame}())
    end
end

"""Abstract type from which all models should be derived from"""
abstract type Model end

"""Type containing the directory and file name of a config file as well as the parameters from this file"""
struct ExpConfig
    dir::String
    file::String
    config::Dict
end

struct ParamField{T}
    name::String
    default::Any
    options::Any
end

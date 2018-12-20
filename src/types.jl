struct Workspace
    dir::String
    name::String
    init::String
end

mutable struct ExpData
    data::Vector{DataFrame}
    function ExpData()
        return ExpData(Vector{DataFrame}())
    end
end

mutable struct ExpResults
    data::Dict{Any,DataFrame}
    function ExpResults()
        return ExpResults(Dict{Any,DataFrame}())
    end
end

abstract type Model end


struct ExpConfig
    dir::String
    file::String
    config::Dict
end

struct ExpParameters
    name::String
    val::Dict{Symbol,Any}
end

struct ParamField
    name::String
    fieldtype::DataType
    options::Any
end

function add_new_field(text_in::String,fields_array::Vector{ParamField})
    println(typeof(text_in))
    # @assert occursin(",",String(text_in)) "Wrong formulation you forgot ','"
    # @assert occursin(":",text_in) "Wrong formulation you forgot ':'"
    coma_index = findfirst(",",text_in)[1]
    field_name = replace(text_in[1:coma_index-1]," "=>"") #Get field name and remove spaces
    column_index = findfirst(":",text_in)[1]
    field_type = replace(text_in[coma_index+1:column_index-1]," "=>"")
    sc_index = column_index+1
    options = Vector()
    while sc_index<length(text_in)
        newsc_index = findfirst(";",text_in[sc_index+1:end])
        if newsc_index!=nothing
            newsc_index = newsc_index[1]
        else
            break
        end
        push!(options,text_in[sc_index+1:newsc_index-1])
        sc_index = newsc_index
    end
    ft= []; params = []
    if field_type == "Integer" || field_type == "Int"
        ft = Integer
        for opt in options
            push!(params,parse(Int,opt))
        end
    elseif field_type == "Bool"
        ft = Bool
        params = parse(Bool,options[1])
    elseif field_type == "Dict"
        ft = Dict
        params = copy(options)
    elseif field_type == "Float" || field_type == "Float64"
        ft = Float64
        for opt in options
            push!(params,parse(Float64,opt))
        end
    end
    new_field = ParamField(field_name,ft,params)
    push!(fields_array,new_field)
end

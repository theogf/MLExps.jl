"""
Function to create and load config files
"""

cd(dirname(@__FILE__))

Base.convert(s::String,e::ExpConfig) = ExpConfig(s)

function load_config(config::ExpConfig)
    try
        dict_params = JSON.parse(read(config.dir*"/"*config.file*".json",String))
        return ExpConfig(config.dir,config.file,dict_params)
    catch e
        @error "Parsing failed, wrong directory or type of file"
    end
end

function write_config(w::Workspace,d::Dict,dir::String,name::String)
    write_config(w,ExpConfig(dir,name,d))
end


function write_config(w::Workspace,config::ExpConfig)
    isdir(config.dir) ? nothing : mkdir(config.dir)
    open(config.dir*"/"*config.file*".json","w") do f
        write(f,json(config.config))
    end
end

function write_config_gui()
    w = Window();
    title(w,"Config file setup")
    widgetlist = Vector{Widget}()
    handle(w,"add") do args
        add_new_field(widgetlist,args)
        update_window(w,widgetlist)
    end
end

function set_config_gui()

end

function update_window!(w::Window,fields::Vector{ParamField})
    new_field_box = create_new_fieldbox(w,fields)
    col_opts = []
    for f in fields
        push!(col_opts,create_box(f))
    end
    file_option = filepicker()
    # validate_button = create_validation_box()
    body!(w,vbox(new_field_box,col_opts...,file_option))
end

function create_box(f::ParamField{<:Int})
    rangeslide(f.options[1]:f.options[2],value=f.options[3],label=f.name)
end

function create_box(f::ParamField{Bool})
    checkbox(f.default,label=f.name)
end

function create_box(f::ParamField{<:Dict})
    opts = []
    for o in f.options
        push!(opts,toggle(true,label=o))
    end
    return vbox(opts)
end

function create_box(f::ParamField{<:Real})
    spinbox((f.options[1],f.options[2]),label=f.name)
end

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

function write_template_config()
end

function create_new_fieldbox(w::Window,fields_array::Vector{ParamField})
    hinttext = Observable{Any}(dom"div"("Choose a type for your new field:"))
    typechoice = tabulator(OrderedDict("Bool"=>bool_fields(w,fields_array),"Int"=>int_fields(w,fields_array),"Float"=>float_fields(w,fields_array),"String"=>string_fields(fields_array),"Dict"=>dict_fields(fields_array),"Radio"=>radio_fields(fields_array)))
    # update_window!(w,fields_array)
    return vbox(hinttext,typechoice,dom"div"("Previously added parameters"))
end

function bool_fields(w,fields_array::Vector{ParamField})
    hinttext = dom"div"("Give a name and the default value of the field")
    fieldname = textbox("",label="Field Name")
    default  = checkbox(true,label="Default value is true")
    valid_button = button("Add new boolean field")
    on(x->begin; add_bool(fieldname[],default[],fields_array); update_window!(w,fields_array); end,valid_button)
    return vbox(hinttext,fieldname,default,valid_button)
end

function add_bool(name::String,default::Bool,fields_array::Vector{ParamField})
    push!(fields_array,ParamField{Bool}(name,default,nothing))
end

function int_fields(w,fields_array::Vector{ParamField})
    hinttext = dom"div"("Give a name, the default value and the limits (leave blank for Inf) of the field")
    fieldname = textbox("",label="Field Name")
    default = spinbox(0,label="Default value")
    lim_min = spinbox(-Inf,label="Minimum value")
    lim_max = spinbox(Inf,label="Maximum value")
    valid_button = button("Add new integer field")
    on(x->begin; add_int(fieldname[],isnothing(default[]) ? 0.0 : default[],isnothing(lim_min[]) ? -Inf : lim_min[], isnothing(lim_max[]) ? Inf : lim_max[],fields_array); update_window!(w,fields_array); end,valid_button)
    return vbox(hinttext,fieldname,default,lim_min,lim_max,valid_button)
end

function add_int(name::String,default::Real,lim_min::Real,lim_max::Real,fields_array::Vector{ParamField})
    push!(fields_array,ParamField{Int64}(name,floor(Int64,default),[Int64(lim_min),Int64(lim_max)]))
end
function float_fields(w,fields_array::Vector{ParamField})
    hinttext = dom"div"("Give a name, the default value and the limits (leave blank for Inf) of the field")
    fieldname = textbox("",label="Field Name")
    default = spinbox(0.0,label="Default value")
    lim_min = spinbox(-Inf,label="Minimum value")
    lim_max = spinbox(Inf,label="Maximum value")
    valid_button = button("Add new float field")
    on(x->begin; add_float(fieldname[],default[],lim_min[],lim_max[],fields_array); update_window!(w,fields_array); end,valid_button)
    return vbox(hinttext,fieldname,default,lim_min,lim_max,valid_button)
end

function add_float(name::String,default::Real,lim_min::Real,lim_max::Real,fields_array::Vector{ParamField})
    push!(fields_array,ParamField{Float64}(name,Float64(default),[Float64(lim_min),Float64(lim_max)]))
end

function string_fields(fields_array::Vector{ParamField})
    hinttext = dom"div"("Give a name and the default value of the field")
    fieldname = textbox("",label="Field Name")
    default  = textbox("",label="Default value")
    valid_button = button("Add new string field")
    on(x->add_bool(fieldname[],default[],fields_array),valid_button)
    return vbox(hinttext,fieldname,default,valid_button)
end

function dict_fields(fields_array::Vector{ParamField})
    hinttext = dom"div"("Give a name and the default value of the field")
    fieldname = textbox("",label="Field Name")
    default  = checkbox(true,label="Default value is true")
    valid_button = button("Add new boolean field")
    on(x->add_bool(fieldname[],default[],fields_array),valid_button)
    return vbox(hinttext,fieldname,default,valid_button)
end

function radio_fields(fields_array::Vector{ParamField})
    hinttext = dom"div"("Give a name and the default value of the field")
    fieldname = textbox("",label="Field Name")
    default  = textbox("",label="Default value")
    valid_button = button("Add new string field")
    on(x->add_bool(fieldname[],default[],fields_array),valid_button)
    return vbox(hinttext,fieldname,default,valid_button)
end

"""
Function to create and load config files
"""

struct ExpConfig
    dir::String
    file::String
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

function Base.show(io::IO,param::ExpParameters)
    println("ExpParameters object, $(param.name) with parameters $(param.val)")
end


Base.convert(s::String,e::ExpConfig) = ExpConfig(s)

function load_config(config::ExpConfig)
    try
        dict_params = JSON.parse(config.dir)
    catch e
        @error "Parsing failed, wrong directory or type of file"
    end
end


function write_config_gui()
    w = Window();
    title(w,"Config file setup")
    widgetlist = Vector{Widget}()
    handle(w,"add") do args
        add_new_field(widgetlist,args)
        update_win(w,widgetlist)
    end
end

function set_config_gui()

end

# function create_new_field()
using Blink,Interact


function update_window!(w::Window,fields::Vector{ParamField})
    new_field_box = create_new_fieldbox()
    col_opts = []
    for f in fields
        push!(col_opts,create_box(f))
    end
    file_option = filepicker()
    validate_button = create_validation_box()
end

function create_box(f::ParamField)
    if f.fieldtype == Integer
        return rangeslide(f.options[1]:f.options[2],value=f.options[3],label=f.name)
    elseif f.fieldtype == Bool
        return checkbox(f.options[1],label=f.name)
    elseif f.fieldtype == Dict
        opts = []
        for o in f.options
            push!(opts,toggle(true,label=o))
        end
        return vbox(opts)
    elseif f.fieldtype == Float64
        return spinbox((f.options[1],f.options[2]),label=f.name)
    end
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
    newfield = textbox("Format: new field,type: option1; option2;... or min;max")
    validate = button("Add new field")
    on(x->begin add_new_field(newfield[]); update_window!(w,fields_array); end,validate)
    return dom"div"("Format: new field,type: option1; option2;... or min;max",vbox(newfield,validate))
end

w = Window()
columnbuttons = Observable{Any}(dom"div"())
fields = Vector{ParamField}()
a = create_new_fieldbox(w,fields)
# on(x->begin add_new_field(newfield[]); update_window!(w,fields_array); end,validate)
# body!(w,vbox(newfield,validate))
body!(w,a)
ASDA, Int: 1;3;2

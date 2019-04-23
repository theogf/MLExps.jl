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

function update_list!(list::Observable,fields)
    list[] = create_boxes(fields)
    # map!(create_boxes,list,fields)
end

function create_boxes(fields)
    boxes = create_box.(fields)
    dom"div"(vbox(boxes))
end

function update_window!(w::Window,fields::Vector{ParamField},list)
    new_field_box = create_new_fieldbox(w,fields)
    sep = dom"div"("Previously added parameters")
    map!(create_boxes,list,fields)
    # col_opts = []
    # for f in fields
    #     push!(col_opts,create_box(f))
    # end
    # validate_button = create_validation_box()
    all_fields = vbox(new_field_box,sep,vbox(col_opts...),file_option)
    body!(w,all_fields)
end

function create_box(f::ParamField{Bool})
    checkbox(f.default,label=f.name)
end

function create_box(f::ParamField{<:Int})
    rangeslider(collect(f.options[1]:1:f.options[2]),value=f.default,label=f.name)
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

function write_template_config()
end

function create_new_fieldbox(fields::Vector{ParamField},list::Observable)
    title = dom"div.title"("Config file creator")
    hinttext = dom"div.subtitle"("Choose a type for your new field:")
    sep1 = Interact.hline()
    typechoice = tabulator(OrderedDict("Bool"=>bool_fields(fields,list),"Int"=>int_fields(fields,list),"Float"=>float_fields(fields,list),"String"=>string_fields(fields),"Dict"=>dict_fields(fields),"Radio"=>radio_fields(fields)))
    septext = dom"div.subtitle"("Current fields")

    sep2 = pad(1em,Interact.hline(w="3px"))

    # update_window!(w,fields_array)
    sep3 = pad(1em,Interact.hline(w="3px"))
    septext2 = dom"div.subtitle"("Save config template")
    file_option = filepicker()
    return vbox(title,hinttext,sep1,typechoice,sep2,septext,list,sep3,septext2,file_option)
end

function bool_fields(fields::Vector{ParamField},list::Observable)
    hinttext = dom"div"("Give a name and the default value of the field")
    fieldname = textbox("",label="Field Name")
    default  = checkbox(true,label="Default value is true")
    valid_button = button("Add new boolean field")
    on(x->begin; add_bool(fieldname[],default[],fields); update_list!(list,fields); end,valid_button)
    return vbox(hinttext,fieldname,default,valid_button)
end

function add_bool(name::String,default::Bool,fields::Vector{ParamField})
    push!(fields,ParamField{Bool}(name,default,nothing))
end

function int_fields(fields::Vector{ParamField},list::Observable)
    hinttext = dom"div"("Give a name, the default value and the limits (leave blank for Inf) of the field")
    fieldname = textbox("",label="Field Name")
    default = spinbox(0,label="Default value")
    lim_min = spinbox(-Inf,label="Minimum value")
    lim_max = spinbox(Inf,label="Maximum value")
    valid_button = button("Add new integer field")
    on(x->begin; add_int(fieldname[],isnothing(default[]) ? 0.0 : default[],isnothing(lim_min[]) ? -Inf : lim_min[], isnothing(lim_max[]) ? Inf : lim_max[],fields); update_list!(list,fields); end,valid_button)
    return vbox(hinttext,fieldname,default,lim_min,lim_max,valid_button)
end

function add_int(name::String,default::Real,lim_min::Real,lim_max::Real,fields_array::Vector{ParamField})
    push!(fields_array,ParamField{Int64}(name,floor(Int64,default),[Int64(lim_min),Int64(lim_max)]))
end
function float_fields(fields::Vector{ParamField},list::Observable)
    hinttext = dom"div"("Give a name, the default value and the limits (leave blank for Inf) of the field")
    fieldname = textbox("",label="Field Name")
    default = spinbox(0.0,label="Default value")
    lim_min = spinbox(-Inf,label="Minimum value")
    lim_max = spinbox(Inf,label="Maximum value")
    valid_button = button("Add new float field")
    on(x->begin; add_float(fieldname[],default[],lim_min[],lim_max[],fields); update_list!(list,fields); end,valid_button)
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

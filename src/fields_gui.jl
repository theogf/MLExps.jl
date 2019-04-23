function bool_fields(fields::Vector{ParamField},list::Observable)
    hinttext = dom"div"("Give a name and the default value of the field")
    fieldname = textbox("",label="Field Name")
    default  = checkbox(true,label="Default value is true")
    valid_button = button("Add new boolean field")
    on(x->begin; add_bool(fieldname[],default[],fields); update_list!(list,fields); end,valid_button)
    return vbox(hinttext,fieldname,default,valid_button)
end

function add_bool(name::String,default::Bool,fields::Vector{ParamField})
    push!(fields,ParamField{Bool}(name,default,nothing,Bool))
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
    push!(fields_array,ParamField{Int64}(name,floor(Int64,default),[Int64(lim_min),Int64(lim_max)],Int64))
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
    push!(fields_array,ParamField{Float64}(name,Float64(default),[Float64(lim_min),Float64(lim_max)],Float64))
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

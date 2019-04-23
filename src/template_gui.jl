function create_template_config()
    w = Window()
    fields = Vector{ParamField}()
    body!(w,template_fieldbox(fields))
    return fields
end

function edit_template_config(filepath::AbstractString)
    w = Window()
    fields = Vector{ParamField}()
    body!(w,template_fieldbox(fields))
    return fields
end


function template_fieldbox(fields::Vector{ParamField})
    list = Observable{Any}(dom"div"())
    title = dom"div.title"("Template config file creator")
    hinttext = dom"div.subtitle"("Choose a type for your new field:")
    line_title_addfield = Interact.hline()
    typechoice = tabulator(OrderedDict("Bool"=>bool_fields(fields,list),
                                        "Int"=>int_fields(fields,list),
                                        "Float"=>float_fields(fields,list),
                                        "String"=>string_fields(fields),
                                        "Dict"=>dict_fields(fields),
                                        "Radio"=>radio_fields(fields)))

    septext = dom"div.subtitle"("Current fields")

    line_new_current = pad(1em,Interact.hline(w="3px"))

    # update_window!(w,fields_array)
    line_current_save = pad(1em,Interact.hline(w="3px"))
    septext2 = dom"div.subtitle"("Save config template")
    file_option = savedialog(label="Save template")
    on(_->save_template(fields,file_option[]),file_option)
    return vbox(title,hinttext,line_title_addfield,typechoice,line_new_current,septext,list,line_current_save,septext2,file_option)
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




function update_list!(list::Observable,fields)
    list[] = create_boxes(fields)
end

function create_boxes(fields)
    boxes = create_box.(fields)
    dom"div"(vbox(boxes))
end

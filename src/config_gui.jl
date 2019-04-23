

function gui_config_file(filepath::String="")
    w = Window()
    fileselector = filepicker(label="Choose template file")
    if filepath != ""
        fileselector[] = filepath
    end
    valid_button = button(label="Load template file")
    fields_placeholder = Observable{Any}(dom"div"(""))
    on(_->open_template_file(fields_placeholder,fileselector[]),valid_button)
    body!(w,vbox(fileselector,valid_button,fields_placeholder))
end

function open_template_file(fields_placeholder::Observable,filepath::String="")
    fields = read_fields(filepath)
    field_boxes = create_box.(fields)
    savefile = savedialog(label="Save config file")
    on(_->write_config(fields,field_boxes,savefile[]),savefile)
    fields_placeholder[] = dom"div"(vbox(field_boxes...,savefile,savebutton))
end

function write_config(fields,field_boxes,savefile)
    d = Dict{String,Any}()
    for (field,fbox) in zip(fields,field_boxes)
        d[field.name] = fbox[]
    end
    open(savefile,"w") do f
        write(f,json(d))
    end
end

function read_fields(filepath::String)
    fields = Vector{ParamField}()
    dicts = JSON.parse(read(filepath,String))
    for d in dicts
        p = ParamField{eval(Meta.parse(d["type"]))}(d["name"],d["default"],d["options"],eval(Meta.parse(d["type"])))
        push!(fields,p)
    end
    return fields
end

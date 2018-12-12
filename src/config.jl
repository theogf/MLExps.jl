"""
Function to create and load config files
"""

struct ExpConfig
    dir::String
    file::String
end

struct ExpParameters
    name::String
    val::Dictionary{Symbol,Any}
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
w = Window()
columnbuttons = Observable{Any}(dom"div"())
newfield = textbox("Format: new field,type: option1; option2;... or min;max")
validate = button("Add new field")
a = dom"div"("Format: new field,type: option1; option2;... or min;max",vbox(newfield,validate))
on(x->add_new_field(newfield[]),validate)
# body!(w,vbox(newfield,validate))
body!(w,a)
# end

function add_new_field(text_in::String)
    @assert occursin(",",text_in) "Wrong formulation you forgot ','"
    @assert occursin(":",text_in) "Wrong formulation you forgot ':'"
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

end

function write_template_config()

end

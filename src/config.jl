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

function save_template(fields,filepath)
    open(filepath,"w") do f
        write(f,json(fields))
    end
end

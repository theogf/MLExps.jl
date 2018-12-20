""" Create a workspace with appropriate template files"""
function create_workspace(dir::String,name::String)
    #TODO Need to convert dir into a relative path to $HOME
    init = pwd()
    if !isdir(dir)
        try
            mkdir(dir)
            cd(dir)
            open("init.jl","w")
            open("train.jl","w")
            open(".workspace","w") do file
                write(file,json(Dict("workspace_name"=>name)))
            end
            open("README.md","w") do file
                write(file,"# Workspace for experiments $name")
            end
            mkdir("config"); cd("config")
            open("template_config.json","w") do file
                write(file,json(Dict("random_seed"=>rand(1:typemax(Int)))))
            end
            cd(dir)
        catch e
            @error "$dir is not valid, please reenter a valid directory : $e"
        end
    end
    println("Workspace $name was created in directory $dir\n You need now to configure `init.jl` and `train.jl` and the `template_config.json` file given your needs")
    return Workspace(dir,name,init)
end

"""Load the workspace in the given directory"""
function load_workspace(dir::String)
    init = pwd()
    try
        cd(dir)
        wparams = JSON.parse(read(".workspace",String))
        include("init.jl")
        include("train.jl")
        Workspace(dir,wparams["workspace_name"],init)
    catch e
        @error "$dir is not a valid workspace directory"
    end
end

"""Main function to be called to apply a config file on a workspace"""
function run_experiment(w::Workspace,config::ExpConfig;store::String="results")
    cd(w.dir)
    θ = load_config(config)
    Random.seed!(θ.params["random_seed"])
    global models,data = init(w,θ) #Coming from "init.jl"
    results = run!(w,θ,models,data)
    process!(w,θ,results)
    write_results(w,θ,results,store)
end

"""Run all models with data and parameters"""
function run!(w::Workspace,θ::ExpConfig,models::Dict{String,Model},data::ExpData)# Run each model given the data
    results = ExpResults()
    for (model_name,model) in models
        try
            run_model(model,model_name,θ,data,results) #Coming from "run.jl"
        catch e #Catch failure from model and
            @warn "Received error $e \n Run on model $model_name failed!"
        end
    end
end

function write_results(w::Workspace,θ::ExpConfig,results::ExpResults,store::String)
    cd(w.dir);cd(store);
    name = get_exp_name(θ)
    folders = readdir()
    i = 1
    while in(name*"_$i",folders)
        i+=1
    end
    mkdir(name*"_$i"); cd(name*"_$i")
    for (name,res) in results.data
        CSV.write(name*".csv",res)
    end
end

function plot_results(w::Workspace)
    cd(w.dir); cd("results");
    folders = readdir(".")
    println("Pick a folder to show")
    for (i,f) in enumerate(folders)
        println("$i. $f")
    end
    a = read(stdin,Integer)
    cd(folders[a])
    plot_time_exp(".")
    cd(w.dir)
end

function plot_time_exp(w::Workspace,dir::String)
    results = Vector{DataFrame}()
    all_names = Vector{Symbol}()
    field_plots = Dictionary{Symbol,Plot}()
    for file in readdir(dir)
        push!(results,CSV.read(file))
        for n in names(results[end])
            if !in(n,all_names)
                push!(all_names,n)
                field_plots[n] = plot()
            end
        end
    end
    for res in results
        t = res[:time]
        for field in names(res)
            if field != :time
                plot!(field_plots[field],t,res[field],yaxis=:log,xlabel="Time [s] (logscale)",ylabel=String(a))
            end
        end
    end
end

function plot_end_exp(w::Workspace,dir::String)
end

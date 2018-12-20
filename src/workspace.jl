struct Workspace
    dir::String
    name::String
    init::String
end


mutable struct ExpData
    data::Vector{DataFrames}
    function ExpData()
        return ExpData(Vector{DataFrames}())
    end
end

abstract type Model;

function create_workspace(dir::String,name::String)
    #TODO Need to convert dir into a relative path to $HOME
    init = pwd()
    if !isdir(dir)
        try
            mkdir(dir)
            cd(dir)
            open("init.jl","w")
            open("train.jl","w")
            open("$(name).md","w") do file
                write(file,"# $name Workspace readme file\n")
            end
        catch
            @error "$dir is not valid, please reenter a valid directory"
        end
    end
    println("Workspace $name was created in directory $dir with files `init.jl` and `train.jl`")
    return Workspace(dir,name,init)
end


function load_workspace(dir::String)
    init = pwd()
    try
        cd(dir)
        for file in readdir()
            if file[end-1:end] == "md"
                name = file[1:end-3]
            end
        end
        if !@isdefined(name)
            @error "No md file was found"
        end
        include("init.jl")
        include("train.jl")
        Workspace(dir,name,init)
    else
        @error "$dir is not a valid workspace directory"
    end
end


function run_experiment(w::Workspace,config::ExpConfig;store::String="results")
    cd(w.dir)
    θ = load_config(config)
    global models,data = init(w,θ) #COming from "init.jl"
    run!(w,θ,models,data)
    process!(w,θ,data)
    save(w,θ,data,store)
end


function run!(w::Workspace,θ::ExpConfig,models::Dict{String,Model},data::ExpData)
    for (model_name,model) in models
        try
            run_model(model,model_name,θ,data) #Coming from "run.jl"
        catch e #Catch failure from model and
            @warn "Received error $e \n Run on model $model_name failed!"
        end
    end
end

function save(w::Workspace,θ::ExpConfig,data::ExpData,store::String)
    cd(w.dir)
    cd(store)

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

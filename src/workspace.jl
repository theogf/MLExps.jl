include("config.jl")
using JSON


struct Workspace
    dir::String
    name::String
end

struct Model

end


struct ExpData

end

function create_workspace(dir::String,name::String)
    #TODO Need to convert dir into a relative path to $HOME
    if !isdir(dir)
        try
            mkdir(dir)
            cd(dir)
            open("init.jl","w")
            open("train.jl","w")
            open("$(name).md","w") do file
                write(file,"# $name Workspace readme file\n")
            end
            mkdir("src")
            mkdir("results")
            mkdir("config")
        catch
            @error "$dir is not valid, please reenter a valid directory"
        end
    else
        @warn "Directory already existing, adapting to the new space?"
        cd(dir)
        !isfile("init.jl") ? open("init.jl","w") : nothing
        !isfile("train.jl") ? open("train.jl","w") : nothing
        open("$(name).md","w") do file
            write(file,"# $name Workspace readme file\n")
        end
        !isdir("src") ? mkdir("src") : nothing
        !isdir("results") ? mkdir("results") : nothing
        !isdir("config") ?  mkdir("config") : nothing
    end
    println("Workspace $name was created in directory $dir with files `init.jl` and `train.jl`")
    return Workspace(dir,name)
end


function load_workspace(dir::String)
    try
        cd(dir)
        name=""
        for file in readdir()
            println(file)
            if file[end-1:end] == "md"
                name = file[1:end-3]
            end
        end
        if name==""
            @error "No md file was found"
        end
        include("init.jl")
        include("train.jl")
        return Workspace(dir,name)
    catch
        @error "$dir is not a valid workspace directory"
        cd("..")
    end
end


function run_experiment(w::Workspace,config::ExpConfig;store::String="results")
    cd(w.dir)
    θ = load_config(config)
    global models,data = init(w,θ)
    run!(w,θ,models,data)
    process!(w,θ,data)
    save(w,θ,data)
end

function init(w::Workspace,θ::ExpConfig)

end

function run!(w::Workspace,θ::ExpConfig,models::Vector{Model},data::ExpData)

end

function process(w::Workspace,θ::ExpConfig,data::ExpData)

end

function save(w::Workspace,θ::ExpConfig,data::ExpData)

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
end

function plot_time_exp(w::Workspace,dir::String)
    results = Vector{DataFrame}()
    max_col = 0
    ps = Dict{Symbol,Plots.Plot}()
    for file in readdir(dir)
        push!(results,CSV.read(file))
        max_col = maximum(max_col,length(names(results[end]))-1)
        for name in names(results[end])
            ps[name] = plot()
        end
    end
    for res in results
        for name in names(results[end])
            if name!=:time
                ps[name] = plot!(ps[name],res[:time],res[name])
            end
        end
    end
end

function plot_end_exp(w::Workspace,dir::String)

end


work = create_workspace("test_work","Test")

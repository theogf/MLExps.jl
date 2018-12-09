struct Workspace
    dir::String
    name::String
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
        catch
            @error "$dir is not valid, please reenter a valid directory"
        end
    end
    println("Workspace $name was created in directory $dir with files `init.jl` and `train.jl`")
    return Workspace(dir,name)
end


function load_workspace(dir::String)
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
        Workspace(dir,name)
    else
        @error "$dir is not a valid workspace directory"
    end
end


function run_experiment(w::Workspace,config::ExpConfig;store::String="results")
    cd(w.dir)
    θ = read_config(config)
    global models,data = init(w,θ)
    run!(w,θ,models,data)
    process(w,θ,data)
    save(w,θ,data)
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
    for file in readdir(dir)
        push!(results,CSV.read(file))
        results[end]
    end
    for res in results

    end
end

function plot_end_exp(w::Workspace,dir::String)
end


""" Load worked on data from a HDF5 file on `file` path, file should have a section `infos` informing about the status of the data
and a section `data` where data is either splitted in X,y and/or and test/train"""
function load_data(file::String)
    f = h5open(file)
    preprocess = f["infos/preprocessed"]
    shuffled = f["infos/shuffled"]
    traintestplit = f["infos/traintestsplit"]
    Xysplit = f["infos/Xysplit"]
    println("Loading "*(preprocessed ? "processed" : "")*" data from file $file")
    if traintestsplit
        if Xysplit
            return f["data/X_train"],f["data/y_train"],f["data/X_test"],f["data/y_test"]
        else
            return f["data/train"],f["data/test"]
        end
    else
        if Xysplit
            return f["data/X"],f["data/y"]
        else
            return f["data/data"]
        end
    end
end

function process_data(data::AbstractArray;normalize::Bool=false,shuffle::Bool=true)
    if normalize
        normalize_data!(data)
    end
    if shuffle
        shuffle_data!(data)
    end
end

function normalize_data!(data::AbstractArray)
    zscore!(data)
end

function shuffle_data!(data::AbstractArray)
    data = data[shuffle(1:length(data)),:]
end

function load_results(file::String)
    CSV.read(file)
end


function kfold(data::AbstractArray,nFold::Integer)
    n = size(data,1)
    n_sub = n÷nFold
    s = shuffle(1:n)
    i_train = Vector{Vector{Float64}}(undef,nFold)
    i_test = Vector{Vector{Float64}}(undef,nFold)
    i = 1
    [x[round(Int64, (i-1)*s)+1:min(length(x),round(Int64, i*s))] for i=1:n]
    while
        i_train[i] = s[(i-1)*n_sub+1:min(n,i*nsub)]
        i_test[i] = setdiff(s,i_train[i])
    end
    return i_train,i_test
end

function train_testsplit(data::AbstractArray,split::Float64)
    n = size(data,1)
    splitpoint = n÷split
    i_train = 1:splitpoint
    i_test = splitpoint+1:n
    return i_train, i_test
end

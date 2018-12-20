"""
Template file for `train.jl`
"""

"""There should be one run_model! function for each type of model"""
function run_model!(model,model_name::String,θ::ExpConfig,data::ExpData,results::ExpResults)
    ### DO THE TRAINING AND DATA COLLECTION HERE

    results[model_name] = nothing
end

# GPExps.jl

An all purpose package to run Gaussian Process Experiments, using config files
Each project has a defined workspace, with a `init.jl` file containing.

- `create_workspace(dir)` create a workspace in the given directory
- `load_workspace(dir)` return workspace object
- `show_config(config)`
- `run_experiment(workspace, config, store="results")` run experiments with `config` file and store results in store
- `plot_experiment()` show a quick visualization of the results

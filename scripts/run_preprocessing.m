function run_preprocessing()
%RUN_PREPROCESSING Run the preprocessing workflow from repository root.

repo_root = get_repo_root();
module_dir = fullfile(repo_root, 'pipeline', '01_preprocessing');
run_module_script(module_dir, 'preprocessing_pipeline.m', 'Preprocessing');
end

function repo_root = get_repo_root()
this_file = mfilename('fullpath');
scripts_dir = fileparts(this_file);
repo_root = fileparts(scripts_dir);
end

function run_module_script(module_dir, script_name, label)
script_path = fullfile(module_dir, script_name);
if ~isfile(script_path)
    error('%s script not found: %s', label, script_path);
end
orig_dir = pwd;
cleanup = onCleanup(@() cd(orig_dir)); %#ok<NASGU>
cd(module_dir);
fprintf('[RUN] %s -> %s\n', label, script_name);
evalin('base', sprintf("run('%s');", strrep(script_name, "'", "''")));
end

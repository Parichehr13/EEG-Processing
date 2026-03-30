function run_stage01()
%RUN_STAGE01 Run Stage 01 preprocessing script from repository root.

repo_root = get_repo_root();
stage_dir = fullfile(repo_root, '01_preprocessing');
run_stage_script(stage_dir, 'preprocessing_pipeline.m', 'Stage 01');
end

function repo_root = get_repo_root()
this_file = mfilename('fullpath');
scripts_dir = fileparts(this_file);
repo_root = fileparts(scripts_dir);
end

function run_stage_script(stage_dir, script_name, stage_label)
script_path = fullfile(stage_dir, script_name);
if ~isfile(script_path)
    error('%s script not found: %s', stage_label, script_path);
end
orig_dir = pwd;
cleanup = onCleanup(@() cd(orig_dir)); %#ok<NASGU>
cd(stage_dir);
fprintf('[RUN] %s -> %s\n', stage_label, script_name);
evalin('base', sprintf("run('%s');", strrep(script_name, "'", "''")));
end

function run_stage02(include_sub003)
%RUN_STAGE02 Run Stage 02 ICA and pipeline-completion scripts.
%
% run_stage02()              -> includes sub-003 completion
% run_stage02(true/false)    -> include/exclude sub-003 completion

if nargin < 1 || isempty(include_sub003)
    include_sub003 = true;
end

repo_root = get_repo_root();

jobs = {
    {'02_artifact_removal_ica', '01_ica_cleaning_open_eyes', 'ica_open_eyes_pipeline.m', 'Stage 02A'}, ...
    {'02_artifact_removal_ica', '02_ica_cleaning_closed_eyes', 'ica_closed_eyes_pipeline.m', 'Stage 02B'}, ...
    {'02_artifact_removal_ica', '03_ica_cleaning_13ch_comparison', 'ica_13ch_pipeline.m', 'Stage 02C'}, ...
    {'02_artifact_removal_ica', '04_rest_task_rest_analysis', 'rest_task_rest_ica_pipeline.m', 'Stage 02D'}, ...
    {'02_artifact_removal_ica', '05_pipeline_completion', 'sub035_pipeline_completion', 'pipeline_completion_sub035.m', 'Stage 02E (sub-035)'} ...
};

if include_sub003
    jobs{end+1} = {'02_artifact_removal_ica', '05_pipeline_completion', 'sub003_pipeline_completion', 'pipeline_completion_sub003.m', 'Stage 02E (sub-003)'};
end

for i = 1:numel(jobs)
    row = jobs{i};
    if numel(row) == 4
        stage_dir = fullfile(repo_root, row{1}, row{2});
        script_name = row{3};
        label = row{4};
    else
        stage_dir = fullfile(repo_root, row{1}, row{2}, row{3});
        script_name = row{4};
        label = row{5};
    end
    run_stage_script(stage_dir, script_name, label);
end
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

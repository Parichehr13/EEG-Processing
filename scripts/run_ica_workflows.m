function run_ica_workflows(include_subject_003)
%RUN_ICA_WORKFLOWS Run ICA case studies and preprocessing completion.
%
% run_ica_workflows() -> includes the subject-003 completion branch
% run_ica_workflows(false) -> skips the subject-003 completion branch

if nargin < 1 || isempty(include_subject_003)
    include_subject_003 = true;
end

repo_root = get_repo_root();

jobs = {
    {'pipeline', '02_artifact_removal_ica', '01_open_eyes_resting_state', 'ica_open_eyes_pipeline.m', 'ICA open-eyes case study'}, ...
    {'pipeline', '02_artifact_removal_ica', '02_closed_eyes_resting_state', 'ica_closed_eyes_pipeline.m', 'ICA closed-eyes case study'}, ...
    {'pipeline', '02_artifact_removal_ica', '03_reduced_channel_comparison', 'ica_13ch_pipeline.m', 'Reduced-channel ICA comparison'}, ...
    {'pipeline', '02_artifact_removal_ica', '04_rest_task_rest_spectral_dynamics', 'rest_task_rest_ica_pipeline.m', 'REST-TASK-REST spectral dynamics'}, ...
    {'pipeline', '02_artifact_removal_ica', '05_pipeline_completion', 'subject_035', 'pipeline_completion_sub035.m', 'Pipeline completion (subject 035)'} ...
};

if include_subject_003
    jobs{end+1} = {'pipeline', '02_artifact_removal_ica', '05_pipeline_completion', 'subject_003', 'pipeline_completion_sub003.m', 'Pipeline completion (subject 003)'};
end

for i = 1:numel(jobs)
    row = jobs{i};
    if numel(row) == 5
        module_dir = fullfile(repo_root, row{1}, row{2}, row{3});
        script_name = row{4};
        label = row{5};
    else
        module_dir = fullfile(repo_root, row{1}, row{2}, row{3}, row{4});
        script_name = row{5};
        label = row{6};
    end
    run_module_script(module_dir, script_name, label);
end
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

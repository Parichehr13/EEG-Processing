function run_all_exercises_export_figures()
%RUN_ALL_EXERCISES_EXPORT_FIGURES Run exercise scripts and export figures.

this_file = mfilename('fullpath');
repo_root = fileparts(fileparts(this_file));
addpath(fileparts(this_file));
add_eeglab_if_available();

jobs = {
    struct('dir', fullfile(repo_root, 'exercise1'), 'script', 'Exercise1_Solution.m', 'prefix', 'exercise1', 'maxf', 3), ...
    struct('dir', fullfile(repo_root, 'exercise2'), 'script', 'Exercise2_Solution.m', 'prefix', 'exercise2', 'maxf', 8), ...
    struct('dir', fullfile(repo_root, 'exercise3'), 'script', 'Exercise3_Solution.m', 'prefix', 'exercise3', 'maxf', 5), ...
    struct('dir', fullfile(repo_root, 'exercise4'), 'script', 'Exercise4_Solution.m', 'prefix', 'exercise4', 'maxf', 5), ...
    struct('dir', fullfile(repo_root, 'exercise5'), 'script', 'Exercise5_Solution.m', 'prefix', 'exercise5', 'maxf', 5), ...
    struct('dir', fullfile(repo_root, 'exercise6'), 'script', 'Exercise6_Solution.m', 'prefix', 'exercise6', 'maxf', 5), ...
    struct('dir', fullfile(repo_root, 'exercise7', 'Exercise7_Subj035'), 'script', 'Exercise7_Solution.m', 'prefix', 'exercise7_sub035', 'maxf', 6, 'figdir', fullfile(repo_root, 'exercise7', 'figures')), ...
    struct('dir', fullfile(repo_root, 'exercise7', 'Exercise1_7_Subj003'), 'script', 'Exercise7_Solution_Subj003.m', 'prefix', 'exercise7_sub003', 'maxf', 4, 'figdir', fullfile(repo_root, 'exercise7', 'figures')), ...
    struct('dir', fullfile(repo_root, 'exercise9'), 'script', 'Exercise9a_Solution.m', 'prefix', 'exercise9a', 'maxf', 2), ...
    struct('dir', fullfile(repo_root, 'exercise9'), 'script', 'Exercise9b_Solution.m', 'prefix', 'exercise9b', 'maxf', 2)
};

fprintf('\nRunning batch export from repo: %s\n', repo_root);

for i = 1:numel(jobs)
    run_one(jobs{i});
end

function add_eeglab_if_available()
candidates = {
    'D:\Eeg signal\programing\eeglab2024.1', ...
    fullfile(getenv('USERPROFILE'), 'Documents', 'MATLAB', 'eeglab2024.1'), ...
    fullfile(getenv('USERPROFILE'), 'Documents', 'MATLAB', 'eeglab2021.1')
};

for i = 1:numel(candidates)
    root = candidates{i};
    if isfile(fullfile(root, 'eeglab.m'))
        addpath(genpath(root));
        fprintf('EEGLAB path added: %s\n', root);
        return;
    end
end

fprintf('EEGLAB not found on known paths. topoplot-dependent sections may fail.\n');
end

fprintf('\nBatch export completed.\n');

end

function run_one(job)
orig_dir = pwd;
cleanup = onCleanup(@() cd(orig_dir));

close all force;

if ~isfield(job, 'figdir') || isempty(job.figdir)
    figdir = fullfile(job.dir, 'figures');
else
    figdir = job.figdir;
end

if ~exist(figdir, 'dir')
    mkdir(figdir);
end

fprintf('\n[%s] Running %s\n', job.prefix, job.script);

try
    cd(job.dir);

    % Exercise 9b expects TF_Power_GA.mat in the current folder.
    if strcmp(job.prefix, 'exercise9b') && ~isfile('TF_Power_GA.mat') && isfile(fullfile('9', 'TF_Power_GA.mat'))
        copyfile(fullfile('9', 'TF_Power_GA.mat'), 'TF_Power_GA.mat');
    end

    script_path = fullfile(job.dir, job.script);
    evalin('base', sprintf('run(''%s'');', script_path));

    files = save_open_figures(figdir, job.prefix, job.maxf);
    fprintf('[%s] Saved %d figure(s).\n', job.prefix, numel(files));
catch ME
    warning('[%s] Failed: %s', job.prefix, ME.message);
    try
        files = save_open_figures(figdir, job.prefix, job.maxf);
        fprintf('[%s] Saved %d figure(s) before failure.\n', job.prefix, numel(files));
    catch
        fprintf('[%s] No figures saved after failure.\n', job.prefix);
    end
end

close all force;

end
